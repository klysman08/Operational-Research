set I; # origem
set J; # destinos

param O{I}; # Oferta de mesas em i
param D{J}; # Demanda de mesas em j
param C{I,J}; # Custo uni tario de transporte de i para j

var x{I,J}, >= 0; # Qde mesas transportadas de i para j
var y{J}, binary; 

printf "\n\nHellooo\n\n";

# Atendimento pela Fabrica em "C_cajur' e atendimento pelo CD em B_horiz'
minimize Custo_Transporte_Total: 
	sum{i in I, j in J: i = 'C_cajur'}C[i,j]*x[i,j]+ 
	sum{i in I, j in J: i = 'B_horiz'}C[i,j]*D[j]*y[j];

printf "\n\nHellooo2\n\n";

# Atendimento pela Fabrica em "C_cajur
s.t. R1{i in I: i ='C_cajur'}: sum{j in J}x[i,j] <= O[i];
# Atendimento pelo CD em B_horiz
s.t. R2{i in I: i = 'B_horiz'}: sum{j in J}y[j]*D[j] <= O[i];
# Atendimento pelo CD em 'B_horiz' deve se Limitar a 3 clientes, no maximo
s.t. R3: sum{j in J}y[j] <= 3;
s.t. R4{j in J}: sum{i in I: i = 'C_cajur'}x[i, j] + y[j]*D[j] = D[j];

solve;

display Custo_Transporte_Total;

printf "\n\nORIGEM\tDESTINO\ETRANSP\ n";
printf{i in I, j in J: i = 'C_cajur'}: "%7s\t%7s\ t%6.2f\n", i, j, x[i,j];
printf{i in I, j in J: i = 'B_horiz'}: "%7s\ t%7s\t%6.2f\n", i, j, y[j]*D[j];
printf "\n\n";
printf "Custo de transporte total : R$%5.2f", Custo_Transporte_Total;
printf "n\n";

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
B_horiz 24.00 15.00 28.00 20.00 18.50 19.50 24.00 28.00
;

end;