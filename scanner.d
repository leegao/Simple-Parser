module scanner;

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
	
}