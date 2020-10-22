set I; # produtos
set J; # processos
set T:= 1..4; # periodos


param REC{I}; # Receita dei


param L{I}; # Lucro unitario de produto i
param H{I}; #Custo unitario de estoque i
param E{I}; # Estoque inicial do produto i
param R{I,J}; #Recurso que i consomeno recurso j
param D{J}; # Disp. do recurosj
param VMax {I,T};# Prev vendas max de i no periodo t
param VMin{I, T};#Prev vendas min de i no periodo t
param CO{J};


var x{I,T}, >= 0; # Producao de i no periodo t
var h{I,t in 0..card(T)}, >=0; # Estoque de i no periodo t
var v{I,T}, >= 0; #Vendas de i no periodo t
var y{I,T}, binary; # Ativa a economia de escala
var ymc{T}, binary; #Linha de montagem para porduzir mesa e cama no mesmo periodo

maximize Lucro_Total: sum{i in I, t in T}(L[i]*v[i,t] - H[i]*h[i,t]);

s.t. R1{t in T, j in J}: sum{i in I}x[i,t]*R[i,j] <= D[j];
s.t. R2{t in 0..card(T), i in I: t = 0}: h[i,t] = E[i];
s.t. R3{t in T, i in I}: h[i,t-1] + x[i,t] = v[i,t] + h[i,t];
s.t. R4{t in T, i in I} : v[i,t] >= VMin[i,t];
s.t. R5{t in T, i in I}: v[i,t] <= VMax [i,t];

# Se ambos mesa E cadeira forem produzidos, entao a soma de y - 1 = 1e ymc eh = 1 Logo havera changeover
s.t. R6{t in T}: ymc[t] >= sum{i in I: i != 'Armario'}y[i,t] - 1;
# Se o changeover eh ativado, ha reducao da capacidade, em CO unidades de tempo
s.t. R7{t in T, j in J}: sum{i in I: i != 'Armario' }x[i,t] + ymc[t]*CO[j] <= D[j];
# Se algum produto i for produzido, entao a variavel y precisa ser 1
s.t. R8{t in T, i in I, j in J}: x[i,t] <= D[j]*y[i,t];


solve;
printf Lucro_Total;
display Lucro_Total;
display VMax;


data;


param:J: D CO:=
Montag 120 20
Pintur 48 0
Funcio 2000 0;

param:I: L H E:=
Mesa 350 9 22 
Cama 470 10 42 
Armario 610 18 36;


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


