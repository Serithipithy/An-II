%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"TRUE" | "FALSE" {yylval.strval=strdup(yytext); return BOOL;}
"begin_main" {return BGIN;}
"end_main" {return END;}
"if" {return IF;}
"then" {return THEN;}
"else" {return ELSE;}
"end_if" {return ENDIF;}
"while" {return WHILE;}
"do" {return DO;}
"endwhile" {return ENDWHILE;}
"for" {return FOR;}
"then_do" {return THENDO;}
"end_for" {return ENDFOR;}
"class" {return CLASS;}
"&&" {return AND;}
"||" {return OR;}
"==" {return BOOLEQUAL;}
":=" {return ASSIGN;}
"=" {return EQUAL;}
"~" {return NOT;}
"!=" {return NEG;}
"<" {return LESS;}
"<=" {return LESSEQUAL;}
">" {return GREAT;}
">=" {return GRETEQUAL;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MULT;}
"/" {return DIVIDE;}
")" {return RPARAN;}
"(" {return LPARAN;}
"[" {return BROPEN;}
"]" {return BRCLOSE;}
"{" {return AOPEN;}
"}" {return ACLOSE;}
";" {return SEMICOLON;}
"," {return COMMA;}
"int"|"float"|"char"|"string"|"bool" {yylval.str = strdup(yytext); return TIP;}
\#[_a-zA-Z][_a-zA-Z0-9]* {yylval.str = strdup(yytext); return ID;}
[-+]?[1-9][0-9]* {yylval.intval=atoi(yytext); return INTEGER;}
[-+]?[1-9]*[.][0-9]+ {yylval.fval = atof(yytext); return FLOAT;}
[a-zA-Z] { yylval.char=strdup(yytext); return CHAR;}
\"[_a-zA-Z ]+\" {yylval.strval=strdup(yytext); return STRING;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
