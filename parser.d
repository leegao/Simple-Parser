import scanner, std.string;
import std.stdio;
import ll;
string[] parse_nonterminal_expr_(Scanner _ll_scanner){
	string[] _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-CODE"){
		// Nullable production: do not consume anything
		_ll_result = (cast(string[] delegate()){
			// nonterminal_expr_ : \0
			return [];
			
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		string[] _1 = parse_nonterminal_expr(_ll_scanner);
		_ll_result = (cast(string[] delegate()){
			// nonterminal_expr_ : nonterminal_expr
			return _1;
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production nonterminal_expr_".format(_ll_next.type));
	return _ll_result;
}

Nonterminal[] parse_rule_stmt_(Scanner _ll_scanner){
	Nonterminal[] _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-SEMI"){
		// Nullable production: do not consume anything
		_ll_result = (cast(Nonterminal[] delegate()){
			// rule_stmt_ : \0
			return [];
			
		})();
	} else
	if (_ll_next.type == "LL-OR"){
		string _1 = _ll_scanner.read("LL-OR").value;
		Nonterminal[] _2 = parse_rule_stmt(_ll_scanner);
		_ll_result = (cast(Nonterminal[] delegate()){
			// rule_stmt_ : | rule
			return _2;
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production rule_stmt_".format(_ll_next.type));
	return _ll_result;
}

string[] parse_production_list(Scanner _ll_scanner){
	string[] _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-PRODUCTION"){
		string[] _1 = parse_production_stmt(_ll_scanner);
		string[] _2 = parse_production_list_(_ll_scanner);
		_ll_result = (cast(string[] delegate()){
			// production_list
			return _1 ~ _2;
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production production_list".format(_ll_next.type));
	return _ll_result;
}

void parse_rule_list(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-IDENTIFIER"){
		string _1 = _ll_scanner.read("LL-IDENTIFIER").value;
		string _2 = _ll_scanner.read("LL-GETS").value;
		Nonterminal[] _3 = parse_rule_stmt(_ll_scanner);
		string _4 = _ll_scanner.read("LL-SEMI").value;
		parse_rule_list_(_ll_scanner);
		({
			// rule_list
			Production.rules[_1] = _3;
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production rule_list".format(_ll_next.type));
}

string[] parse_production_stmt(Scanner _ll_scanner){
	string[] _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-PRODUCTION"){
		string _1 = _ll_scanner.read("LL-PRODUCTION").value;
		string _2 = _ll_scanner.read("LL-IDENTIFIER").value;
		string _3 = _ll_scanner.read("LL-IDENTIFIER").value;
		_ll_result = (cast(string[] delegate()){
			// production_stmt
			return [_2, _3];
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production production_stmt".format(_ll_next.type));
	return _ll_result;
}

void parse_rule_list_(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "EOF"){
		// Nullable production: do not consume anything
		({
			// rule_list_ : \0
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		parse_rule_list(_ll_scanner);
		({
			// rule_list_ : rule
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production rule_list_".format(_ll_next.type));
}

string[] parse_nonterminal_expr(Scanner _ll_scanner){
	string[] _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-IDENTIFIER"){
		string _1 = _ll_scanner.read("LL-IDENTIFIER").value;
		string[] _2 = parse_nonterminal_expr_(_ll_scanner);
		_ll_result = (cast(string[] delegate()){
			// nonterminal_expr : 1*
			return [_1] ~ _2;
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production nonterminal_expr".format(_ll_next.type));
	return _ll_result;
}

Nonterminal[] parse_rule_stmt(Scanner _ll_scanner){
	Nonterminal[] _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-CODE"){
		string _1 = _ll_scanner.read("LL-CODE").value;
		Nonterminal[] _2 = parse_rule_stmt_(_ll_scanner);
		_ll_result = (cast(Nonterminal[] delegate()){
			// rule_stmt : code
			Nonterminal n = new Nonterminal(_1);
			n.cat = ["\0"];
			return [n] ~ _2;
			
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		string[] _1 = parse_nonterminal_expr(_ll_scanner);
		string _2 = _ll_scanner.read("LL-CODE").value;
		Nonterminal[] _3 = parse_rule_stmt_(_ll_scanner);
		_ll_result = (cast(Nonterminal[] delegate()){
			// rule_stmt : nonterminal_expr code
			Nonterminal n = new Nonterminal(_2);
			n.cat = _1;
			return [n] ~ _3;
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production rule_stmt".format(_ll_next.type));
	return _ll_result;
}

string[] parse_production_list_(Scanner _ll_scanner){
	string[] _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-IDENTIFIER"){
		// Nullable production: do not consume anything
		_ll_result = (cast(string[] delegate()){
			// production_list_ : \0
			return [];
			
		})();
	} else
	if (_ll_next.type == "LL-PRODUCTION"){
		string[] _1 = parse_production_list(_ll_scanner);
		_ll_result = (cast(string[] delegate()){
			// production_list_ : production
			return _1;
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production production_list_".format(_ll_next.type));
	return _ll_result;
}

void parse_grammar(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-PRODUCTION"){
		string[] _1 = parse_production_list(_ll_scanner);
		parse_rule_list(_ll_scanner);
		({
			// grammar : +productions
			Production.add_rules(_1);
			
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		parse_rule_list(_ll_scanner);
		({
			// grammar : rule_list
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production grammar".format(_ll_next.type));
}

string parse_parser(Scanner _ll_scanner){
	string _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-CODE"){
		string _1 = _ll_scanner.read("LL-CODE").value;
		parse_grammar(_ll_scanner);
		string _3 = _ll_scanner.read("EOF").value;
		_ll_result = (cast(string delegate()){
			// parser : +usercode
			return _1;
			
		})();
	} else
	if (_ll_next.type == "LL-PRODUCTION"){
		parse_grammar(_ll_scanner);
		string _2 = _ll_scanner.read("EOF").value;
		_ll_result = (cast(string delegate()){
			// parser : grammar
			return "";
			
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		parse_grammar(_ll_scanner);
		string _2 = _ll_scanner.read("EOF").value;
		_ll_result = (cast(string delegate()){
			// parser : grammar
			return "";
			
		})();
	} else
	throw new Exception("Not expecting first of '%s' in production parser".format(_ll_next.type));
	return _ll_result;
}

