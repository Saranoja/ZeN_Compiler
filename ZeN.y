%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token SOURCE END_SOURCE LIB END_LIB FUNC END_FUNC COL END_COL DECL END_DECL ACT END_ACT TEXT
%token LIB_NAME GETS NUMBER NR_FLOAT INT CHAR STRING BOOL FLOAT VAR_NAME OP LOGIC_OP COMP NOT TRUTH_VALUE MATRIX ARRAY RET
%token ADD DECREASE MULTIPLY DIVIDE FOR IF WHILE INCREMENT DECREMENT ELSE OBJ_NAME
%start program
%%
program: SOURCE list_code END_SOURCE {printf("program corect sintactic\n");}
       ;

list_code: libraries functions collections declarations actions
	 ;

basic_type: INT | FLOAT | CHAR | STRING | BOOL
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
function_parameters: basic_type VAR_NAME
				| basic_type VAR_NAME ',' function_parameters
				| basic_type OBJ_NAME
				| basic_type OBJ_NAME ',' function_parameters
				;

collections:
	   | COL list_collections END_COL
	   ;
list_collections: VAR_NAME '(' VAR_NAME ')' '{' class_components '}'
				| VAR_NAME '(' VAR_NAME ')' ':' VAR_NAME '{' class_components '}'
				| list_collections list_collections
				;
class_components: class_components component
				| component
				;
component: list_declarations
		| constructor
		| assignment ';'
		;
constructor: VAR_NAME ':' ':' VAR_NAME ';'
		;
construct_parameters: NUMBER | NR_FLOAT	| TEXT | VAR_NAME
					;

declarations: DECL list_declarations END_DECL
	    ;
assignment: basic_type VAR_NAME GETS equation
		| ARRAY VAR_NAME '[' NUMBER ']' GETS '[' arr_values ']'
		| MATRIX VAR_NAME '[' NUMBER ']' '[' NUMBER ']' GETS '[' matrix_values ']'
		| basic_type OBJ_NAME GETS equation
		| basic_type VAR_NAME GETS function_call
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
			| VAR_NAME VAR_NAME '(' construct_parameters ')' ';'
			| INT VAR_NAME GETS function_call ';'
			| FLOAT VAR_NAME GETS function_call ';'
			| CHAR VAR_NAME GETS function_call ';'
			| STRING VAR_NAME GETS function_call ';'
			| list_declarations list_declarations
			;

actions: ACT list_actions END_ACT
	;	
list_actions: action ';' list_actions
			| action ';'
			;

action: if_statement | while_statement | for_statement | RET equation | function_call
		| VAR_NAME GETS equation
		| VAR_NAME GETS TRUTH_VALUE
		;

equation: operand
		| operand OP operand
		| equation OP operand
		| NR_FLOAT | NUMBER
		;

operand: VAR_NAME | OBJ_NAME | NUMBER | NR_FLOAT | TEXT | function_call | '[' arr_values ']' | '[' matrix_values ']' ;
function_call: VAR_NAME '(' parameters ')'
			;
parameters: operand ',' parameters
		| operand
		| equation
		;

if_statement: IF '(' logicals ')' '{' list_actions '}'
			| IF '(' logicals ')' '{' list_actions '}' ELSE '{' list_actions '}'
			;

for_statement: FOR '(' VAR_NAME GETS operand';' VAR_NAME COMP operand ';' VAR_NAME GETS equation ')' '{' list_actions '}'
			;
while_statement: WHILE '(' logicals ')' '{' list_actions '}'
				;

logicals: logical
		| logicals LOGIC_OP logical
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
