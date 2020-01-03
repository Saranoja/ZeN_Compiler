%{
#include <stdio.h>
#include "y.tab.h"
extern int yylval;
%}
%%
[0-9]+ {yylval = strdup(yytext); return NR;}
([1-9][0-9]*\.[0-9]+)|(0\.[0-9]+) {yylval = strdup(yytext); return NR_FLOAT;}
[_a-zA-Z][_a-zA-Z0-9]* {yylval = strdup(yytext); return VAR_NAME;}
[_a-zA-Z][_a-zA-Z0-9]*"["[1-9][0-9]*"]["[1-9][0-9]*"]" {yylval = strdup(yytext); return MATRIX;}
[_a-zA-Z][_a-zA-Z0-9]*"["[1-9][0-9]*"]" {yylval = strdup(yytext); return ARRAY;}
@[_a-zA-Z][_a-zA-Z0-9]* {yylval = strdup(yytext); return LIB_NAME;}
[_a-zA-Z][_a-zA-Z0-9]*\-\>[_a-zA-Z][_a-zA-Z0-9]* {yylval = strdup(yytext); return OBJ_NAME;}

"int" | "float" | "char" | "bool" {return TYPE;}
"string" {yylval = strdup(yytext); return STR;}
"for" {return FOR;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"<source_code>" {return SOURCE;}
"<libraries>" {return LIB;}
"<functions>" {return FUNC;}
"<collections>" {return COL;}
"<declarations>" {return DECL;}
"<actions>" {return ACT;}
"</source_code>" {return END_SOURCE;}
"</libraries>" {return END_LIB;}
"</functions>" {return END_FUNC;}
"</collections>" {return END_COL;}
"</declarations>" {return END_DECL;}
"</actions>" {return END_ACT;}

"true" {yylval = strdup(yytext); return TRUE;}
"false" {yylval = strdup(yytext); return FALSE;}


"+" {yylval = strdup(yytext); return PLUS;}
"-" {yylval = strdup(yytext); return MINUS;}
"*" {yylval = strdup(yytext); return MUL;}
"/" {yylval = strdup(yytext); return DIV;}
"%" {yylval = strdup(yytext); return MOD;}
"&&" {yylval = strdup(yytext); return AND;}
"||" {yylval = strdup(yytext); return OR;}
"<" {yylval = strdup(yytext); return LE;}
">" {yylval = strdup(yytext); return GR;}
"==" {yylval = strdup(yytext); return EQ;}
"<=" {yylval = strdup(yytext); return LEQ;}
">=" {yylval = strdup(yytext); return GREQ;}
"!=" {yylval = strdup(yytext); return NEQ;}
"!" {yylval = strdup(yytext); return NOT;}
"=" {yylval = strdup(yytext); return GETS;}

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

