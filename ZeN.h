#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAXINT 2147483647
int curentDepthAdd();
int curentDepthDec();
int lookup(char *);
int insert(char *, char *, char *, int);
int insertFct();
int printTable();
void insertTEMP(char *ceva);
int checkDecl(char *);
int updateVarWith_id(char *, char *);
int updateVarWith_value(char *, int);
int insertIntoFsignature(char *);
void Scrie();
struct symTableElem
{

     int blockDepth;       //depth in blocks
     int blockNr;          //index of block in curent depth
     int scope;            // function parameter or block local or for-loop statement etc
     char symbol_type[50]; //int char function object
     char symbol_name[50]; //id
     int Value;
};
struct symTableElem symTable[100];
int varIndex = 0;
int j = 0;
int banana = 0;
int curr = 0;

int one=0;
int two=0;

char fsignature[300];
char temp[100];

struct all_functions
{
     char name[100];
     char types[100][100];
     int numberOfParams;
} function_names[100];

struct called_functions
{
     char name[100];
     char types[100][100];
     int numberOfParams;
} user_calls[100];

int name_index = 0;

int blockNrForDepth[100];
int curentDepth = 1;

struct symTableElemFct
{

     char signature[450];
};

struct symTableElemFct symTableFct[100];
int fctIndex = 0;

int curentDepthAdd()
{
     blockNrForDepth[curentDepth]++;
     curentDepth++;
     return 0;
}

int curentDepthDec()
{
     curentDepth--;
     return 0;
}

int lookup(char *name)
{
     int i;
     int lookupBlockNr = blockNrForDepth[curentDepth - 1];
     int lookupDepth = curentDepth;

     for (i = varIndex - 1; i >= 0; i--)
     {
          if (symTable[i].blockDepth < lookupDepth)
          {
               lookupDepth = symTable[i].blockDepth;
               lookupBlockNr = symTable[i].blockNr;
          }
          else if (symTable[i].blockDepth == lookupDepth &&
                   symTable[i].blockNr == lookupBlockNr &&
                   strcmp(symTable[i].symbol_name, name) == 0)
          {
               return i; //variable exists
          }
     }

     return -1;
}

int insert(char *SCOPE, char *type, char *id, int Val)
{
     if (lookup(id) != -1)
     {
          printf("  Error: variabile %s %s has already been declared.\n", type, id);
          return 0;
     }

     symTable[varIndex].blockDepth = curentDepth;
     symTable[varIndex].blockNr = blockNrForDepth[curentDepth - 1];
     if (strcmp(SCOPE, "Fprepare") == 0)
     {
          symTable[varIndex].scope = 0;
     }
     else if (strcmp(SCOPE, "Oprepare") == 0)
     {
          symTable[varIndex].scope = 1;
     }
     strcpy(symTable[varIndex].symbol_type, type);
     strcpy(symTable[varIndex].symbol_name, id);
     symTable[varIndex].Value = Val;
     varIndex++;
     if (varIndex == 100)
     {
          printf("Error: you have declared the maximum number of variables.\n");
     }
     return 0;
}

int checkDecl(char *id)
{
     int idIndex;
     if ((idIndex = lookup(id)) == -1)
     {
          printf("  Error: variable %s doesn't exist\n", id);
          return 0;
     }

     if (strcmp(symTable[idIndex].symbol_type, "int") != 0)
     {
          printf("  Error: variable %s is not int.\n", id);
          return -1;

          if (symTable[idIndex].Value == MAXINT)
          {
               printf("  Error: variable %s hasn't been initialized\n", id);
               return -1;
          }
     }
     return 1;
}

int updateVarWith_value(char *dest, int source)
{
     int destIndex;

     if ((destIndex = lookup(dest)) == -1)
     {
          printf("  Error: variable %s doesn't exist\n", dest);
          return -1;
     }

     symTable[destIndex].Value = source;

     return 0;
}

int updateVarWith_id(char *dest, char *source)
{
     int sourceIndex, destIndex;

     if ((sourceIndex = lookup(source)) == -1)
     {
          printf("  Error: variable %s doesn't exist\n", source);
          return -1;
     }

     if ((destIndex = lookup(dest)) == -1)
     {
          printf("  Error: variable %s doesn't exist\n", dest);
          return -1;
     }

     if (strcmp(symTable[sourceIndex].symbol_type, "int") != 0)
     {
          printf("  Error: variable %s is not int.\n", dest);
          return -1;

          if (symTable[sourceIndex].Value == MAXINT)
          {
               printf("  Error: variable %s hasn't been initialized\n", dest);
               return -1;
          }
     }

     symTable[destIndex].Value = symTable[sourceIndex].Value;

     return 0;
}

int printTable()
{
     int i;
     int lookupBlockNr = 0;
     int lookupDepth = 0;
     int j;

     printf("\n\nSymbol table:\n");
     for (i = 0; i < varIndex; i++)
     {
          for (j = symTable[i].blockDepth; j > 1; j--)
          {
               printf("\t");
          }
          printf("%s %s %d\n", symTable[i].symbol_type, symTable[i].symbol_name, symTable[i].Value);
     }
     printf("\n");
     for (i = 0; i < fctIndex; i++)
     {
          printf("%s\n", symTableFct[i].signature);
     }
}
void Scrie()
{
     int i;
     int j;
     FILE *f = fopen("symbol_table.txt", "w");
     fprintf(f, "Declared variables: ");
     for (i = 0; i < varIndex; i++)
     {
          for (j = symTable[i].blockDepth; j > 1; j--)
          {
               fprintf(f, "\t");
          }
          fprintf(f, "%s %s %d\n", symTable[i].symbol_type, symTable[i].symbol_name, symTable[i].Value);
     }
     fprintf(f, "\n");
     fprintf(f, "Declared functions: ");
     for (i = 0; i < fctIndex; i++)
     {
          fprintf(f, "%s\n", symTableFct[i].signature);
     }
     fclose(f);
}

int lookupFct(char *sign)
{
     for (int i = fctIndex - 1; i >= 0; i--)
     {
          if (strcmp(symTableFct[i].signature, sign) == 0)
          {
               return 1; //function already declared
          }
     }
     return 0;
}

int insertFct()
{
     char penru[200];
     strcpy(penru,fsignature);
     strcat(penru,temp);
     if(lookupFct(penru) == 1 )
     {
          printf("  Error: function with signature %s is duplicate.\n",fsignature);
          memset(penru,0,200);
          memset(fsignature, 0, 300);
          memset(temp,0,100);
          return 0;
     }

     strcpy(symTableFct[fctIndex].signature, fsignature);
     strcat(symTableFct[fctIndex].signature,temp);
     fctIndex++;
     memset(fsignature, 0, 300);
     memset(temp,0,100);
     memset(penru,0,200);
}
void insertTEMP(char* ceva)
{
     
     strcat(temp, ceva);
     strcat(temp, " ");
     
}

int insertIntoFsignature(char* in)
{
     
     strcat(fsignature, in);
     strcat(fsignature, " ");
     return 0;
}

int insertIntoNameArray(char *in)
{
     strcpy(function_names[name_index].name, in);
     name_index++;
     j = 0;
     return 0;
}

void insertIntoParamArray(char *type)
{
     strcpy(function_names[name_index].types[j], type);
     function_names[name_index].numberOfParams++;
     j++;
}

void insertName(char *name)
{
     strcpy(user_calls[curr].name, name);
     curr++;
     banana = 0;
}

int insertIntoUserArray(char *type)
{
     strcpy(user_calls[curr].types[banana], type);
     user_calls[curr].numberOfParams++;
     banana++;
}

int checkIdentity(char *in)
{
     int copie;
     int new_copie;
     for (int k = 0; k < curr; k++)
          if (strcmp(in, user_calls[k].name) == 0)
          {
               copie = k;
          }
     int ok = 0;
     for (int k = 0; k < name_index; k++)
          if (strcmp(user_calls[copie].name, function_names[k].name) == 0)
          {
               new_copie = k;
               ok = 1;
          }
     if (ok == 0)
     {
          printf("Error: function %s hasn't been declared \n", user_calls[copie].name);
          return 2;
     }
     for (int parcurge = 0; parcurge < user_calls[copie].numberOfParams; parcurge++)
     {
          if (strcmp(user_calls[copie].types[parcurge], function_names[new_copie].types[parcurge]) != 0)
               return 0;
     }
     return 1;
}
