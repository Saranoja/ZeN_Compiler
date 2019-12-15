%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
"int"|"float"|"char"|"string" {return TYPE;}
"<source_code" {return SOURCE;}
"<libraries>" {return LIB;}
"<functions>" {return FUNC;}
"<collections>" {return COL;}
"<declarations>" {return DECL;}
"<actions>" {return ACT;}
"</source_code" {return END_SOURCE;}
"</libraries>" {return END_LIB;}
"</functions>" {return END_FUNC;}
"</collections>" {return END_COL;}
"</declarations>" {return END_DECL;}
"</actions>" {return END_ACT;}
@[_a-zA-Z][_a-zA-Z0-9]* {return VAR_NAME;}
"=" {return GETS;}
[0-9]+ {return INTEGER;}
([1-9][0-9]*\.[0-9]+)|(0\.[0-9]+) {return NRF;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 
