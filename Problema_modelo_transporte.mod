#conjuntos
set I;#origens 
set J;#destinos

#parametros
param O{I};#ofertas em i
param D{J};#demanda em j

param C{I,J};#custo de transporte de i para j
#variaveis
var x{I,J},>=0;#qnt transportada de i para j

minimize Custo_Transporte_Total:sum{i in I,j in J}C[i,j]*x[i,j];

s.t. R1{i in I}:sum{j in J}x[i,j] <= O[i];
s.t. R2{j in J}:sum{i in I}x[i,j] = D[j];

solve;

printf "\n\nORIGEM\tDESTINO\tTRANSP\n";
printf{i in I, j in J}: if x[i,j] > 0 then "%7s\t%7s\t%6.2f\n" else "", i , j , x[i,j];
printf "\n\n";
printf "Custo de transporte: %5.2f",Custo_Transporte_Total;
printf "\n\n";

data;

param:I:    O:=
Carm    80
Belo    70;

param:J:    D:=
Dvn 20
Ita 20
Pmi 10
Bet 20
Bhz 40
Con 10
Nli 15
Stl 15;

param C:Dvn Ita Pmi Bet Bhz Con Nli Stl:=
Carm    14  24  21  20  22  19  17  30
Belo    24  15  28  20  19  20  24  28;