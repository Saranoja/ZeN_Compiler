%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token SOURCE END_SOURCE LIB END_LIB FUNC END_FUNC COL END_COL DECL END_DECL ACT END_ACT OBJ_NAME
%token LIB_NAME GETS NUMBER NUMBER_FLOAT INT CHAR STRING BOOL FLOAT VAR_NAME OP LOGIC_OP COMP NOT TRUTH_VALUE MATRIX ARRAY
%start program
%%
program: SOURCE list_code END_SOURCE {printf("program corect sintactic\n");}
       ;

list_code: libraries functions collections declarations actions
	 ;

libraries: LIB lib_list END_LIB
	;
lib_list: LIB_NAME
		| LIB_NAME lib_list
		;

functions: FUNC list_functions END_FUNC
	 ;
list_functions: VAR_NAME '(' function_parameters ')' '{' list_actions '}'
				| list_functions VAR_NAME '(' function_parameters ')' '{' list_actions '}'
				;

collections:
	   | COL list_collections END_COL
	   ;

declarations: DECL list_declarations END_DECL
	    ;
list_declarations: INT VAR_NAME ';'
			| FLOAT VAR_NAME ';'
			| FLOAT VAR_NAME GETS VAR_NAME ';'
			| CHAR VAR_NAME '[' NUMBER ']' ';'
			| STRING VAR_NAME ';'
			| BOOL VAR_NAME ';'
			| ARRAY VAR_NAME '[' NUMBER ']' ';'
			| MATRIX VAR_NAME '[' NUMBER ']' '[' NUMBER ']' ';'
			| OBJ_NAME VAR_NAME '(' parameters ')' ';'
			;


actions: ACT list_actions END_ACT
	;	
list_actions: list_actions action | action;

action: if_statement | while_statement | for_statement | RET equation
		| VAR_NAME GETS equation
		;

equation: operand
		| operand OP operand
		| equation OP operand
		;

operand: VAR_NAME | NUMBER | NUMBER_FLOAT ;

if_statement: 
			;

for_statement:
			;
while_statement:
				;

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
