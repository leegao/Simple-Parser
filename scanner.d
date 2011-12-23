module scanner;
import stack;

class token{
	string value;
	string type;
	
	this(string value, string type){
		this.value = value;
		this.type = type;
	}
	
	override bool opEquals(Object that){
		token other = cast(token)that;
		return value == other.value && type == other.type;
	}
}

class scanner{
	// token stream
	Queue!token stream;
	this(){
		stream = new Queue!token;	
	}
	
	bool empty(){
		return stream.empty;	
	}
	
	token next(){
		return stream.peek;
	}
	
	token read(){
		return stream.pop;
	}
	
	token read(string type){
		token t = read;
		assert(t.type == type);
		return t;
	}
	
	void write(token t){
		stream.push(t);
	}
}