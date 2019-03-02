%{
#include <iostream>
#include<string>
#include <cstring>
#include <cstdlib>
#include"y.tab.h"
using namespace std;

%}

INT int
FLOAT float
DOT \.
SEMICOLON ";"
ADD_OP "+"
MUL_OP "*"
ASSIGN_OP "="
O_BRAC "("
C_BRAC ")"
LETTER  [a-zA-Z]
NUMBER  [0-9]
INT_C [0-9]+
FLOAT_C {INT_C}{DOT}{INT_C}
IDENTIFIER {LETTER}({LETTER}|{NUMBER})*
WSPACE  [ \t\n]+



%option noyywrap
%option yylineno

%%

{INT}            {//cout << "INT ";
                    		strcpy(yylval.value.val,yytext);
                 return INT;
}
{FLOAT}            {//cout << "FLOAT ";
                             strcpy(yylval.value.val,yytext);
                return FLOAT;
}
{SEMICOLON}            {//cout << "SEMICOLON ";
                             strcpy(yylval.value.val,yytext);
                return SEMICOLON;
}
{O_BRAC}            {//cout << "O_BRAC ";
                             strcpy(yylval.value.val,yytext);
                return O_BRAC;
}
{C_BRAC}            {//cout << "C_BRAC ";
                             strcpy(yylval.value.val,yytext);
               return C_BRAC;
}
{ADD_OP}            {//cout << "ADD_OP ";
                             strcpy(yylval.value.val,yytext);
                return ADD_OP;
}
{MUL_OP}            {//cout << "MUL_OP ";
                             strcpy(yylval.value.val,yytext);
                return MUL_OP;
}
{ASSIGN_OP}            {//cout << "ASSIGN_OP ";
                             strcpy(yylval.value.val,yytext);
                return ASSIGN_OP;
}
{IDENTIFIER}                {//cout << "IDENTIFIER ";
                              strcpy(yylval.value.val,yytext);
                     return IDENTIFIER; 
}

{WSPACE}            {;}
{INT_C}			{
					//cout<<"INT_C ";
					strcpy(yylval.value.val,yytext);
					return INT_C;
}
{FLOAT_C}	{
					//cout<<"FLOAT_C ";
					strcpy(yylval.value.val,yytext);
					return FLOAT_C;
}



%%

