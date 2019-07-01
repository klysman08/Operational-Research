#Problema do Job Shop
#Nome: Klysman Rezende 
#Matricula: 2017108779


#NUMERO DE TRABALHOS
param n, integer, > 0;

#QUANTIDADE DE MAQUINAS
param m, integer, > 0;


#CONJUNTO DE TRABALHOS EM J
set J := 1..n;

#CONJUNTO DE MAQUINAS EM M
set M := 1..m;

#PERMUTACAO DAS MAQUINASRE
#REPRESENTA A ORDEM DE PROCESSAMENTO SENDO [J,1...n]
param sigma{j in J, t in 1..m}, in M;

#PERMUTACAO NECESSARIA PARA J
check{j in J, t1 in 1..m, t2 in 1..m: t1 <> t2}:
      sigma[j,t1] != sigma[j,t2];

#TEMPO DE PROCESSAMENTO NO CONJUNTO J
param p{j in J, a in M}, >= 0;

#QUANDO COMEÇAR 
var x{j in J, a in M}, >= 0;
/* starting time of j on a */

#SÓ IRÁ COMEÇAR A SER PROCESSANDO SOMENTE DEPOIS DE TER SIDO COMPLETADO EM sigma [j, t-1]
s.t. ord{j in J, t in 2..m}:
      x[j, sigma[j,t]] >= x[j, sigma[j,t-1]] + p[j, sigma[j,t-1]];


#CONDIÇAO DISJUNTIVA PARA AS MAQUINAS PARA MANIPULAR O MAXIMO POSSIVEL

      x[i,a] >= x[j,a] + p[j,a]  or  x[j,a] >= x[i,a] + p[i,a]

var Y{i in J, j in J, a in M}, binary;


param K := sum{j in J, a in M} p[j,a];

display K;

s.t. phi{i in J, j in J, a in M: i <> j}:
      x[i,a] >= x[j,a] + p[j,a] - K * Y[i,j,a];
/* x[i,a] >= x[j,a] + p[j,a] iff Y[i,j,a] is 0 */

s.t. psi{i in J, j in J, a in M: i <> j}:
      x[j,a] >= x[i,a] + p[i,a] - K * (1 - Y[i,j,a]);
/* x[j,a] >= x[i,a] + p[i,a] iff Y[i,j,a] is 1 */

var z;

#MAXIMO DE TEMPO DE CONCLUSAO DOS TRABALHOS
s.t. fin{j in J}: z >= x[j, sigma[j,m]] + p[j, sigma[j,m]];


#FUNCAO OBJETIVO TEM COMO MINIMIZAR Z O MENOR POSSIVEL
minimize obj: z;



