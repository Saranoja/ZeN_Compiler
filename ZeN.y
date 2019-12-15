%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token SOURCE END_SOURCE LIB END_LIB FUNC END_FUNC COL END_COL DECL END_DECL ACT END_ACT TYPE VAR_NAME GETS INTEGER FLOAT
%start program
%%
program: SOURCE list_code END_SOURCE {printf("program corect sintactic\n");}
       ;

list_code: LIB list_lib END_LIB functions
	 ;

list_lib: list_lib VAR_NAME
	| VAR_NAME	
	;

functions: FUNC list_function END_FUNC collections declarations
	 ;

collections:
	   | COL list_collections END_COL
	   ;

declarations: DECL list_declarations END_DECL actions
	    ;
list_declarations: TYPE VAR_NAME assign
		 ;
assign: GETS value
      | '(' value ')'
      | '[' value ']'
      | '[' value ']' '[' value ']'
      ;	
value: INTEGER
     | FLOAT
     | 
     ;


actions : ACT list_actions END_ACT
	;	


%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
