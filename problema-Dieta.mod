
set N;
#NUTRIENTES

set F;
#ALIMENTOS

param b{N};
#QUANTIDADE DIARIA MINIMA DE NUTRIENTES

param a{F,N};
#VALOR NUTRITIVO DOS ALIMENTOS POR UNIDADE M0NETARIA

var x{f in F} >= 0;
#QUANTIDADE DE NUTRIENTES OBTIDAS COMPRANDO UMA UNIDADE DO ALIMENTO

minimize cost: sum{f in F} x[f];
#FUNÇÃO OBJETIVO

s.a. nb{n in N}: sum{f in F} a[f,n] * x[f] = b[n];
#BALANÇO DE NUTRIENTES POR UNIDADE


printf "\n";
" oper Taref Custo \n";
printf{i in I} "%5d %5d %10g\n", i, sum {j in J} j* x[i, j]
	sum{j in J} c[i,j]*x[i,j]
printf "------------\n"
printf "Total: %10g\n", sum{i in I, j in J} c[i,j] * x[i,j];
printf "\n"
end;


