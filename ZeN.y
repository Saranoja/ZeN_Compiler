%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ZeN.h"

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern char* yytext;

%}
%union {
  int intVal; //value
  char* dataType; // datatype
  char* strVal; // ID
  char *key;
}

%token STRINGVAL  CHARVAL BEG END ANS  TRUE FALSE EVAL WHILE FOR IF ELSE BOOLEQ BOOLGEQ BOOLLEQ BOOLNEQ LOGICALAND LOGICALOR  DECLF FCALL RETURN  BOOLGE BOOLLE EQ OBJCALL OBJTYPE
%token <dataType> INTTYPE BOOLTYPE STRINGTYPE ARRAYTYPE  CHARTYPE VOID
%token <intVal> NR
%token <strVal> ID
%token <key>  DECL ODECL

%type <intVal> exp e 

%start s
%left PLUS MINUS
%left MUL DIV
%%

s: progr {printf ("\n Language is syntactically correct.\n"); printTable(); Scrie();}

progr : declarations functions

depthAdd  : { curentDepthAdd(); }
          ;

declarations : objects
             |
             ;

objects : objects object
        | object
        ;

object : OBJCALL depthAdd OBJTYPE ID BEG  atributelist objEnd 
       | OBJCALL depthAdd OBJTYPE ID BEG objEnd
       ;

objEnd    : END { curentDepthDec(); }
          ;

atributelist : atributelist atribute
             | atribute
             ;

atribute : DECL INTTYPE ID EQ NR'.' {insert($1,$2,$3,$5);}
         | DECL INTTYPE ID'.'       {insert($1, $2, $3, 2147483647);}
         | DECL CHARTYPE ID  EQ CHARVAL'.'{insert($1, $2, $3, -1);}
         | DECL CHARTYPE ID'.'        {insert($1, $2, $3, -1);}
         | DECL STRINGTYPE ID  EQ STRINGVAL'.'{insert($1, $2, $3, -1);}
         | DECL STRINGTYPE ID'.'{insert($1, $2, $3, -1);}
         | DECL BOOLTYPE ID EQ TRUE'.'{insert($1, $2, $3, 1);}
         | DECL BOOLTYPE ID EQ FALSE'.'{insert($1, $2, $3, 0);}
         | DECL BOOLTYPE ID'.'{insert($1,$2,$3,-1);}
         | DECL ARRAYTYPE ID EQ arraylist'.'{insert($1, $2, $3, -1);}
         //| DECL OBJTYPE ID object'.'{insert($1, $2, $3, -1);}
         //| DECL OBJTYPE ID'.'{insert($1, $2, $3, -1);}
         | FCALL  EVAL '(' exp ')'
         | FCALL ID '(' callInstructions ')'  {    insertName($2);
                                                   if (checkIdentity($2)==0)
                                                       printf("The types of the called function do not match with the declared types for %s \n", $2);
                                             }
         | ODECL INTTYPE ID EQ NR'.' {insert($1, $2, $3, $5);}
         | ODECL INTTYPE ID'.'{insert($1, $2, $3, 2147483647);}
         | ODECL CHARTYPE ID  EQ CHARVAL'.'{insert($1, $2, $3, -1);}
         | ODECL CHARTYPE ID'.'{insert($1, $2, $3, -1);}
         | ODECL STRINGTYPE ID  EQ STRINGVAL'.'{insert($1, $2, $3, -1);}
         | ODECL STRINGTYPE ID'.'{insert($1, $2, $3, -1);}
         | ODECL BOOLTYPE ID EQ TRUE'.'{insert($1, $2, $3, 1);}
         | ODECL BOOLTYPE ID EQ FALSE'.'{insert($1, $2, $3, 0);}
         | ODECL BOOLTYPE ID'.' {insert($1,$2,$3,-1);}
         | ODECL ARRAYTYPE ID EQ arraylist'.'{insert($1, $2, $3, -1);}
        // | ODECL OBJTYPE ID object'.'{insert($1, $2, $3, -1);}
        // | ODECL OBJTYPE ID'.'{insert($1, $2, $3, -1);}
         | ODECL INTTYPE EVAL '(' exp ')'
         ;

arraylist : '['']'
          | '['list']'
          ;

list : list',' listval
     | listval
     ;

listval : NR
        | CHARVAL
        | STRINGVAL
        | ID
        | object
        | arraylist
        ;

functions : functions  function
          | function
          ;
function  : DECLF INTTYPE ID    depthAdd functionBody { insertIntoFsignature($2); insertIntoFsignature($3); insertIntoNameArray($3); insertFct();}
          | DECLF CHARTYPE ID   depthAdd functionBody { insertIntoFsignature($2); insertIntoFsignature($3); insertIntoNameArray($3); insertFct();}
          | DECLF VOID ID       depthAdd functionBody { insertIntoFsignature($2); insertIntoFsignature($3); insertIntoNameArray($3); insertFct();}
          | DECLF BOOLTYPE ID   depthAdd functionBody { insertIntoFsignature($2); insertIntoFsignature($3); insertIntoNameArray($3); insertFct();}
          | DECLF STRINGTYPE ID depthAdd functionBody { insertIntoFsignature($2); insertIntoFsignature($3); insertIntoNameArray($3); insertFct();}
          | DECLF INTTYPE EVAL '(' exp ')'
          | FCALL ID '(' callInstructions')' {    insertName($2);
                                                   if (!checkIdentity($2))
                                                       printf("The types of the called function do not match with the declared types for %s \n", $2);
                                             }
          ;

functionBody   : '(' declInstructions ')' body
               ;

callInstructions    : callInstructions ',' callInstruction
                    | callInstruction
                    ;

callInstruction     : INTTYPE ID {insertIntoUserArray($1);}
                    | CHARTYPE ID {insertIntoUserArray($1);}
                    | STRINGTYPE ID {insertIntoUserArray($1);}
                    | BOOLTYPE ID {insertIntoUserArray($1);}
                    | function      
                    | NR {insertIntoUserArray("int");}
                    ;

declInstructions    : declInstructions ',' declInstruction
                    | declInstruction
                    ;

declInstruction     : INTTYPE ID    {  insertTEMP($1); insertIntoParamArray($1);}
                    | CHARTYPE ID   {  insertTEMP($1); insertIntoParamArray($1);}
                    | STRINGTYPE ID {  insertTEMP($1); insertIntoParamArray($1);}
                    | BOOLTYPE ID   {  insertTEMP($1); insertIntoParamArray($1);}
                    ;


exp       : e  {$$=$1; printf("Valoarea expresiei este %d\n",$$);} 
          ;

e : e PLUS e   {$$=$1+$3; }
  | e MINUS e   {$$=$1-$3; }
  | e MUL e   {$$=$1*$3; }
  | e DIV e   {$$=$1/$3; }
  | NR {$$=$1; }
  | DECL INTTYPE ID EQ NR'.' { int i; 
                              if((i=lookup($3)) != -1)
                              { 
                                   updateVarWith_value($3, $5);
                                   $$ =  symTable[i].Value ;
                                   
                              }
                              else {
                                   printf("Variable doesn't exist\n"); 
                                   printf("Error: argument for Eval is not valid!\n");
                                   exit(0);
                              }
                              }
  | DECL INTTYPE ID'.' { int i;
                         if((i=lookup($3)) != -1)
                         {   
                              $$= symTable[i].Value;
                         }
                          else 
                          {
                                   printf("Variable doesn't exist\n"); 
                                   printf("Error: argument for Eval is not valid!\n");
                                   exit(1);
                          }
                        }
  ;

body      : BEG blockInstructions RETURN bodyEnd
          | BEG blockInstructions bodyEnd
          | BEG END
          ;

bodyEnd   : END { curentDepthDec(); }
          ;

blockInstructions   : blockInstructions blockInstruction 
                    | blockInstruction
                    ;

blockInstruction    : atribute
                    | assignment
                    | while
                    | for
                    | if
                    ;

while : WHILE depthAdd '(' conditii ')' body
      ;

for  : FOR depthAdd '(' assignment conditii '.' assignment ')' body
     ;

if   : IF depthAdd '(' conditii ')' body
     | IF depthAdd '(' conditii ')' body ELSE depthAdd body
     ;


assignment : DECL ID EQ NR'.' { updateVarWith_value($2, $4); }
           | DECL ID EQ CHARVAL'.'
           | DECL ID EQ STRINGVAL'.'
           | DECL ID EQ TRUE'.'
           | DECL ID EQ FALSE'.'
           | DECL ID EQ arraylist'.'
           | DECL ID EQ operatie'.' 
           | DECL ID EQ ID'.' { updateVarWith_id($2, $4); }
           ;

operatie  : plus
          | minus
          | mul
          | div
          ;

plus : ID PLUS ID { checkDecl($1); checkDecl($3); }
     | ID PLUS NR { checkDecl($1);}
     | NR PLUS ID { checkDecl($3);}
     ;

minus : ID MINUS ID { checkDecl($1); checkDecl($3); }
      | ID MINUS NR { checkDecl($1);}
      | NR MINUS ID { checkDecl($3);}
      ;

mul  : ID MUL ID { checkDecl($1); checkDecl($3); }
     | ID MUL NR { checkDecl($1);}
     | NR MUL ID { checkDecl($3);}
     ;

div  : ID DIV ID { checkDecl($1); checkDecl($3); }
     | ID DIV NR { checkDecl($1);}
     | NR DIV ID { checkDecl($3);}
     ;

conditii  : conditii logicalOp conditie
          | conditie
          ;

logicalOp : LOGICALAND
          | LOGICALOR
          ;

conditie  : TRUE
          | FALSE
          | NR boolOp NR
          | ID boolOp NR
          | NR boolOp ID
          | ID boolOp ID
          ;

boolOp    : BOOLEQ
          | BOOLGEQ
          | BOOLLEQ
          | BOOLNEQ
          | BOOLLE
          | BOOLGE
          ;


%%

int yyerror(char * s){
printf("Error: %s on line:%d and yytext is %s\n",s,yylineno,yytext);
}

int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     yyparse();
}
