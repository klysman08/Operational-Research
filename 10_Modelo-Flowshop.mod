param n, integer, >=1; /* n�mero de m�quinas */
param m, integer, >=1; /* n�mero de itens */
set M:={1..n}; 
set I:={1..m};
#tempo de produ��o do item i na m�quina j
param TP{i in I, j in M} >=0;

#/BigM
param BigM:=1+sum{i in I, j in M} TP[i,j];

#/data de inicio de processamento do item i na m�quinaj */
var t{i in I, j in M} >=0;

#vari�ve is para modeLar restric�es disjuntivas (apenas 1 � ativada) "/
var y{j in M, i in I, k in I: i<k}, binary;

var makespan >= 0;


minimize obj: makespan;

/* Rela��o de preced�ncia: A data de inicio de processamento do
item i na m�quina j+l tem que ser >= inicio de processamento
do item i na m�quina j */

s.t. R1{i in I, j in M:j<n}: t[i,j+1]>=t[i, j]+TP[i,j];
s.t. R2{j in M, i in I, k in I: i<k}: t[i,j]-t[k,j]+BigM*y[j,i,k]>=TP[k,j];
s.t. R3{j in M, i in I, k in I: i<k}: t[k,j]-t[i,j]+BigM*(1-y[j,i,k])>=TP[i,j];

/*makespan � a data de process amento de todos os itens na �ltima m�quina */
s.t. R4{i in I}: t[i,n] + TP[i,n] <= makespan;

solve;

display makespan;
#Apos a solu��o, cumputar os tempos finaios para ser usado no relatorio
#param FIM{i in I, j in M}:= t[i,t] + TP[i,t];


set ATIV dimen 2:= I cross M;
set MAQ {i in I}:= setof {(i,j) in ATIV} j;

param r {i in I, j in MAQ[i]}:= 1 + sum{h in MAQ[i]: t[i,j] < t[i,j] || t[i,h] == t[i,j] && h < j} 1;


set JOB {j in M} := setof {(i,j) in ATIV} i;
param s{j in M, i in JOB[j]}:= 1 + sum{q in JOB[j]: t[q,j] < t[i,j] || t[q,j] == t[i,j] && q < i} 1;


data;
param n:=3; #/ n�mero de m�quinas
param m:=7; #/ n�mero de itens

# tempo de produ��o do item i na m�quina j
param TP: 1 2 3:=
1 3 3 2
2 9 3 8
3 9 8 5
4 4 8 4
5 6 10 3
6 6 3 1
7 7 10 3;

end;




