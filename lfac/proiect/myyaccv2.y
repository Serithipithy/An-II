%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct variabila
{
int valoare_int;
float valoare_float;
char valoare_char;
char* valoare_string;
char* nume;
char* tip_variabila;
_Bool constanta;
_Bool valoare_init;  /* are o valoare initializata*/
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
     for(int i=0;i<v;i++)
        {
          if(strcmp(variabile[i].nume,nume)==0) return i;
        }
      return -1;
}

void declarare_fara_initializare(char* tip_variabila,char* nume,_Bool constanta)
{
      if(variabile_declarate(nume)!=-1)
       {
         char buffer[256];
         sprintf(buffer,"Variabila %s este deja declarata",nume);
         yyerror(buffer);
         exit(0);
       }
     if(constanta==1)
      {
        char buffer[256];
        sprintf(buffer,"Nu puteti declara variabile de tip const %s fara initializare",nume);
        yyerror(buffer);
        exit(0);
       }
     variabile[v].tip_variabila=strdup(tip_variabila);
     variabile[v].nume=strdup(nume);
     variabile[v].valoare_init=0;
     variabile[v].constanta=0;
     v++;
}


void declarare_cu_initializare_int(char* tip_variabila,char*nume,int valoare,_Bool constanta)
{
    if(variabile_declarate(nume)!=-1)
      {
        char buffer[256];
        sprintf(buffer,"Variabila %s este deja declarata",nume);
        yyerror(buffer);
        exit(0);
      }
    if(strcmp(tip_variabila,"int") != 0)
    {
		char buffer[256];
        sprintf(buffer,"Variabila %s este de tip %s, iar valoarea asignata este de tip int.",nume, tip_variabila);
        yyerror(buffer);
        exit(1);
    }
    variabile[v].tip_variabila=strdup(tip_variabila);
    variabile[v].nume=strdup(nume);
    variabile[v].valoare_int=valoare;
    variabile[v].valoare_init=1;
    variabile[v].constanta=constanta;
    v++;
}

void declarare_cu_initializare_float(char* tip_variabila,char*nume,float valoare,_Bool constanta)
{
    if(variabile_declarate(nume)!=-1)
      {
        char buffer[256];
        sprintf(buffer,"Variabila %s este deja declarata",nume);
        yyerror(buffer);
        exit(0);
      }
      if(strcmp(tip_variabila,"float") != 0)
    {
		char buffer[256];
        sprintf(buffer,"Variabila %s este de tip %s, iar valoarea asignata este de tip float.",nume, tip_variabila);
        yyerror(buffer);
        exit(1);
    }
    variabile[v].tip_variabila=strdup(tip_variabila);
    variabile[v].nume=strdup(nume);
    variabile[v].valoare_float=valoare;
    variabile[v].valoare_init=1;
    variabile[v].constanta=constanta;
    v++;
}

void declarare_cu_initializare_char(char* tip_variabila,char*nume,char valoare,_Bool constanta)
{
    if(variabile_declarate(nume)!=-1)
      {
        char buffer[256];
        sprintf(buffer,"Variabila %s este deja declarata",nume);
        yyerror(buffer);
        exit(0);
      }

  	if(strcmp(tip_variabila,"char") != 0)
    {
		char buffer[256];
        sprintf(buffer,"Variabila %s este de tip %s, iar valoarea asignata este de tip char.",nume, tip_variabila);
        yyerror(buffer);
        exit(1);
    }
    variabile[v].tip_variabila=strdup(tip_variabila);
    variabile[v].nume=strdup(nume);
    variabile[v].valoare_char=valoare;
    variabile[v].valoare_init=1;
    variabile[v].constanta=constanta;
    v++;
}

void declarare_cu_initializare_string(char* tip_variabila,char*nume,char* valoare,_Bool constanta)
{
    if(variabile_declarate(nume)!=-1)
      {
        char buffer[256];
        sprintf(buffer,"Variabila %s este deja declarata",nume);
        yyerror(buffer);
        exit(0);
      }
    if(strcmp(tip_variabila,"string") != 0)
    {
		char buffer[256];
        sprintf(buffer,"Variabila %s este de tip %s, iar valoarea asignata este de tip string.",nume, tip_variabila);
        yyerror(buffer);
        exit(1);
    }
    variabile[v].tip_variabila=strdup(tip_variabila);
    variabile[v].nume=strdup(nume);
    variabile[v].valoare_string=valoare;
    variabile[v].valoare_init=1;
    variabile[v].constanta=constanta;
    v++;
}

void declarare_cu_variabila_initializata(char* tip_variabila,char* nume,char*variabila, _Bool constanta)
{
	if(variabile_declarate(nume)!=-1)
    {
        char buffer[256];
        sprintf(buffer,"Variabila %s este deja declarata",nume);
        yyerror(buffer);
        exit(0);
    }
    int pozitie=variabile_declarate(variabila);
    if(pozitie == -1)
	{
		char buffer[256];
		sprintf(buffer,"Variabila %s nu poate fi initializata cu o variabila nedeclarata",nume);
		yyerror(buffer);
		exit(1);
	}
	if(strcmp(tip_variabila,variabile[pozitie].tip_variabila) != 0)
	{
		char buffer[256];
		sprintf(buffer,"Variabilele %s si %s nu sunt de acelasi tip.",nume,variabile[pozitie].nume);
		yyerror(buffer);
		exit(2);
	}
	if(variabile[pozitie].valoare_init == 0)
	{
		char buffer[256];
		sprintf(buffer,"Variabilele %s nu poate fi initializata deoarece variabila %s nu are inca o valoare initializata.",nume,variabile[pozitie].nume);
		yyerror(buffer);
		exit(3);
	}

	variabile[v].tip_variabila=strdup(tip_variabila);
	variabile[v].nume=strdup(nume);
	variabile[v].valoare_init=1;
	variabile[v].constanta=constanta;
	if(strcmp(tip_variabila,"int") == 0)
	{
		variabile[v].valoare_int=variabile[pozitie].valoare_int;
	}
	else
		if(strcmp(tip_variabila,"float") == 0)
		{
			variabile[v].valoare_float=variabile[pozitie].valoare_float;
		}
		else
			if(strcmp(tip_variabila,"char") == 0)
			{
				variabile[v].valoare_char=variabile[pozitie].valoare_char;
			}
			else
				{
					variabile[v].valoare_string=variabile[pozitie].valoare_string;
				}
	v++;
}

int valoarea_variabilei(char* nume)
{
    int poz=variabile_declarate(nume);
    if(poz==-1)
    {
       char buffer[256];
       sprintf(buffer,"Variabila %s nu a fost declarata",nume);
       yyerror(buffer);
       exit(0);
    }
    if(variabile[poz].valoare_init==0)
    {
       char buffer[256];
       sprintf(buffer,"Variabila %s nu are nicio valoare",nume);
       yyerror(buffer);
       exit(0);
    }
    if(strcmp(variabile[poz].tip_variabila,"int") == 0)
	{
		return variabile[poz].valoare_int;
	}
	else
		if(strcmp(variabile[poz].tip_variabila,"float") == 0)
		{
			return variabile[poz].valoare_float;
		}
		else
			if(strcmp(variabile[poz].tip_variabila,"char") == 0)
			{
				return variabile[poz].valoare_char;
			}
			else
				{
					return variabile[poz].valoare_string;
				}
}

void asignare_valoare(char* nume,float valoare)
{
	int pozitie = variabile_declarate(nume);

	if(pozitie == -1)
	{
	   char buffer[256];
       sprintf(buffer,"Variabila %s nu a fost declarata",nume);
       yyerror(buffer);
       exit(0);
	}

	if(variabile[pozitie].constanta == 1)
	{
	   char buffer[256];
       sprintf(buffer,"Nu se poate asigna o noua valoarea variabile constante %s.",nume);
       yyerror(buffer);
       exit(1);
	}
    /* nu stiu cum sa inglobez toate valorile, asa ca am dat float in caz de orice */
    if(strcmp(variabile[pozitie].tip_variabila,"float") != 0 &&
     strcmp(variabile[pozitie].tip_variabila,"int") != 0)
     {
     	char buffer[256];
        sprintf(buffer,"Nu se poate asigna o valoare numerica variabilei %s.",nume);
        yyerror(buffer);
        exit(2);
     }

     if(strcmp(variabile[pozitie].tip_variabila,"float") == 0)
     {
     	variabile[pozitie].valoare_float=valoare;
     	variabile[pozitie].valoare_init=1;
     }
     else
     {
     	variabile[pozitie].valoare_int=valoare;
     	variabile[pozitie].valoare_init=1;
     }

}
int functii_declarate(char* nume,char* args)
{
    for(int i=0;i<f;i++)
    {
       if((strcmp(functii[i].nume,nume)==0)&&(strcmp(functii[i].argumente,args))) return i;
    }
    return -1;
}
void declarare_functie(char* tip, char* nume,char* args )
{
    if(functii_declarate(nume,args)!=-1)
    {
       char buffer[200];
       sprintf(buffer,"Nu puteti declara 2 functii %s cu acelasi nume",nume);
       yyerror(buffer);
       exit(0);
    }
    functii[f].tip_functie=strdup(nume);
    functii[f].nume=strdup(nume);
    functii[f].argumente=strdup(args);
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
%type <str> TIP ID CHAR STRING BOOL signatura parametrii

%%

compilator: program {printf("program corect sintactic \n");}
          ;

program: clase declaratii main
       |declaratii main
	     | clase main
	     | main
	     ;

clase: clasa
     | clase SEMICOLON clasa
     ;
clasa: CLASS ID AOPEN declaratii ACLOSE SEMICOLON
     ;

main:BGIN AOPEN blocuri ACLOSE END
    ;

declaratii:declaratie
	        | declaratii declaratie
	        ;

declaratie: TIP ID SEMICOLON /*int a; sau int a,b,c;//functie de declarare fara valoare*/ {declarare_fara_initializare($1,$2,0);}
	        | TIP ID ASSIGN INTEGER SEMICOLON /*functie de declarare cu o valoare*/{declarare_cu_initializare_int($1,$2,$4,0);}
	        | TIP ID ASSIGN FLOAT SEMICOLON {declarare_cu_initializare_float($1,$2,$4,0);}
	        | TIP ID ASSIGN STRING SEMICOLON {declarare_cu_initializare_string($1,$2,$4,0);}
	        | TIP ID ASSIGN CHAR SEMICOLON {declarare_cu_initializare_char($1,$2,$4,0);}
	        | TIP ID ASSIGN ID SEMICOLON {declarare_cu_variabila_initializata($1,$2,$4,0);}
	        | CONST TIP ID SEMICOLON {declarare_fara_initializare($2,$3,1);}
	        | CONST TIP ID ASSIGN INTEGER SEMICOLON {declarare_cu_initializare_int($2,$3,$5,1);}
	        | CONST TIP ID ASSIGN FLOAT SEMICOLON {declarare_cu_initializare_float($2,$3,$5,1);}
	        | CONST TIP ID ASSIGN ID SEMICOLON {declarare_cu_variabila_initializata($2,$3,$5,1);}
	        | TIP ID signatura /* pt functii si clase*/{declarare_functie($1,$2,$3);}
	        ;
signatura: LPARAN RPARAN { $$=malloc(200); $$[0]=0;}
    	   | LPARAN parametrii RPARAN { $$ = $2; }
    	   ;

parametrii: TIP ID { $$ = $1; strcat($$,", "); }
	        | parametrii COMMA TIP ID  { $$ = $1; strcat($$,$3); }
          ;

blocuri: bloc
       | blocuri bloc
       ;

bloc: IF LPARAN conditii RPARAN THEN AOPEN operatii ACLOSE ENDIF
    | IF LPARAN conditii RPARAN THEN AOPEN operatii ACLOSE ELSE AOPEN operatii ACLOSE ENDIF
    | WHILE LPARAN conditii RPARAN DO AOPEN operatii ACLOSE ENDWHILE
    | FOR LPARAN conditie_for RPARAN DO AOPEN operatii ACLOSE ENDFOR
    | operatii
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
operand: ID /* functie returnare valoare */{$$=valoarea_variabilei($1);}
       | INTEGER {$$ = $1;}
       | FLOAT {$$ = $1;}
	     ;
operatii: tip_operatie SEMICOLON
        | operatii SEMICOLON tip_operatie SEMICOLON
        ;
tip_operatie: ID ASSIGN operatie {asignare_valoare($1,$3);}
	          ;
operatie:operand
	      |operatie PLUS operatie {$$ = $1 + $3;}
        |operatie MINUS operatie {$$ = $1 - $3;}
        |operatie MULT operatie {$$ = $1 * $3;}
        |operatie DIVIDE operatie {$$ = $1 / $3;}
        ;
conditie_for:statement SEMICOLON conditii SEMICOLON operatie
            ;
statement:ID ASSIGN operand {asignare_valoare($1,$3);}
         ;
%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
}
