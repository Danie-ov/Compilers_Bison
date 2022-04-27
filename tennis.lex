%{
#include <string.h>
#include <ctype.h> 
#include "tennis.tab.h"

extern int atoi (const char *);
enum gender {MAN,WOMAN};
int line=1;
%}

%option noyywrap
%option yylineno

%%

"** Winners **" {return TITLE;}

\<name\> {return NAME;}

\<Wimbledon\> { return WIMBLEDON; }

\<Australian" "Open\> { return OPEN_AUSTRALIAN; }

\<French" "Open\>  { return OPEN_FRENCH; }

18[5-9][0-9]|19[0-9]{2}|[2-9][0-9]{3,} { yylval.year = atoi(yytext); return YEAR_NUM;}

["`'][a-zA-Z]+(" "[a-zA-Z]+)*["`'] {strcpy(yylval.name,yytext+1); yylval.name[strlen(yylval.name)-1]='\0';return PLAYER_NAME;}

\<Woman\> {yylval.gender = WOMAN; return GENDER; }

\<Man\> {yylval.gender = MAN; return GENDER; }

","  {return ',';}

"-" {return '-';}

[\t\r ]+  /* skip white space */

\n {line++; }

. {fprintf (stderr, "Line number : %d unrecognized token %c \n",yylineno,yytext[0]);}

%%