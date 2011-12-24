module scanner;
import stack;
import std.string;

class Token{
	string value;
	string type;
	
	this(string value, string type){
		this.value = value;
		this.type = type;
	}
	
	override bool opEquals(Object that){
		Token other = cast(Token) that;
		return value == other.value && type == other.type;
	}
}

class Scanner{
	// token stream
	Queue!Token stream;
	this(){
		stream = new Queue!Token;	
	}
	
	bool empty(){
		return stream.empty;	
	}
	
	Token next(){
		return stream.peek;
	}
	
	Token read(){
		return stream.pop;
	}
	
	Token read(string type){
		Token t = read;
		if (t.type != type)
			throw new Exception("Expected %s, but got %s(%s)".format(type, t.type, t.value));
		return t;
	}
	
	void write(Token t){
		stream.push(t);
	}
}