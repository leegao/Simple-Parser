import std.stdio, std.cstream;
import ll, codegen, scanner;
import stack;

void main(string[] args)
{
	Production.add_rules(
		"production_stmt", "void",
		
		"nonterminal_expr", "void",
		"nonterminal_expr_", "void",
		
		"rule_stmt", "void",
		"rule_stmt_", "void",
		
		"production_list", "void",
		"production_list_", "void",
		
		"rule_list", "void",
		"rule_list_", "void",
		
		"grammar", "void",
		"parser", "void"
	);
	
	// production_stmt ::= LL-PRODUCTION LL-IDENTIFIER LL-IDENTIFIER
	Production.rules["production_stmt"] = [
		["LL-PRODUCTION", "LL-IDENTIFIER", "LL-IDENTIFIER"].rule("// production_stmt"),
	].production;
	
	// nonterminal_expr ::= LL-IDENTIFIER nonterminal_expr_
	Production.rules["nonterminal_expr"] = [
			["LL-IDENTIFIER", "nonterminal_expr_"].rule(
				"// nonterminal_expr : 1*"
			)
		].production;
	
	// nonterminal_expr_ ::= \0
	// | nonterminal_expr 
	Production.rules["nonterminal_expr_"] = [
			["\0"].rule("// nonterminal_expr_ : \\0"),
			["nonterminal_expr"].rule("// nonterminal_expr_ : nonterminal_expr")
		].production;
	
	// rule_stmt ::= LL-CODE rule_stmt_
	// | nonterminal_expr LL-CODE rule_stmt_
	Production.rules["rule_stmt"] = [
			["LL-CODE", "rule_stmt_"].rule(
				"// rule_stmt : code"
			),
			
			["nonterminal_expr", "LL-CODE", "rule_stmt_"].rule(
				"// rule_stmt : nonterminal_expr code"
			)
		].production;
	
	// rule_stmt_ ::= 
	// | LL-OR rule_stmt
	Production.rules["rule_stmt_"] = [
			["\0"].rule("// rule_stmt_ : \\0"),
			["LL-OR", "rule_stmt"].rule("// rule_stmt_ : | rule")
		].production;
	
	// production_list ::= production_stmt production_list_
	Production.rules["production_list"] = [
			["production_stmt", "production_list_"].rule("// production_list")
		].production;

	// production_list_ ::= 
	// | production_list
	Production.rules["production_list_"] = [
			["\0"].rule("// production_list_ : \\0"),
			["production_list"].rule("// production_list_ : production")
		].production;
	
	// rule_list ::= LL-IDENTIFIER LL-GETS  rule_stmt rule_list_
	Production.rules["rule_list"] = [
			["LL-IDENTIFIER", "LL-GETS", "rule_stmt", "LL-SEMI", "rule_list_"].rule("// rule_list")
		].production;

	// rule_list_ ::= 
	// | production_list
	Production.rules["rule_list_"] = [
			["\0"].rule("// rule_list_ : \\0"),
			["rule_list"].rule("// rule_list_ : rule")
		].production;
	
	// grammar ::= production_list rule_list
	// | rule_list
	Production.rules["grammar"] = [
			["production_list", "rule_list"].rule("// grammar : +productions"),
			["rule_list"].rule("// grammar : rule_list")
		].production;
	
	// parser ::= LL-CODE grammar EOF
	// | grammar EOF
	Production.rules["parser"] = [
			["LL-CODE", "grammar", "EOF"].rule("// parser : +usercode"),
			["grammar", "EOF"].rule("// parser : grammar")
		].production;
	
	Production.compute_follow;
	Production.construct;
	
	CodeGen cg = new CodeGen(Production.predictive_table, Production.types);
	cg.usercode = "import std.stdio;\n";
	string code = cg.generate;
	
	//auto f = std.stdio.File("../parser.d", "w");
    //scope(exit) f.close();
	
	//f.write(code);
	
	auto f = new std.stream.File("../grammar.y");
	import ll_lex;
	
	SimpleLexer lex = new SimpleLexer(f);
	Token t = lex.read;
	Scanner scanner = new Scanner;
	while (t.type != "EOF"){
		//writefln("%s	%s", t.type, t.value);
		scanner.write(t);
		t = lex.read;
	}
	scanner.write(t);
	
	import parser;
	
	parse_parser(scanner);
}
