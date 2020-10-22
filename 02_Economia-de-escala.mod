set I; # produtos
set J; # processos
set T:= 1..4; # periodos

set Q; #Quantidades com/sem desconto

param REC{I}; # Receita dei
param CUS{I,Q}; # Custo de de i pela qde com/semdesconto

param L{I}; # Lucro unitario de produto i
param H{I}; #Custo unitario de estoque i
param E{I}; # Estoque inicial do produto i


param R{I,J}; #Recurso que i consomeno recurso j
param D{J}; # Disp. do recurosj

param VMax {I,T};# Prev vendas max de i no periodo t
param VMin{I, T};#Prev vendas min de i no periodo t

param QEE{I}; # Qde a partir da qual se tem economia de escala (desconto)

var x{I,T}, >= 0; # Producao de i no periodo t
var h{I,t in 0..card(T)}, >=0; # Estoque de i no periodo t
var v{I,T}, >= 0; #Vendas de i no periodo t
var p{I,Q,T}, >= 0; # Compradei nofipo dedesconfoq noperiodot
var y{I,T}, binary; # Ativa a economia de escala

maximize Lucro_Total: sum{i in I, t in T}(REC[i]*v[i,t] - H[i]*h[i,t]) - sum{i in I, q in Q, t in T: i = 'Armario'}CUS[i,q]*p[i,q,t];

s.t. R1{t in T, j in J}: sum{i in I}x[i,t]*R[i,j] <= D[j];
s.t. R2{t in 0..card(T), i in I: t = 0}: h[i,t] = E[i];
s.t. R3{t in T, i in I}: h[i,t-1] + x[i,t] = v[i,t] + h[i,t];
s.t. R4{t in T, i in I} : v[i,t] >= VMin[i,t];
s.t. R5{t in T, i in I}: v[i,t] <= VMax [i,t];
s.t. R6{t in T, i in I:i = 'Armario'}: v[i,t] = sum{q in Q}p[i,q,t];
s.t. R7{t in T, i in I, q in Q: i = 'Armario' and q = 'QS'}: p[i,q,t] <= QEE[i];
s.t. R8{t in T, i in I, q in Q: i = 'Armario' and q = 'QS'}: p[i,q,t] >= QEE[i]*y[i,t];

s.t. R9{t in T, i in I, j in J, q in Q: i = 'Armario' and q = 'QC' and R[i,j]> 0}:
p[i,q,t] <= (D[j]/R[i,j]-QEE [i])*y[i,t];

solve;
printf Lucro_Total;
display Lucro_Total;
display VMax;


data;

set Q:=
QS
QC
;

param:J: D:=
Montag 120
Pintur 48
Funcio 2000;

param:I: L H E REC QEE:=
Mesa 350 9 22 350 0
Cama 470 10 42 470 0
Armario 610 18 36 860 30;

param CUS: QS QC:=
Mesa 0 0
Cama 0 0
Armario 250 200;

param R: Montag Pintur Funcio:=
Mesa 1 0 10
Cama 1 0 15
Armario 0 1 20;

param VMax: 1 2 3 4:= # Prev vendas max de i no periodo t
Mesa 60 80 120 140
Cama 40 40 40 40
Armario 50 40 30 70;

param VMin: 1 2 3 4:= # Prev vendas min de i no periodo t
Mesa 20 20 20 20
Cama 20 20 20 20
Armario 20 20 20 20;

end;


