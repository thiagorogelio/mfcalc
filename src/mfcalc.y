%{
  #include <stdio.h>  
  #include <math.h>  
  #include "calc.h"
%}

%union {
  double dval;
  struct symrec *sval;
}

%token <dval>  NUM      
%token <sval> VAR N_FNCT FNCT 
%type  <dval>  exp

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^'     
%%

input:
  %empty
| input line
;

line:
  '\n'
| exp '\n'   { printf ("%.10g\n", $1); }
| error '\n' { yyerrok;                }
;

/*
body:
  exp		    {					}

;

params:
  VAR
;*/

exp:
  NUM                { $$ = $1;                         }
| VAR                { $$ = $1->value.var;              }
| VAR '=' exp        { $$ = $3; $1->value.var = $3;     }
| N_FNCT '(' exp ')' { $$ = (*($1->value.fnctptr))($3); }
//| FNCT '('params')'  { /*call func*/ }
| exp '+' exp        { $$ = $1 + $3;                    }
| exp '-' exp        { $$ = $1 - $3;                    }
| exp '*' exp        { $$ = $1 * $3;                    }
| exp '/' exp        { $$ = $1 / $3;                    }
| '-' exp  %prec NEG { $$ = -$2;                        }
| exp '^' exp        { $$ = pow ($1, $3);               }
| '(' exp ')'        { $$ = $2;                         }
;

%%

symrec *sym_table;

struct init
{
  char const *fname;
  double (*fnct) (double);
};

struct init const arith_fncts[] =
{
  { "atan", atan },
  { "cos",  cos  },
  { "exp",  exp  },
  { "ln",   log  },
  { "sin",  sin  },
  { "sqrt", sqrt },
  { 0, 0 },
};

static void init_table(){
  int i;
  for (i = 0; arith_fncts[i].fname != 0; i++)
    {
      symrec *ptr = putsym (arith_fncts[i].fname, TYP_NAT_FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }
}

int yywrap(){return 1;}

int main (int argc, char const* argv[])
{
  init_table();
  return yyparse ();
}

