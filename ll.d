module ll;
import std.string, std.stdio, std.container;
import stack;

abstract class Production{
	static Nonterminal[] [string] rules;
	static string[string] types;
	static add_rules(string[] rules ...){
		assert(rules.length % 2 == 0);
		for (int i = 0; i < rules.length; i++){
			auto rule = rules[i++];
			Production.rules[rule] = std.array.minimallyInitializedArray!(Nonterminal[])(0);
			types[rule] = rules[i];
		}
	}
	
	bool nullable = false;
	abstract Terminal[] first();
	
	static Terminal[] [string] FOLLOW;
	static void compute_follow(){
		// Step 1: go through each rule and find productions that includes it in the form of
		// A -> alpha X beta
		// and set FOLLOW[X] s.t
		// FOLLOW[X] = FOLLOW[X] U beta.first() - \0
		string[string] nullable;
		
		foreach (string X, _; rules){
			Production.FOLLOW[X] = [];
			foreach (string A, Nonterminal[] productions; rules){
				get_next(productions, X, nullable, A);
			}
		}
		
		// reduce a worklist of follows
		// construct a queue of worklist
		auto worklist = new Queue!string;
		foreach (string X, _; nullable){
			worklist.push(X);	
		}
		
		while (!worklist.empty){
			string X = worklist.pop;
			
			auto app = std.array.appender(FOLLOW[X]);
			app.put(FOLLOW[nullable[X]]);
			Terminal[] ts = app.data.set;
			
			if (!FOLLOW[X].unchanged(ts)){
				FOLLOW[X] = ts;
				worklist.push(X);
			}
		}
	}
	
	static Nonterminal [Terminal][string] predictive_table;
	static void construct(){
		foreach (string X, Nonterminal[] nonterminals; Production.rules){
			Nonterminal[Terminal] cache;
			predictive_table[X] = cache;
			foreach (Nonterminal alpha; nonterminals){
				Terminal[] first_set = alpha.first;
				foreach (Terminal t; first_set){
					if (t.c == "\0"){
						foreach (Terminal f; FOLLOW[X]){
							assert (!(f in predictive_table[X]));
							predictive_table[X][f] = alpha;
						}
					} else {
						assert (!(t in predictive_table[X]));
						predictive_table[X][t] = alpha;
					}
				}
			}
		}
	}
}

bool unchanged(Terminal[] A, Terminal[] B){
	return A.length == B.length;	
}

void get_next(Nonterminal[] productions, string X, ref string[string] nullable, string A){
	auto app = std.array.appender(&Production.FOLLOW[X]);
	bool is_nullable = false;
	
	foreach (Nonterminal n; productions){
		bool found_it = false;
		string next = null;
		foreach(string p; n.cat){
			if (found_it == true){
				next = p;
				break;
			}
			if (p == X){
				found_it = true;
			}
		}
		
		if (found_it && next != null){
			// find its first
			Terminal[] terminals;
			auto app2 = std.array.appender(&terminals);
			if (next in Production.rules){
				// get the union
				Nonterminal[] u = Production.rules[next];
				foreach(Nonterminal p; u){
					Terminal[] first_set = p.first;
					if (first_set.contains_null)
						is_nullable = true;
					app2.put(first_set);	
				}
			} else {
				app2.put(Terminal[next]);
				if (next == "\0")
					is_nullable = true;
			}
			app.put(terminals.set_minus_epsilon);
		} else if (found_it){
			is_nullable = true;
		}
	}
	
	if (is_nullable){
		//writefln("%s -> alpha %s beta",A,X);
		nullable[X] = A;
	}
}

class Terminal : Production{
	string c;
	static Terminal[string] terminals;
	this(string c){
		this.c = c;
		this.nullable = (c == "\0");
		Terminal.terminals[c] = this;
	}
	
	Terminal[] first(){
		return [this];
	}
	
	string toString(){
		if (c == "\0")
			return r"\0";
		return c;
	}
	
	static ref Terminal opIndex(string c){
		if (!(c in terminals)) 
			new Terminal(c);
		return terminals[c];
	}
}

class Nonterminal : Production{
	// only valid constructions are concatenations of production aliases
	string[] cat;
	string code;
	
	this(string code){
		this.code = code;	
	}
	
	Terminal[] first_cache = null;
	Terminal[] first(){
		if (first_cache != null)
			return first_cache;
		
		Terminal[] terminals;
		auto app = std.array.appender(&terminals);
		bool nullable = false;
		foreach (string rule; cat){
			if (rule in Production.rules){
				// get the union
				Nonterminal[] u = Production.rules[rule];
				foreach(Nonterminal p; u){
					Terminal[] first_set = p.first;
					if (first_set.contains_null)
						nullable = true;
					app.put(first_set);	
				}
				
				if (!nullable)
					break;
			} else {
				// only append the first element
				app.put(Terminal[rule]);
				break;
			}
		}
		
		// cache and return
		first_cache = terminals;
		return terminals;
	}
}

bool contains_null(Terminal[] first){
	foreach(Terminal t; first){
		if (t.c == "\0")
			return true;
	}
	return false;
}

Terminal[] set(Terminal[] first){
	Terminal[] terminals;	
	bool[Terminal] seen;
	auto app = std.array.appender(&terminals);
	foreach(Terminal t; first){
		if (!(t in seen)){
			app.put(t);	
			seen[t] = true;
		}
	}
	return terminals;
}

Terminal[] set_minus_epsilon(Terminal[] first){
	Terminal[] terminals;	
	bool[Terminal] seen;
	seen[Terminal["\0"]] = true;
	auto app = std.array.appender(&terminals);
	foreach(Terminal t; first){
		if (!(t in seen)){
			app.put(t);	
			seen[t] = true;
		}
	}
	return terminals;
}

Nonterminal[] production(string[][][] rules){
	Nonterminal[] productions;
	auto pa = std.array.appender(&productions);
	foreach (string[][] rule_and_code; rules){
		string[] rule = rule_and_code[0];
		string code = rule_and_code[1][0];
		int j = 0;
		Nonterminal n = new Nonterminal(code);
		auto aa = std.array.appender(&n.cat);
		foreach (string p; rule){
			aa.put(p);
		}
		pa.put(n);
	}
	
	return pa.data;
}

string[][] rule(string[] rule, string code){
	return [rule, [code]];
}