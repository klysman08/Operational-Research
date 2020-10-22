set I; # Produtos
set J; # Processos

param L{I}; # Lucro unitario
param RC{I,J}; # Recurso consumido
param CR{J}; # Custo do recurso
param R{i in I}:= sum{j in J}RC[i,j]*CR[j]+L[i]; # Receita

# display R;
param CF{J}; # Custo "fixo" do process j de supervisor e manutencao, mas pode ser desativado
param CV{I}; # Custo variavel do produtoi
param D{J}; # Dispon ibil idades
param LM{J}; # Lote minimo no processo j

var x{I}, >= 0;# Producao
var y{J}, binary; # Se a Linha j eh ou nao ativada

maximize LT: sum{i in I}(R[i]-CV[i])*x[i] - sum{j in J}CF[j]*y[j];


s.t. R1{j in J}: sum{i in I}RC[i,j]*x[i] <= D[j];
s.t. R2{j in J: j != 'Funcio'}:sum{i in I}RC[i,j]*x[i] <= D[j]*y[j];
s.t. R3{j in J, i in I: i = 'Armario'}: x[i] >= LM[j]*y[j]; # redundante

solve;

display LT;

display x;
display y;
display I;

printf "\n \nPRODUTO\tQDE \n";
printf{i in I}: "%s\t%3d\n", i, x[i];
printf "\n";

printf " \n%7s\t%7s\t%7s\t%8s\n", "RECURSO", "USO","LIM", "PERC";
printf{j in J}: "%7s\t%7d\t%7d\t%7.2f%%\n", j, R1[j], D[j], (R1[j]/D[j])*100;
printf "\n\n";

printf "Lucro: %.2f\n\n", LT;


data;

param:J: D CR CF LM:=
Montag 120 50 2016 0
Pintur 48 76 1200 5
Funcio 2000 0 0 0
;

param:I: L CV:=
Mesa 350 32
Cama 470 32
Armario 610 38.50
;

param RC: Montag Pintur Funcio:=
Mesa 1 0 10
Cama 1 0 15
Armario 0 1 20
;

end;


