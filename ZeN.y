%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token SOURCE LIB FUNC COL DECL ACT END_SOURCE END_LIB END_FUNC END_COL END_DECL END_ACT TYPE VAR_NAME GETS INTEGER
%start program
%%
program: SOURCE LIB END_LIB FUNC END_FUNC COL END_COL DECL END_DECL ACT END_ACT END_SOURCE {printf("program corect sintactic\n");}
     | SOURCE LIB END_LIB FUNC END_FUNC DECL END_DECL ACT END_ACT END_SOURCE
     ;

int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 