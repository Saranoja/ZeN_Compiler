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
     char symbol_name[50]; //id-ul
     int Value;
};
struct symTableElem symTable[100];
int varIndex = 0;
int j = 0;
int banana = 0;
int curr = 0;

int one=0;
int two=0;

char fsignature[300]; //asta vrea declarat sus
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
     //printf("se incrementeaza vectorul block cu vlaoarea % d\n", blockNrForDepth[curentDepth]);
     curentDepth++;

     //  printf("       Am crescut adancimea. Acum este %d\n", curentDepth);
     return 0;
}

int curentDepthDec()
{
     curentDepth--;
     // printf("       Am scazut adancimea. Acum este %d\n", curentDepth);
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
               // printf("Am fost apelat cu succes\n");
               return i; //variabila exista deja in tabel;
          }
     }

     return -1;
}

int insert(char *SCOPE, char *type, char *id, int Val)
{
     if (lookup(id) != -1)
     {
          printf("  Eroare: variabila %s %s exista deja.\n", type, id);
          return 0;
     }

     symTable[varIndex].blockDepth = curentDepth;
     symTable[varIndex].blockNr = blockNrForDepth[curentDepth - 1];
     //printf(" chuvantul cheie este %s ",SCOPE);
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
     //printf("      %d %s %s = %d\n",symTable[varIndex].scope,symTable[varIndex].symbol_type,symTable[varIndex].symbol_name,symTable[varIndex].Value );
     // printf("Am inserat intdex = %d\n", varIndex);
     varIndex++;
     if (varIndex == 100)
     {
          printf("Eroare: A fost atins numarul maxim de variabile disponibile.\n");
     }
     //printf("Inserare cu succes a variabilei %s \n",id );
     return 0;
}

int checkDecl(char *id)
{
     int idIndex;
     if ((idIndex = lookup(id)) == -1)
     {
          printf("  Eroare: variabila %s nu exista\n", id);
          return 0;
     }

     if (strcmp(symTable[idIndex].symbol_type, "int") != 0)
     {
          printf("  Eroare: variabila %s nu este de tip int.\n", id);
          return -1;

          if (symTable[idIndex].Value == MAXINT)
          {
               printf("  Eroare: variabila %s a fost initializata\n", id);
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
          printf("  Eroare: variabila %s nu exista\n", dest);
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
          printf("  Eroare: variabila %s nu exista\n", source);
          return -1;
     }

     if ((destIndex = lookup(dest)) == -1)
     {
          printf("  Eroare: variabila %s nu exista\n", dest);
          return -1;
     }

     if (strcmp(symTable[sourceIndex].symbol_type, "int") != 0)
     {
          printf("  Eroare: variabila %s nu este de tip int.\n", dest);
          return -1;

          if (symTable[sourceIndex].Value == MAXINT)
          {
               printf("  Eroare: variabila %s a fost initializata\n", dest);
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

     printf("\n\nTabela de simboluri este:\n");
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
     fprintf(f, "Au fost declarate variabilele: ");
     for (i = 0; i < varIndex; i++)
     {
          for (j = symTable[i].blockDepth; j > 1; j--)
          {
               fprintf(f, "\t");
          }
          fprintf(f, "%s %s %d\n", symTable[i].symbol_type, symTable[i].symbol_name, symTable[i].Value);
     }
     fprintf(f, "\n");
     fprintf(f, "Au fost declarate functiile: ");
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
          // printf("\n");
          // printf("in vector am %s\n",symTableFct[i].signature);
          // printf("in argument am %s\n",sign);
          // printf("\n");
          if (strcmp(symTableFct[i].signature, sign) == 0)
          {
               return 1; //functia deja a fost declarata;
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
          printf("  Eroare: functia cu signatura %s are un duplicat.\n",fsignature);
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
     //function_names[name_index].numberOfParams = 0;
     //printf("Numele functiei declarate: %s \n", function_names[name_index].name);
     name_index++;
     j = 0;
     return 0;
}

void insertIntoParamArray(char *type)
{
     strcpy(function_names[name_index].types[j], type);
     function_names[name_index].numberOfParams++;
     // printf("Am inserat in %s tipurile: ", function_names[name_index].name);
     //printf("%s \n", function_names[name_index].types[j]);
     j++;
}

void insertName(char *name)
{
     strcpy(user_calls[curr].name, name);
     //user_calls[curr].numberOfParams = 0;
     //one=curr;
     curr++;
     banana = 0;
}

int insertIntoUserArray(char *type)
{
     strcpy(user_calls[curr].types[banana], type);
     //printf("Am inserat in user calls de %d %s tipurile: ", curr, user_calls[curr].name);
     //printf("%s \n", user_calls[curr].types[banana]);
     //j++;
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
          printf("Functia %s nu a fost declarata anterior \n", user_calls[copie].name);
          return 2;
     }
     //if (user_calls[copie].numberOfParams != function_names[new_copie].numberOfParams)
          //return 0;
     //printf("Numarul de parametri este %d si %d \n", user_calls[copie].numberOfParams, function_names[new_copie].numberOfParams);
     for (int parcurge = 0; parcurge < user_calls[copie].numberOfParams; parcurge++)
     {
          if (strcmp(user_calls[copie].types[parcurge], function_names[new_copie].types[parcurge]) != 0)
               return 0;
     }
     return 1;
}
