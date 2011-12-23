import std.stdio, std.cstream;
import ll, codegen, scanner;

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
		[">"].rule(ez_code), 
		["<"].rule(ez_code), 
		["+"].rule(ez_code), 
		["-"].rule(ez_code), 
		["."].rule(ez_code), 
		[","].rule(ez_code)
	].production;
	
	// Expression -> Operators Expression'
	//             | [ Expression ] Expression'
	Production.rules["Expression"] = [
			["Operators", "Expression_"].rule(
				"writefln(\"E -> O E': %s %s\", _1, _2);\n"
				"return std.string.format(\"%s %s\", _1, _2);"
			),
			
			["[", "Expression", "]", "Expression_"].rule(
				"writefln(\"E -> [E] E': [%s] %s\", _2, _4);\n"
				"return std.string.format(\"[%s] %s\", _2, _4);"
			)
		].production;
	
	// Expression' -> Expression
	//              | EOF
	//              | epsilon
	Production.rules["Expression_"] = [
			["Expression"].rule("writefln(\"E' -> E: %s\",_1);return _1;"),
			["EOF"].rule("writeln(\"EOF\");return \"\";"),
			["\0"].rule("return \"\";")
		].production;
	
	Production.compute_follow;
	Production.construct;
	
	CodeGen cg = new CodeGen(Production.predictive_table, Production.types);
	cg.usercode = "import std.stdio;\n";
	string code = cg.generate;
	
	auto f = std.stdio.File("../parser.d", "w");
    scope(exit) f.close();
	
	f.write(code);
	
	Scanner scanner = new Scanner;
	// code -> << > + - [ + - ]
	scanner.write(new Token(">", ">"));
	scanner.write(new Token("<", "<"));
	scanner.write(new Token("+", "+"));
	scanner.write(new Token("[", "["));
	scanner.write(new Token("+", "+"));
	scanner.write(new Token("-", "-"));
	scanner.write(new Token("]", "]"));
	scanner.write(new Token("", "EOF"));
	
	writeln(scanner.stream.in_stack.peek);
	
	import parser;
	parse_Expression(scanner);
}
