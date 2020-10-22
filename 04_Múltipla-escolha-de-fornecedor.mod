set I; # origem
set J; # destinos

param O{I}; # Oferta de mesas em i
param D{J}; # Demanda de mesas em j
param C{I,J}; # Custo uni tario de transporte de i para j

var x{I,J}, >= 0; # Qde mesas transportadas de i para j
var y{I}, binary; # Escolha de um fornecedor


# Atendimento normal para todos, menos o 'Stl'
#Custo ajustado so para o 'Stl'

minimize Custo_Transporte_Total:
	sum{i in I, j in J: j != 'Stl'}C[i,j]*x[i,j] + sum{i in I, j in J: j = 'Stl'}C[i,j]*D[j]*y[i];

# Atendimento normal para todos, menos ostl'"
#A demanda do mercado 'Stl' de 20 unid deve ser atendida por apenas 1 fornecedor
s.t. R1{i in I}: sum{j in J: j != 'Stl'}x[i,j] + D['Stl']*y[i] <= O[i];
s.t. R2: sum{i in I}y[i] = 1;
s.t. R3{j in J}: sum{i in I}x[i,j] = D[j];

solve;

display Custo_Transporte_Total;
data;

param:I: O:=
C_cajur 100
B_horiz 45;

param:J:D:=
Dvn 22
Ita 14
Pmi 18
Bet 17
Bhz 15
Con 13
Nli 15
Stl 20;

param C: Dvn Ita Pmi Bet Bhz Con Nli Stl :=
C_cajur 14.00 24.00 21.00 20.00 21.50 19.00 17.00 30.00
B_horiz 24.00 15.00 28.00 20.00 18.50 19.50 24.00 28.00;

end;