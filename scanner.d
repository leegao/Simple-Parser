module scanner;
import stack;

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
		assert(t.type == type);
		return t;
	}
	
	void write(Token t){
		stream.push(t);
	}
}