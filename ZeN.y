%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token SOURCE END_SOURCE LIB END_LIB FUNC END_FUNC COL END_COL DECL END_DECL ACT END_ACT OBJ_NAME TEXT
%token LIB_NAME GETS NUMBER NUMBER_FLOAT INT CHAR STRING BOOL FLOAT VAR_NAME OP LOGIC_OP COMP NOT TRUTH_VALUE MATRIX ARRAY
%token ADD DECREASE MULTIPLY DIVIDE FOR IF WHILE INCREMENT DECREMENT
%start program
%%
program: SOURCE list_code END_SOURCE {printf("program corect sintactic\n");}
       ;

list_code: libraries functions collections declarations actions
	 ;

basic_type: INT | FLOAT | CHAR | STRING
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
list_collections: VAR_NAME '(' VAR_NAME ')' '{' class_components '}'
				;
class_components: class_components component
				| component
				;
component: list_declarations
		| constructor
		| assignment ';'
		;
constructor: basic_type VAR_NAME '::' VAR_NAME ';'
		;
construct_parameters: NUMBER | NUMBER_FLOAT	| TEXT | VAR_NAME
					;

declarations: DECL list_declarations END_DECL
	    ;
assignment: basic_type VAR_NAME GETS equation
		| ARRAY VAR_NAME '[' NUMBER ']' GETS '[' arr_values ']'
		| MATRIX VAR_NAME '[' NUMBER ']' '[' NUMBER ']' GETS '[' matrix_values ']'
		;
arr_values: NUMBER
		| NUMBER arr_values
		;
matrix_values: arr_values
		| arr_values ';' matrix_values
		;

list_declarations: INT VAR_NAME ';'
			| FLOAT VAR_NAME ';'
			| FLOAT VAR_NAME GETS VAR_NAME ';'
			| CHAR VAR_NAME '[' NUMBER ']' ';'
			| STRING VAR_NAME ';'
			| BOOL VAR_NAME ';'
			| ARRAY VAR_NAME '[' NUMBER ']' ';'
			| MATRIX VAR_NAME '[' NUMBER ']' '[' NUMBER ']' ';'
			| OBJ_NAME VAR_NAME '(' construct_parameters ')' ';'
			;


actions: ACT list_actions END_ACT
	;	
list_actions: list_actions action | action;

action: if_statement | while_statement | for_statement | RET equation | function_call
		| VAR_NAME GETS equation
		| assignment
		;

equation: operand
		| operand OP operand
		| equation OP operand
		;

operand: VAR_NAME | NUMBER | NUMBER_FLOAT | TEXT | function_call;
function_call: VAR_NAME(parameters);
parameters: operand ',' parameters
		| operand
		;

if_statement: IF '(' logicals ')' '{' list_actions '}'
			| IF '(' logicals ')' '{' list_actions '}' ELSE '{' list_actions '}'
			;

for_statement: FOR '(' VAR_NAME GETS operand';' VAR_NAME COMP operand ';' VAR_NAME GETS equation ')' '{' list_actions '}'
			;
while_statement: WHILE '(' logical ')' '{' list_actions '}'
				;

logicals: logical
		| logical LOGIC_OP logicals
		;

logical: operand COMP operand

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
