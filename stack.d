module stack;
import std.array;
class stack{
	string[] stack;
	int i;
	this(){
		stack.length = 8;
		i = 0;
	}
	bool empty(){
		return i == 0;	
	}
	void push(string s){
		if (i >= stack.length){
			stack.length = stack.length * 2;
		}
		stack[i++] = s;
	}
	
	string pop(){
		if (i > 0)
			return stack[--i];
		return null;
	}
}