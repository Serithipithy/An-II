%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%token BOOL BGIN CONST END IF THEN ELSE ENDIF WHILE DO ENDWHILE FOR THENDO ENDFOR CLASS AND OR
%token BOOLEQUAL ASSIGN EQUAL NOT NEG LESS LESSEQUAL GREAT GREATEQUAL PLUS MINUS MULT DIVIDE
%token RPARAN LPARAN BROPEN BRCLOSE AOPEN ACLOSE SEMICOLON COMMA TIP ID INTEGER CHAR FLOAT STRING

%start compilator

%left PLUS MINUS
%left MUL DIVIDE
%left OR AND
%left COMMA

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

declaratie: TIP ID SEMICOLON /*int a; sau int a,b,c;*/
	  | TIP ID BROPEN INTEGER BRCLOSE SEMICOLON /*vectori*/
	  | TIP ID BROPEN INTEGER BRCLOSE BROPEN INTEGER BRCLOSE SEMICOLON /*matrici*/
	  | CONST TIP ID SEMICOLON
	  | TIP ID sign // pt functii si clase
	  ;
sign: AOPEN ACLOSE
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
	 | NOT operand
	 | operand BOOLEQUAL operand
	 | operand LESSEQUAL operand
         | operand GREATEQUAL operand
         | operand LESS operand
         | operand GREAT operand
         | operand NEG operand
         | conditii AND conditii
         | conditii OR conditii
	 | BOOL 
         ;
operand: ID
       | INTEGER
       | FLOAT
	     ;
operatii: tip_operatie SEMICOLON
        | operatii tip_operatie SEMICOLON
        ;
tip_operatie: ID EQUAL operatie
	    ;
operatie:operand PLUS operand {$$ = $1 + $3;}
        |operand MINUS operand {$$ = $1 + $3;}
        |operand MULT operand {$$ = $1 + $3;}
        |operand DIVIDE operand {$$ = $1 + $3;}
	|operand
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
