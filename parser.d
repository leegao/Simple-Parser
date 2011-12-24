import scanner;
import std.stdio;

void parse_nonterminal_expr_(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-CODE"){
		// Nullable production: do not consume anything
		({
			// nonterminal_expr_ : \0
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		parse_nonterminal_expr(_ll_scanner);
		({
			// nonterminal_expr_ : nonterminal_expr
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_rule_stmt_(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-SEMI"){
		// Nullable production: do not consume anything
		({
			// rule_stmt_ : \0
		})();
	} else
	if (_ll_next.type == "LL-OR"){
		string _1 = _ll_scanner.read("LL-OR").value;
		parse_rule_stmt(_ll_scanner);
		({
			// rule_stmt_ : | rule
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_production_list(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-PRODUCTION"){
		parse_production_stmt(_ll_scanner);
		parse_production_list_(_ll_scanner);
		({
			// production_list
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_rule_list(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-IDENTIFIER"){
		string _1 = _ll_scanner.read("LL-IDENTIFIER").value;
		string _2 = _ll_scanner.read("LL-GETS").value;
		parse_rule_stmt(_ll_scanner);
		string _4 = _ll_scanner.read("LL-SEMI").value;
		parse_rule_list_(_ll_scanner);
		({
			// rule_list
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_production_stmt(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-PRODUCTION"){
		string _1 = _ll_scanner.read("LL-PRODUCTION").value;
		string _2 = _ll_scanner.read("LL-IDENTIFIER").value;
		string _3 = _ll_scanner.read("LL-IDENTIFIER").value;
		({
			// production_stmt
		})();
	} else
	throw new Exception("Cannot parse.");
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
	throw new Exception("Cannot parse.");
}

void parse_nonterminal_expr(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-IDENTIFIER"){
		string _1 = _ll_scanner.read("LL-IDENTIFIER").value;
		parse_nonterminal_expr_(_ll_scanner);
		({
			// nonterminal_expr : 1*
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_rule_stmt(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-CODE"){
		string _1 = _ll_scanner.read("LL-CODE").value;
		parse_rule_stmt_(_ll_scanner);
		({
			// rule_stmt : code
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		parse_nonterminal_expr(_ll_scanner);
		string _2 = _ll_scanner.read("LL-CODE").value;
		parse_rule_stmt_(_ll_scanner);
		({
			// rule_stmt : nonterminal_expr code
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_production_list_(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-IDENTIFIER"){
		// Nullable production: do not consume anything
		({
			// production_list_ : \0
		})();
	} else
	if (_ll_next.type == "LL-PRODUCTION"){
		parse_production_list(_ll_scanner);
		({
			// production_list_ : production
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_grammar(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-PRODUCTION"){
		parse_production_list(_ll_scanner);
		parse_rule_list(_ll_scanner);
		({
			// grammar : +productions
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		parse_rule_list(_ll_scanner);
		({
			// grammar : rule_list
		})();
	} else
	throw new Exception("Cannot parse.");
}

void parse_parser(Scanner _ll_scanner){
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == "LL-CODE"){
		string _1 = _ll_scanner.read("LL-CODE").value;
		parse_grammar(_ll_scanner);
		string _3 = _ll_scanner.read("EOF").value;
		({
			// parser : +usercode
		})();
	} else
	if (_ll_next.type == "LL-PRODUCTION"){
		parse_grammar(_ll_scanner);
		string _2 = _ll_scanner.read("EOF").value;
		({
			// parser : grammar
		})();
	} else
	if (_ll_next.type == "LL-IDENTIFIER"){
		parse_grammar(_ll_scanner);
		string _2 = _ll_scanner.read("EOF").value;
		({
			// parser : grammar
		})();
	} else
	throw new Exception("Cannot parse.");
}

