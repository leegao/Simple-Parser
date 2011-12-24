import std.stdio, std.cstream;
import ll, codegen, scanner;
import stack;

void main(string[] args)
{
/*	Production.add_rules([
		"production_stmt", "string[]",
		
		"nonterminal_expr", "string[]",
		"nonterminal_expr_", "string[]",
		
		"rule_stmt", "Nonterminal[]",
		"rule_stmt_", "Nonterminal[]",
		
		"production_list", "string[]",
		"production_list_", "string[]",
		
		"rule_list", "void",
		"rule_list_", "void",
		
		"grammar", "void",
		"parser", "string"]
	);
	
	// production_stmt ::= LL-PRODUCTION LL-IDENTIFIER LL-IDENTIFIER
	Production.rules["production_stmt"] = [
		["LL-PRODUCTION", "LL-IDENTIFIER", "LL-IDENTIFIER"].rule("// production_stmt\nreturn [_2, _3];\n"),
	].production;
	
	// nonterminal_expr ::= LL-IDENTIFIER nonterminal_expr_
	Production.rules["nonterminal_expr"] = [
			["LL-IDENTIFIER", "nonterminal_expr_"].rule(
				"// nonterminal_expr : 1*\n"
				"return [_1] ~ _2;\n"
			)
		].production;
	
	// nonterminal_expr_ ::= \0
	// | nonterminal_expr 
	Production.rules["nonterminal_expr_"] = [
			["\0"].rule("// nonterminal_expr_ : \\0\nreturn [];\n"),
			["nonterminal_expr"].rule("// nonterminal_expr_ : nonterminal_expr\nreturn _1;\n")
		].production;
	
	// rule_stmt ::= LL-CODE rule_stmt_
	// | nonterminal_expr LL-CODE rule_stmt_
	Production.rules["rule_stmt"] = [
			["LL-CODE", "rule_stmt_"].rule(
				"// rule_stmt : code\n"
				"Nonterminal n = new Nonterminal(_1);\n"
				"n.cat = [\"\\0\"];\n"
				"return [n] ~ _2;\n"
			),
			
			["nonterminal_expr", "LL-CODE", "rule_stmt_"].rule(
				"// rule_stmt : nonterminal_expr code\n"
				"Nonterminal n = new Nonterminal(_2);\n"
				"n.cat = _1;\n"
				"return [n] ~ _3;\n"
			)
		].production;
	
	// rule_stmt_ ::= 
	// | LL-OR rule_stmt
	Production.rules["rule_stmt_"] = [
			["\0"].rule("// rule_stmt_ : \\0\nreturn [];\n"),
			["LL-OR", "rule_stmt"].rule("// rule_stmt_ : | rule\nreturn _2;\n")
		].production;
	
	// production_list ::= production_stmt production_list_
	Production.rules["production_list"] = [
			["production_stmt", "production_list_"].rule("// production_list\nreturn _1 ~ _2;\n")
		].production;

	// production_list_ ::= 
	// | production_list
	Production.rules["production_list_"] = [
			["\0"].rule("// production_list_ : \\0\nreturn [];\n"),
			["production_list"].rule("// production_list_ : production\nreturn _1;\n")
		].production;
	
	// rule_list ::= LL-IDENTIFIER LL-GETS  rule_stmt rule_list_
	Production.rules["rule_list"] = [
			["LL-IDENTIFIER", "LL-GETS", "rule_stmt", "LL-SEMI", "rule_list_"].rule("// rule_list\nProduction.rules[_1] = _3;\n")
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
			["production_list", "rule_list"].rule("// grammar : +productions\nProduction.add_rules(_1);\n"),
			["rule_list"].rule("// grammar : rule_list")
		].production;
	
	// parser ::= LL-CODE grammar EOF
	// | grammar EOF
	Production.rules["parser"] = [
			["LL-CODE", "grammar", "EOF"].rule("// parser : +usercode\nreturn _1;\n"),
			["grammar", "EOF"].rule("// parser : grammar\nreturn \"\";\n")
		].production;
	
	Production.compute_follow;
	Production.construct;
	
	CodeGen cg = new CodeGen(Production.predictive_table, Production.types);
	
	cg.usercode = "import std.stdio;\n"
		"import ll;";
	string code = cg.generate;
	
	auto f = std.stdio.File("../parser.d", "w");
    scope(exit) f.close();
	
	f.write(code);*/
	string file = (args.length > 1) ? args[1] : "grammar.y";
	auto f2 = new std.stream.File(file);
	scope(exit) f2.close();
	
	import parser;
	string code = ll_parse(f2);
	
	writeln(code);
	
	//auto f = std.stdio.File("../test_parser.d", "w");
    //scope(exit) f.close();
	
	//f.write(code);
}
