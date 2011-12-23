module codegen;

import std.string, std.stdio;
import ll;

class CodeGen{
	Nonterminal[Terminal][string] table;
	string[string] types;
	this(Nonterminal[Terminal][string] table, string[string] types) {
		this.table = table;
		this.types = types;
	}
	
	string generate(){
		foreach (string rule, Nonterminal[Terminal] productions; table){
			writeln(rule);
			// set up the function rule
			string current = "%s parse_%s(Scanner _ll_scanner){\n".format(types[rule],rule);
			current = current ~ "\t%s _ll_return;\n".format(types[rule]);
			current = current ~ "\tauto _ll_next = _ll_scanner.next;\n";
			foreach (Terminal t, Nonterminal n; productions){
				current = current ~ "\tif (_ll_next.type == \"%s\"){\n".format(t.c);
				int i = 1;
				foreach (string c; n.cat){
					if (c in table){
						// production rule, call its parser
						string type = types[c];
						if (type != "void"){
							current = current ~ "\t\t%s _%s = parse_%s(_ll_scanner);\n".format(types[c],i,c);
						} else {
							current = current ~ "\t\tparse_%s(_ll_scanner);\n".format(c);
						}
					} else {
						// not a production, consume the next token and make sure they have the same type
						if (c != "\0"){
							current = current ~ "\t\tstring _%s = _ll_scanner.read(\"%s\").value;\n".format(i,c);
						} else {
							// do not consume anything;
							current = current ~ "\t\t// Nullable production: do not consume anything\n";
						}
					}
					i++;
				}
				current = current ~ "\t\t _ll_result = {\n\t\t\t%s\n\t\t}();\n".format(n.code);
				current = current ~ "\t} else\n";
			}
			current = current ~ "\t throw new Exception(\"Cannot parse.\");\n";
			current = current ~ "\t return _ll_result;\n";
			current = current ~ "}\n";
			writeln(current);
		}
		
		return "";
	}
}