//terminal LL-CODE LL-PRODUCTION LL-IDENTIFIER LL-GETS LL-OR LL-SEMI EOF

{:
import ll, ll_lex, codegen;
string ll_parse(Scanner scanner){
	string usercode = parse_parser(scanner);
	
	Production.compute_follow;
	Production.construct;
	
	CodeGen cg = new CodeGen(Production.predictive_table, Production.types);
	cg.usercode = usercode;
	
	return cg.generate;
}

string ll_parse(std.stream.InputStream stream){
	SimpleLexer lex = new SimpleLexer(stream);
	Token t = lex.read;
	Scanner scanner = new Scanner;
	while (t.type != "EOF"){
		scanner.write(t);
		t = lex.read;
	}
	scanner.write(t);
	return ll_parse(scanner);
}
:}

%production production_stmt string[]

%production nonterminal_expr string[]
%production nonterminal_expr_ string[]

%production rule_stmt Nonterminal[]
%production rule_stmt_ Nonterminal[]

%production production_list string[]
%production production_list_ string[]

%production rule_list void
%production rule_list_ void

%production grammar void
%production parser string

production_stmt ::= LL-PRODUCTION LL-IDENTIFIER LL-IDENTIFIER
// %production rule type
{:
	// production-stmt
	return [_2, _3];
:}
;

nonterminal_expr ::= LL-IDENTIFIER nonterminal_expr_
{:
	// nonterminal-expr : 1+
	return [_1] ~ _2;
:}
;

nonterminal_expr_ ::= 
{:
	return [];
:}
| nonterminal_expr 
{:
	return _1;
:}
;

rule_stmt ::= LL-CODE rule_stmt_
{:
	// rule-stmt : epsilon code
	Nonterminal n = new Nonterminal(_1);
	n.cat = ["\0"];
	return [n] ~ _2;
:}
| nonterminal_expr LL-CODE rule_stmt_
{:
	// rule-stmt : nonterminal-expr code
	Nonterminal n = new Nonterminal(_2);
	n.cat = _1;
	return [n] ~ _3;
:}
;

rule_stmt_ ::= 
{:
	return [];
:}
| LL-OR rule_stmt
{:
	return _2;
:}
;

production_list ::= production_stmt production_list_
{:
	return _1 ~ _2;
:}
;

production_list_ ::= 
{:
	return [];
:}
| production_list
{:
	return _1;
:}
;

rule_list ::= LL-IDENTIFIER LL-GETS rule_stmt LL-SEMI rule_list_
{:
	Production.rules[_1] = _3;
:}
;

rule_list_ ::= 
{:
	// pass
:}
| rule_list
{:
	// pass
:}
;

grammar ::= production_list rule_list
{:
	Production.add_rules(_1);
:}
| rule_list
{:
	// pass
:}
;

parser ::= LL-CODE grammar EOF
{:
	return _1;
:}
| grammar EOF
{:
	return "";
:}
;