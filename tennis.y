%code {
#include <stdio.h>
#include <string.h>

extern int yylex(void);
void yyerror(const char *s);

int calcYears(int start, int end);
struct player calcMaxWins(struct player p1, struct player p2);
}

%code requires {
    enum constants { MIN_WINS = 0, MAX_SIZE = 50 };

    struct player {
        char playerName[MAX_SIZE];
		int numOfWinsInWimbledon;	
    };
}

%union {
    struct player _player;
	char name[MAX_SIZE];
	int gender;
	int numOfWins;
	int year;
}

%token TITLE NAME WIMBLEDON OPEN_AUSTRALIAN OPEN_FRENCH
%token <gender> GENDER
%token <year> YEAR_NUM
%token <name> PLAYER_NAME

%nterm <numOfWins> wimbledon yearList years_range
%nterm <_player> playerList player

%define parse.error verbose

%%

start: TITLE playerList { if($2.numOfWinsInWimbledon == 0){
			printf("There is no woman player that wins in wimbledon\n"); }
			else{
				printf("Woman with greatest number of wins at Wimbledon: %s (%d wins)\n", $2.playerName, $2.numOfWinsInWimbledon); }
			};
			
playerList: playerList player {$$ = calcMaxWins($1, $2); };

playerList: player { strcpy($$.playerName, $1.playerName); 
						$$.numOfWinsInWimbledon = $1.numOfWinsInWimbledon; };
						
player: NAME PLAYER_NAME GENDER 
		wimbledon open_australian open_french
		{ if($3) { strcpy($$.playerName, $2); $$.numOfWinsInWimbledon = $4; }
		else{
			$$.numOfWinsInWimbledon = 0; };
		};
			
wimbledon: WIMBLEDON yearList {$$ = $2; }; | %empty {$$ = 0;};

open_australian: OPEN_AUSTRALIAN yearList {}; | %empty {};

open_french: OPEN_FRENCH yearList {}; | %empty {};

yearList: yearList ',' years_range { $$ = $1 + $3 ; };

yearList: years_range { $$ = $1; };

years_range: YEAR_NUM {$$ = 1; } | YEAR_NUM '-' YEAR_NUM { $$ = calcYears($1, $3); };

%% 

int main(int argc, char **argv)
{
    extern FILE *yyin;
    if (argc != 2) 
    {
        fprintf(stderr, "Usage: ./%s <input-file-name>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) 
    {
        fprintf(stderr, "failed to open %s\n", argv[1]);
        return 1;
    }

    yyparse();
    
    fclose(yyin);
    return 0;
}

void yyerror(const char *s)
{
    extern int line;
    fprintf(stderr, "line %d: %s\n", line, s);
}

int calcYears(int start, int end)
{
   return (end-start)+1;
}

struct player calcMaxWins(struct player p1, struct player p2)
{
	if(p1.numOfWinsInWimbledon >= p2.numOfWinsInWimbledon)
		return p1;
	else
		return p2;
}
