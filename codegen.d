module codegen;

import std.string, std.stdio;
import ll;

class CodeGen{
	Nonterminal[Terminal][string] table;
	string[string] types;
	string usercode = "";
	this(Nonterminal[Terminal][string] table, string[string] types) {
		this.table = table;
		this.types = types;
	}
	
	string prolog(){
		string code = "import scanner;\n";
		code = code ~ "%s\n".format(usercode);
		return code;
	}
	
	string generate(){
		string code = prolog;
		foreach (string rule, Nonterminal[Terminal] productions; table){
			// set up the function rule
			string current = "%s parse_%s(Scanner _ll_scanner){\n".format(types[rule],rule);
			current = current ~ "\t%s _ll_result;\n".format(types[rule]);
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
				//std.string.translate(current, ['\n':"\n\t\t\t"]);
				current = current ~ "\t\t_ll_result = {\n\t\t\t%s\n\t\t}();\n".format(n.code.translate(['\n':"\n\t\t\t"]));
				current = current ~ "\t} else\n";
			}
			current = current ~ "\tthrow new Exception(\"Cannot parse.\");\n";
			current = current ~ "\treturn _ll_result;\n";
			current = current ~ "}\n\n";
			code = code ~ current;
		}
		
		return code;
	}
}