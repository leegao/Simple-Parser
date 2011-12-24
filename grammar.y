//terminal LL-CODE LL-PRODUCTION LL-IDENTIFIER LL-GETS LL-OR LL-SEMI EOF

%production production_stmt void
%production nonterminal_expr void
%production nonterminal_expr_ void
%production rule_stmt void
%production rule_stmt_ void

production_stmt ::= LL-PRODUCTION LL-IDENTIFIER LL-IDENTIFIER
	{:
	// production-stmt
	:}
;

nonterminal_expr ::= LL-IDENTIFIER nonterminal_expr_
	{:
	// nonterminal-expr : 1+
	:}
;

nonterminal_expr_ ::= 
	{:

	:}
| nonterminal_expr 
	{:

	:}
;

rule_stmt ::= LL-CODE rule_stmt_
	{:
	// rule-stmt : code
	:}
| nonterminal_expr LL-CODE rule_stmt_
	{:
	// rule-stmt : nonterminal-expr code
	:}
;

rule_stmt_ ::= 
	{:

	:}
| LL-OR rule_stmt
	{:

	:}
;

production_list ::= production_stmt production_list_
{:

:}
;

production_list_ ::= 
{:

:}
| production_list
{:

:}
;

rule_list ::= LL-IDENTIFIER LL-GETS rule_stmt LL-SEMI rule_list_
{:

:}
;

rule_list_ ::= 
{:

:}
| rule_list
{:

:}
;

grammar ::= production_list rule_list
{:

:}
| rule_list
{:

:}
;

parser ::= LL-CODE grammar EOF
{:

:}
| grammar EOF
{:

:}
;