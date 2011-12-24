{:
import std.string;
:}
%production Operators string
%production Expression string
%production Expression_ string

Operators ::= 
>
{: return _1; :}
| <
{: return _1; :}
| +
{: return _1; :}
| -
{: return _1; :}
| .
{: return _1; :}
| ,
{: return _1; :}
;

Expression ::= Operators Expression_
{: writeln("%s %s".format(_1, _2)); return "%s %s".format(_1, _2);:}
| [ Expression ] Expression_
{: writeln("[%s] %s".format(_2, _4)); return "%s %s".format(_2, _4);:}
;

Expression_ ::= 
{: return ""; :}
| EOF
{: return ""; :}
| Expression
{: return _1 :}
;