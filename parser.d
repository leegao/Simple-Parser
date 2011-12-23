import scanner;
import std.stdio;

string parse_Expression(Scanner _ll_scanner){
	string _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == ">>"){
		string _1 = parse_Operators(_ll_scanner);
		string _2 = parse_Expression_(_ll_scanner);
		 _ll_result = {
			writefln("E -> O E': %s %s", _1, _2);
			return std.string.format("%s %s", _1, _2);
		}();
	} else
	if (_ll_next.type == "<"){
		string _1 = parse_Operators(_ll_scanner);
		string _2 = parse_Expression_(_ll_scanner);
		 _ll_result = {
			writefln("E -> O E': %s %s", _1, _2);
			return std.string.format("%s %s", _1, _2);
		}();
	} else
	if (_ll_next.type == "+"){
		string _1 = parse_Operators(_ll_scanner);
		string _2 = parse_Expression_(_ll_scanner);
		 _ll_result = {
			writefln("E -> O E': %s %s", _1, _2);
			return std.string.format("%s %s", _1, _2);
		}();
	} else
	if (_ll_next.type == "-"){
		string _1 = parse_Operators(_ll_scanner);
		string _2 = parse_Expression_(_ll_scanner);
		 _ll_result = {
			writefln("E -> O E': %s %s", _1, _2);
			return std.string.format("%s %s", _1, _2);
		}();
	} else
	if (_ll_next.type == "."){
		string _1 = parse_Operators(_ll_scanner);
		string _2 = parse_Expression_(_ll_scanner);
		 _ll_result = {
			writefln("E -> O E': %s %s", _1, _2);
			return std.string.format("%s %s", _1, _2);
		}();
	} else
	if (_ll_next.type == ","){
		string _1 = parse_Operators(_ll_scanner);
		string _2 = parse_Expression_(_ll_scanner);
		 _ll_result = {
			writefln("E -> O E': %s %s", _1, _2);
			return std.string.format("%s %s", _1, _2);
		}();
	} else
	if (_ll_next.type == "["){
		string _1 = _ll_scanner.read("[").value;
		string _2 = parse_Expression(_ll_scanner);
		string _3 = _ll_scanner.read("]").value;
		string _4 = parse_Expression_(_ll_scanner);
		 _ll_result = {
			writefln("E -> [E] E': [%s] %s", _2, _4);
			return std.string.format("[%s] %s", _2, _4);
		}();
	} else
	 throw new Exception("Cannot parse.");
	 return _ll_result;
}

string parse_Operators(Scanner _ll_scanner){
	string _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == ">>"){
		string _1 = _ll_scanner.read(">>").value;
		 _ll_result = {
			writeln(_1); return _1;
		}();
	} else
	if (_ll_next.type == "<"){
		string _1 = _ll_scanner.read("<").value;
		 _ll_result = {
			writeln(_1); return _1;
		}();
	} else
	if (_ll_next.type == "+"){
		string _1 = _ll_scanner.read("+").value;
		 _ll_result = {
			writeln(_1); return _1;
		}();
	} else
	if (_ll_next.type == "-"){
		string _1 = _ll_scanner.read("-").value;
		 _ll_result = {
			writeln(_1); return _1;
		}();
	} else
	if (_ll_next.type == "."){
		string _1 = _ll_scanner.read(".").value;
		 _ll_result = {
			writeln(_1); return _1;
		}();
	} else
	if (_ll_next.type == ","){
		string _1 = _ll_scanner.read(",").value;
		 _ll_result = {
			writeln(_1); return _1;
		}();
	} else
	 throw new Exception("Cannot parse.");
	 return _ll_result;
}

string parse_Expression_(Scanner _ll_scanner){
	string _ll_result;
	auto _ll_next = _ll_scanner.next;
	if (_ll_next.type == ">>"){
		string _1 = parse_Expression(_ll_scanner);
		 _ll_result = {
			return _1;
		}();
	} else
	if (_ll_next.type == "<"){
		string _1 = parse_Expression(_ll_scanner);
		 _ll_result = {
			return _1;
		}();
	} else
	if (_ll_next.type == "+"){
		string _1 = parse_Expression(_ll_scanner);
		 _ll_result = {
			return _1;
		}();
	} else
	if (_ll_next.type == "-"){
		string _1 = parse_Expression(_ll_scanner);
		 _ll_result = {
			return _1;
		}();
	} else
	if (_ll_next.type == "."){
		string _1 = parse_Expression(_ll_scanner);
		 _ll_result = {
			return _1;
		}();
	} else
	if (_ll_next.type == ","){
		string _1 = parse_Expression(_ll_scanner);
		 _ll_result = {
			return _1;
		}();
	} else
	if (_ll_next.type == "["){
		string _1 = parse_Expression(_ll_scanner);
		 _ll_result = {
			return _1;
		}();
	} else
	if (_ll_next.type == "EOF"){
		string _1 = _ll_scanner.read("EOF").value;
		 _ll_result = {
			return "";
		}();
	} else
	if (_ll_next.type == "]"){
		// Nullable production: do not consume anything
		 _ll_result = {
			return "";
		}();
	} else
	 throw new Exception("Cannot parse.");
	 return _ll_result;
}

