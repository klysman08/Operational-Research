set I; # produtos
set J; # processos
set T:= 1..4; # periodos

param L{I}; # Lucro unitario de produto i
param H{I}; # Custo unitario de estoque i
param E{I}; # Estoque inicial do produto i
param R{I,J}; # Recurso que i consome no recurso j
param D{J}; # Disp. do recuros j
param VMax{I,T}; # Prev vendas max de i no periodo t
param VMin{I,T}; # Prev vendas min de i no periodo t


var x{I,T}, >= 0; # Producao de i no periodo t
var h{I,t in 0..card(T)}, >= 0; # Estoque de i no periodo t
var v{I,T}, >= 0; # Vendas de i no periodo t


maximize Lucro_Total: sum{i in I,t in T}(L[i]*v[i,t] - H[i]*h[i,t]);

s.t. R1{t in T, j in J}: sum{i in I}x[i,t]*R[i,j] <= D[j];
s.t. R2{t in 0..card(T), i in I: t = 0}: h[i,t] = E[i];
s.t. R3{t in T, i in I}: h[i,t-1] + x[i,t] = v[i,t] + h[i,t];
s.t. R4{t in T, i in I}: v[i,t] >= VMin[i,t];
s.t. R5{t in T, i in I}: v[i,t] <= VMax[i,t];

solve;
display Lucro_Total;
display x;


data;

param:J: D:=
Montagem 120
Pintura 48
Funcionarios 2000;

param:I: L H E:=
Mesa 350 9 22
Cama 470 100 42
Armario 610 18 36;

param R: Montagem Pintura Funcionarios:=
Mesa 1 0 10
Cama 1 0 15
Armario 0 1 20;

param VMax: 1 2 3 4:=
Mesa 60 80 120 140
Cama 40 40 40 40
Armario 50 40 30 70;

param VMin: 1 2 3 4:=
Mesa 20 20 20 20
Cama 20 20 20 20
Armario 20 20 20 20;

end;
