%{
	#include <stdlib.h>  
	#include "calc.h"
	#include "mfcalc.tab.h"
%}

NUM [0-9]
ID [a-z][a-z0-9]*
OP [+-/*]

%%

{NUM}+"."*{NUM}*	{ yylval.dval = atof(yytext); return NUM;	}

"exit"			{ printf("Goodbye!\n"); exit(0);            	}

"func "{ID}*            { yylval.sval = getsym(yytext);	return DEF;     }

{ID}			{ yylval.sval = getsym(yytext);
			  if(!yylval.sval){ yylval.sval = putsym(strdup(yytext), TYP_VAR);  	  return VAR; 		}
			  if(yylval.sval->type == TYP_VAR) 					{ return VAR;		}
			  if(yylval.sval->type == TYP_ARIT_FNCT)				{ return ARIT_FNCT;	}
			  if(yylval.sval->type == TYP_NAT_FNCT) 				{ return NAT_FNCT;	}
			}

[+-/*=:\n()^] 		return yytext[0];
     
[ \t]+
%%
