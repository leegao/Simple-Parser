module stack;
import std.array;
class Stack(T){
	T[] store;
	int i;
	
	this(){
		store.length = 8;
		i = 0;
	}
	
	bool empty(){
		return i == 0;	
	}
	
	void push(T s){
		if (i >= store.length){
			store.length = store.length * 2;
		}
		store[i++] = s;
	}
	
	ref T peek(){
		assert(!empty);
		return store[i];
	}
	
	T pop(){
		assert(!empty);
		return store[--i];
	}
}

class Queue(T){
	Stack!T in_stack;
	Stack!T out_stack;
	this(){
		in_stack = new Stack!T;
		out_stack = new Stack!T;
	}
	
	bool empty(){
		return in_stack.empty && out_stack.empty;	
	}
	
	void push(T s){
		in_stack.push(s);	
	}
	
	T pop(){
		assert(!empty);
		if (out_stack.empty){
			while(!in_stack.empty){
				out_stack.push(in_stack.pop);
			}	
		}
		return out_stack.pop;
	}
	
	T peek(){
		assert(!empty);
		if (out_stack.empty){
			while(!in_stack.empty){
				out_stack.push(in_stack.pop);
			}	
		}
		return out_stack.peek;
	}
}