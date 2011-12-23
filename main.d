import std.stdio, std.cstream;
import ll, codegen;

void main(string[] args)
{
	// Our brainfuck grammar contains the following productions
	Production.add_rules(
		"Operators", "string",
		"Expression", "string",
		"Expression_", "string"
	);
	
	string ez_code = "writeln(_1); return _1;";
	
	// Operators -> > | < | + | - | . | ,
	Production.rules["Operators"] = [
		[">>"].rule(ez_code), 
		["<"].rule(ez_code), 
		["+"].rule(ez_code), 
		["-"].rule(ez_code), 
		["."].rule(ez_code), 
		[","].rule(ez_code)
	].production;
	
	// Expression -> Operators Expression'
	//             | [ Expression ] Expression'
	Production.rules["Expression"] = [
			["Operators", "Expression'"].rule(
				"writefln(\"E -> O E': %s %s\", _1, _2);\n"
				"return std.string.format(\"%s %s\", _1, _2);"
			),
			
			["[", "Expression", "]", "Expression_"].rule(
				"writefln(\"E -> [E] E': [%s] %s\", _1, _2);\n"
				"return std.string.format(\"[%s] %s\", _1, _2);"
			)
		].production;
	
	// Expression' -> Expression
	//              | epsilon
	Production.rules["Expression_"] = [
			["Expression"].rule("return _1;"),
			["\0"].rule("return \"\";")
		].production;
	
	Production.compute_follow;
	Production.construct;
	
	//foreach(string s, Nonterminal[Terminal] row; Production.predictive_table){
		//write(s, "\t");
		//foreach(Terminal t, _; row){
			//write(t," ", _.cat);	
		//}
		//writeln();
	//}
	
	CodeGen cg = new CodeGen(Production.predictive_table, Production.types);
	cg.generate;
}
