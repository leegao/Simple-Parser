module ll_lex;

import scanner;
import std.stream;

// really simple lexer.
// tokenize on space, but discard // lines and group {: ... :} (non-greedy) as code

class SimpleLexer{
	InputStream stream;
	stack.Queue!char already_read;
	bool[char] whitespace;// = [' ':true,'\t':true,'\n':true,'\r':true];
	bool[char] separators;// = [' ':true,'\t':true,'\n':true,'\r':true, '|':true, ';':true];
	this(InputStream stream){
		this.stream = stream;
		this.already_read = new stack.Queue!char;
		whitespace = [' ':true,'\t':true,'\n':true,'\r':true];
		separators = [' ':true,'\t':true,'\n':true,'\r':true, '|':true, ';':true];
		reserved = ["|":"LL-OR", "production":"LL-PRODUCTION"];
	}
	
	string[string] reserved;// = ["|":"LL-OR", "production":"LL-PRODUCTION"];
	
	char get(){
		char c;
		if (already_read.empty){
			stream.read(c);
			return c;
		}
		return already_read.pop;
	}
	
	char next(){
		char c;
		if (already_read.empty){
			stream.read(c);
			already_read.push(c);
			return c;
		}
		// return the first pushed
		return already_read.peek;
	}
	
	string next(int n){
		// get the next n characters without consuming them.
		int cur = already_read.size;
		if (n > cur){
			for (int i = 0; i < n-cur; i++){
				char c;
				stream.read(c);
				already_read.push(c);
			}
			already_read.prepare;
		}
		char[] s = new char[n];
		// invariant here: queue's out_stack contains the data
		for (int i = 1; i <= n; i++){
			if (cur-1-i >= 0)
				s[i-1] = already_read.out_stack.store[cur-1-i];
		}
		
		return cast(string) s;
	}
	
	bool at_least(int n){
		try{
			next(n);		
			return true;
		} catch (ReadException e){
			return false;
		}
	}
	
	Token read(){
		// discard whitespace
		char c;
		try{
			c = next;
		} catch (ReadException e){
			// return eof
			return new Token("", "EOF");
		}
		
		while (c in whitespace){
			get; // discard whitespace
			try{
				c = next;
			} catch (ReadException e){
				// return eof
				return new Token("", "EOF");
			}
		}
		
		if (at_least(2)){
			// check if is comment //
			if (next(2) == "//"){
				// discard until line
				try{
					while (get != '\n'){}
					return read; // start again
				} catch (ReadException e){
					// everything's good, return eof
					return new Token("", "EOF");
				}
			}
			
			// check if is code {: :}
			if (next(2) == "{:"){
				get; // discard the {
				get; // discard the :
				// invariant, must have at least 2 chars
				try{
					c = get;
					char c2 = get;
					char[] buf;
					auto app = std.array.appender(&buf);
					while(!(c==':' && c2 == '}')){
						app.put(c);
						app.put(c2);
						c = get;
						c2 = get;
					}
					return new Token(cast(string)buf, "LL-CODE");
				} catch(ReadException e){
					// fatal error
					throw e;
				}
			}
		}
		
		// check if reserved word
		foreach (string word, string type; reserved){
			if (!at_least(word.length)) continue;
			string peek = next(word.length);
			if (peek == word){
				for (int i = 0; i < word.length; i++)
					get; // discard it
				return new Token(word, type);
			}
		}
		
		// get until whitespace
		char[] buf;
		auto app = std.array.appender(&buf);
		try{
			c = get();
			while (!(c in separators)){
				app.put(c);
				c = get();
			}
		} catch (ReadException e){
			// pass
		}
		return new Token(cast(string)buf, "LL-IDENTIFIER");
	}
}