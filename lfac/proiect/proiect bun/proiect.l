%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"const" {return CONST;}
"TRUE" | "FALSE" {yylval.str=strdup(yytext); return BOOL;}
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
">=" {return GREATEQUAL;}
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
[-+]?[1-9][0-9]* {yylval.num=atoi(yytext); return INTEGER;}
[-+]?[1-9]*[.][0-9]+ {yylval.fl = atof(yytext); return FLOAT;}
\<[a-zA-Z] { yylval.str=strdup(yytext); return CHAR;}
\"[_a-zA-Z ]+\" {yylval.str=strdup(yytext); return STRING;}
\>[1-9][0-9]*\> {yylval.str=strdup(yytext); return NR;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
