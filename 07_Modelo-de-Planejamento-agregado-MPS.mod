## Indices
set I; #Tipos de Produtos
set T; # Periodos

## Parametros
param C{i in I, t in T};# custo de producao
param CS{i in I, t in T} default 10; # custo de setup do produto I
param H{i in I}; # custo de estocagem do produto i
param D{i in I, t in T}; # demanda
param E{i in I}; # estoque inicia

param SS{i in I} default 0; # estoque de segurança
param LM{i in I} default 1; #Lote múltiplo
param TP{i in I}; # homem. hora/prod.
param TS{i in I};#homem. hora/setup

param CH{t in T}; # custo homem. hora reg.
param CE{t in T}; # custo homem. hora ext.
param CHM{t in T}; #cap reg. max. disp
param CEM{t in T}; # cap reg. max. disp




param BigM{i in I}:= ceil(max{t in T}CHM[t]/TP[i]); # Mgrande: Upper bound /* display BigM; */ # Capaci dade maxima de produção (bom upper bound)

## Varidveis de Decisao
var x{i in I, t in T}>=0, integer; # vol.de producao prod. i em t
var y{i in I, t in T}, binary; # decide a produção de i emt
var h{i in I,t in 0..card(T)}, >= SS[i]; # Estoque de i no periodo t
var w{t in 0..card (T)}, >=0; # forca trab. disp. em t
var s{t in T}, >=0; # vol. h.hora extra em t

minimize CustoTotal: sum{i in I, t in T}(C[i,t]*x[i,t]*LM[i] + H[i]*h[i,t] + CS[i,t]*y[i,t]) + sum{t in T}(CH[t]*w[t] + CE[t]*s[t]);


## Restricões Tecnológicas
s.t. R1{t in 0..card (T), i in I: t = 0}: h[i,t] = E[i];
s.t. R2{i in I, t in T: t > 0}: x[i, t]*LM[i] + h[i,t-1] = D[i,t] + h[i,t];
s.t. R3{t in T}: sum{i in I} (TP[i]*x[i,t]*LM[i] + TS[i]*y[i,t]) <= w[t] + s[t];
s.t. R4{i in I, t in T}: x[i,t]*LM[i] <= y[i,t]*BigM[i];
s.t. R5{t in T}: w[t]<= CHM[t]; /* Força de Traba Lho Fixa */
s.t. R6{t in T}: s[t]<= CEM[t]; /* Força de Trabalho Fixa */

solve;

display CustoTotal;

data; ## Parametros

param: I: 
	TP TS E SS LM H:=
1 10 10 0 . . 4
2 12 12 15 . . 5
3 13 13 18 . . 5;

param: T:
	CH CE CHM CEM:=
1 12 24 2000 20
2 16 26 2000 20
3 16 32 2000 10
4 17 40 2000 20
5 18 45 2000 30
6 16 46 2000 30
7 14 36 2000 40
8 13 32 2000 20
9 10 26 2000 20;

param C :
	1 2 3 4 5 6 7 8 9:=
1 	8 2 4 6 7 5 4 8 1
2 	2 5 4 7 5 2 9 5 1
3 	7 3 4 6 5 8 2 3 2;

param D:
	1 2 3 4 5 6 7 8 9:=
1 10 25 11 16 18 26 35 76 98
2 43 72 75 83 64 42 35 12 38
3 84 96 61 25 83 36 82 94 67;

end;



