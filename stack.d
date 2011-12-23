module stack;
import std.array, std.stdio;
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
		return store[i-1];
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
	
	T opIndex(int i){
		if (i >= size)
			return cast(T)null;
		//writeln(size, " ", i);
		//writeln();
		if (i < out_stack.i){
			return out_stack.store[out_stack.i -i - 1];
		} else {
			i -= out_stack.i;
			//int n = out_stack.i - 1 - i;
			return in_stack.store[i];
		}
	}
	
	int size(){
		return in_stack.i+out_stack.i;
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