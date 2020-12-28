%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%token BOOL BGIN END IF THEN ELSE ENDIF WHILE DO ENDWHILE FOR THENDO ENDFOR CLASS AND OR
%token BOOLEQUAL ASSIGN EQUAL NOT NEG LESS LESSEQUAL GREAT GRETEQUAL PLUS MINUS MULT DIVIDE
%token RPARAN LPARAN BROPEN BRCLOSE AOPEN ACLOSE SEMICOLON COMMA TIP ID INTEGER CHAR FLOAT STRING

%start compilator
%union
{
    int num;
    char* str;
}

%type <num> INTEGER FLOAT
%type <str> TIP ID CHAR STRING BOOL

%%

compilator: BGIN program END {printf("program corect sintactic \n");}
          ;

program: declaratii instructiuni /* gen int a; char b;  si dupa ce faci cu ele*/
       ;
/*declaratii de variabile*/

declaratii: declaratie
          | declaratii declaratie /* int a;int b;*/
          ;

declaratie: TIP ID SEMICOLON /* int a;int b;*/
          | TIP ID LPARAN lista_param RPARAN  /*char abc (int a,int b) inca confuza af despre asta zic sa scoatem*/
          | TIP ID BROPEN INTEGER BRCLOSE SEMICOLON  /*int v[34] vectori gen*/
          | TIP ID BROPEN INTEGER BRCLOSE BROPEN INTEGER BRCLOSE SEMICOLON/* int a[2][4] matrici gen */
          ;

lista_param: param
           | lista_param COMMA param
           ;

param: TIP ID
     ;

/*instructiuni gen for while si altele */

instructiuni: loops
            | statement
            | operatii
            | loops instructiuni
            | statement instructiuni
            | operatii instructiuni
            ;

loops: FOR LPARAN expresii RPARAN  DO AOPEN operatii ACLOSE ENDFOR
     | WHILE LPARAN expresii RPARAN DO AOPEN operatii ACLOSE ENDWHILE
     ;

statement: IF LPARAN expresii RPARAN THEN AOPEN operatii ACLOSE ENDIF
         | ELSE DO AOPEN operatii ACLOSE
         | IF LPARAN expresii RPARAN THEN AOPEN operatii ACLOSE ENDIF ELSE DO AOPEN operatii ACLOSE
         ;
/*astea sunt gen if(a<b) sau while(x>10) **pt for nu stiu exact cum sa facem*/

expresii:expresie
        | expresii operator_bool expresie
        ;

expresie: ID operator_bool ID
        | ID operator_bool INTEGER
        ;

operator_bool:AND
             |OR
             |BOOLEQUAL
             |NEG
             |LESSEQUAL
             |LESS
             |GREAT
             |GRETEQUAL
             ;
operatii:operatie SEMICOLON
        ;

operatie:ID ASSIGN ID
        | ID EQUAL operatie
        | ID PLUS ID
        | ID MINUS ID
        | ID MULT ID
        | ID DIVIDE ID
        | ID PLUS tipuri
        | ID MINUS tipuri
        | ID MULT tipuri
        | ID DIVIDE tipuri
        ;
tipuri:INTEGER
      |FLOAT
      |CHAR
      |STRING
      ;

%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
}
