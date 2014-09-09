%{
	#include "calc.h"
	#include "mfcalc.tab.h"
	char c;
%}

NUM [0-9]
ID [a-z][a-z0-9]*
OP [+-/*]

%%

{NUM}+"."*{NUM}*	{ yylval.dval = atof(yytext); return NUM;}

{ID}			{ yylval.sval = getsym(yytext);
			  if(!yylval.sval){ yylval.sval = putsym(strdup(yytext), TYP_VAR);  return VAR; }
			  if(yylval.sval->type == TYP_VAR) return VAR;
			  if(yylval.sval->type == TYP_NAT_FNCT) return N_FNCT;
			  return FNCT;
			}

[+-/*=:\n()^] 		return yytext[0];
     
[ \t]+ {}
%%
