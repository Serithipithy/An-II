%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct variabila
{
int valoare;
char* nume;
char* tip_variabila;
bool constanta;
bool valoare_init;  /* are o valoare initializata*/
};
struct variabila variabile[200];
int v=0; /*tipa aia are aici un v-vechi care umple symbol tabel ala*/

struct functie
{
char* tip_functie;
char* nume;
char* argumente;
};
struct functie functii[200];
int f=0; /*same cu f-vechi*/

int variabile_declarate(char* nume)
{
     for(int i=0;i<k;i++)
        {
          if(strcmp(variabile[i].nume,nume)==0) return i;
        }
      return -1;
}

void declarare_fara_initializare(char* tip_variabila,char* nume,bool constanta)
{
      if(variabile_declarate(nume)!=-1)
       {
         char buffer[200];
         sprintf(buffer,"Variabila %s este deja declarata",nume);
         yyerror(buffer);
         exit(0);
       }
     if(constanta==1)
      {
        char buffer[200];
        sprintf(buffer,"Nu puteti declara variabile de tip const %s fara initializare",nume);
        yyerror(buffer);
        exit(0);
       }
     variabile[v].tip_variabila=strdup(tip_variabila);
     variabile[v].nume=strdup(nume);
     variabile[v].valoare_init=0;
     variabile[v].constanta=0;
     k++;
}


void declarare_cu_initializare(char* tip_variabila,char*nume,int valoare,bool constanta)
{
    if(variabile_declarate(nume)!=-1)
      {
        char buffer[200];
        sprintf(buffer,"Variabila %s este deja declarata",nume);
        yyerror(buffer);
        exit(0);
      }
    variabile[v].tip_variabila=strdup(tip_variabila);
    variabile[v].nume=strdup(nume);
    variabile[v].valoare=valoare;
    variabile[v].valoare_init=1;
    variabile[v].constanta=constanta;
    k++;
}

int valoarea_variabilei(char* nume)
{
    int poz=variabile_declarate(nume);
    if(poz==-1)
    {
       char buffer[200];
       sprintf(buffer,"Variabila %s nu a fost declarata",nume);
       yyerror(buffer);
       exit(0);
    }
    if(variabile[poz].valoare_init==0)
    {
       char buffer[200];
       sprintf(buffer,"Variabila %s nu are nicio valoare",nume);
       yyerror(buffer);
       exit(0);
    }
    return variabile[poz].valoare;
}

%}

%token BOOL BGIN CONST END IF THEN ELSE ENDIF WHILE DO ENDWHILE FOR THENDO ENDFOR CLASS AND OR
%token BOOLEQUAL ASSIGN EQUAL NOT NEG LESS LESSEQUAL GREAT GREATEQUAL PLUS MINUS MULT DIVIDE
%token RPARAN LPARAN BROPEN BRCLOSE AOPEN ACLOSE SEMICOLON COMMA TIP ID INTEGER CHAR FLOAT STRING

%start compilator

%left SEMICOLON
%left OR AND
%left PLUS MINUS
%left MULT DIVIDE
%left LPARAN RPARAN

%union
{
    int num;
    char* str;
}

%type <num> INTEGER FLOAT operatie operand
%type <str> TIP ID CHAR STRING BOOL

%%

compilator: program {printf("program corect sintactic \n");}
          ;

program:declaratii main
	| main
	| clase declaratii main
	| clase main
	;

clase: clasa
     | clase SEMICOLON clasa
     ;
clasa: CLASS ID AOPEN declaratii ACLOSE SEMICOLON

main:BGIN AOPEN blocuri ACLOSE END
    ;

declaratii:declaratie
	   | declaratii declaratie
	   ;

declaratie: TIP ID SEMICOLON /*int a; sau int a,b,c;//functie de declarare fara valoare*/ {declarare_fara_initializare($1,$2,0);}
	  | TIP ID ASSIGN INTEGER SEMICOLON /*functie de declarare cu o valoare*/{declarare_cu_initializare($1,$2,$4,0);}
	  | TIP ID ASSIGN FLOAT SEMICOLON
	  | TIP ID ASSIGN STRING SEMICOLON
	  | TIP ID ASSIGN CHAR SEMICOLON
	  | TIP ID ASSIGN ID SEMICOLON
	  | CONST TIP ID SEMICOLON
	  | CONST TIP ID ASSIGN INTEGER SEMICOLON
	  | CONST TIP ID  ASSIGN FLOAT SEMICOLON
	  | TIP ID signatura // pt functii si clase
	  ;
signatura: AOPEN ACLOSE
    	 | AOPEN parametrii ACLOSE
    	 ;

parametrii: TIP ID
	  | parametrii COMMA TIP ID
          ;

blocuri: bloc
       | blocuri bloc
       ;

bloc: IF LPARAN conditii RPARAN THEN AOPEN operatii ACLOSE ENDIF
    | IF LPARAN conditii RPARAN THEN AOPEN operatii ACLOSE ELSE AOPEN operatii ACLOSE ENDIF
    | WHILE LPARAN conditii RPARAN DO AOPEN operatii ACLOSE ENDWHILE
    | FOR LPARAN conditie_for RPARAN DO AOPEN operatii ACLOSE ENDFOR
    | operatii SEMICOLON
    | declaratie
    ;

conditii: operand
	 | BOOL
	 | NOT operand
	 | operand BOOLEQUAL operand
	 | operand LESSEQUAL operand
         | operand GREATEQUAL operand
         | operand LESS operand
         | operand GREAT operand
         | operand NEG operand
         | conditii AND conditii
         | conditii OR conditii
         ;
operand: ID /* functie returnare valoare */{valoarea_variabilei($1);}
       | INTEGER {$$ = $1;}
       | FLOAT {$$ = $1;}
	     ;
operatii: tip_operatie SEMICOLON
        | operatii tip_operatie SEMICOLON
        ;
tip_operatie: ID EQUAL operatie
	    ;
operatie:operand
	|operatie PLUS operatie {$$ = $1 + $3;}
        |operatie MINUS operatie {$$ = $1 + $3;}
        |operatie MULT operatie {$$ = $1 + $3;}
        |operatie DIVIDE operatie {$$ = $1 + $3;}
        ;
conditie_for:statement SEMICOLON conditii SEMICOLON operatie
            ;
statement:ID ASSIGN operand
         ;
%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
}

