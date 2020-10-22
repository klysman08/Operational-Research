#Conjuntos
set T:= 1..12; # 3 Meses: 12 Semanas de planejamento de médio-prazo;
set J; #Itens pais Produto acabado;
set I;#Itens fi Lhos Componentes;
set K;#Recursos Processos de produção;
set S{i in I};#Conjunto de sucessores do item i;

#Parâmetros
param R{i in I, j in J} default 0; #Qde de i p/ fazer um j Demanda dependente;
param P{j in J, t in T}; #Qde de produto final do plano MPS (exl ou ex2)
param D{i in I, t in T}; #Demanda final do item i.
param C{i in I}; #Custo unitário de produzir um item i
param F{i in I}; #Custo de setup de produção (produto A>B)
param H{i in I}; #Custo uni tário de estocar um item i
param E{i in I}; #Estoque inicial do item i no periodo t-1
param SS{i in I} default 0; #Estoque de segurança do item i nos periodos
param LM{i in I} default 1; #lote múltiplo de producão de item i
param LT{i in I}; #Lead time para produzir um Lote do produto i;
param M := max{i in I}SS[i]*20; #Valor M grande (Lote máximo no periodo);
param A{i in I,k in K}; #Quantidade do recurso k consumido pelo item is
param B{i in I,k in K}; #Quantidade do recurso k consumido pelo setup de i
param L{k in K, t in T}; #Quantidade de recurso k disponive l no periodo t;

#Variáveis de Decisão
var x{i in I union J, t in T}, >=0, integer; #Producao i produzir no periodo t
var y{i in I, t in T}, >=0, binary; #Decisão de realizar ou não o setup;
var h{i in I,t in 0..card(T)}, >=SS[i]; # Estoque de i no periodo t

#Função Objetivo
minimize CustoTotal: sum{i in I, t in T} (C[i]*LM[i]*x[i,t] + F[i]*y[i,t] + H[i]*h[i,t]);

#Restrições tecnologicas
s.t. R0{t in T, j in J}: x[j,t] = P[j,t];
s.t. R1{t in 0..card (T), i in I: t = 0}: h[i,t] = E[i];
s.t. R2{i in I, t in T: t > LT[i] and t > 0}: h[i,t-1] + LM[i]*x[i,t-LT[i]] = D[i,t] + sum{j in S[i]}R[i,j]*x[j,t] + h[i,t];
s.t. R3{i in I, t in T: t <= LT[i] and t > 0}: h[i,t-1] = D[i,t] + sum{j in S[i]}R[i,j]*x[j,t] + h[i,t];
s.t. R4{i in I, t in T}: LM[i]*x[i,t] <= M*y[i,t];
s.t. R5{t in T, k in K}: sum{i in I} A[i,k]*LM[i]*x[i,t] + sum{i in I}B[i,k]*y[i,t] <= L[k,t];

solve;


data;
#Conjuntos
set J:= P1 P2 P3; #Itens pais;
set K:= M1 M2; #Recursos;

#Conjunto de sucessores do item i;
set S[AA]:= P1 P2;
set S[BB]:= P1;
set S[CC]:= P2 P3;
set S[DD]:= P1 P2 P3;
set S[EE]:= P3;
set S[FF]:= P1 P3;

#Parametros
param: I:
	C F H E LT SS LM:=
AA 40 10 2 20 1 10 .
BB 60 10 3 33 3 10 5
CC 80 15 4 335 5 10 .
DD 40 10 5 25 2 10 .
EE 60 10 3 35 3 10 5
FF 80 15 1 20 1 10 10;


param R: #Qde do item i para fazer um item j - Demanda dependente;
	P1 P2 P3:=
AA 1 2 .
BB 3 . .
CC . 1 3
DD 0.5 0.2 0.3
EE . . 2
FF 2 . 1;

param P: #Demanda final do item i. (3 meses = 12 semanas)
	1 2 3 4 5 6 7 8 9 10 11 12:=
P1 0 0 0 10 0 0 0 49 0 0 0 21
P2 0 0 0 85 0 0 0 15 0 0 0 78
P3 0 0 0 66 0 0 0 100 0 0 0 63;

param D: #Demanda final do item i. Demanda finaL;
	1 2 3 4 5 6 7 8 9 10 11 12:=
AA 9 5 10 8 8 9 5 10 5 5 5 5
BB 9 5 9 7 6 6 9 5 6 8 7 7
CC 7 6 6 9 10 8 9 9 10 9 10 10
DD 10 5 8 5 7 6 8 10 7 7 9 9
EE 5 7 8 6 10 7 9 10 8 5 10 5
FF 9 5 5 9 5 9 5 6 10 8 9 6;

param A (tr): #Quantidade do recurso k consumido pelo item i;
	AA BB CC DD EE FF:=
M1 0.2 0.3 0.4 0.1 0.1 0.2
M2 0.3 0.2 0.3 0.4 0.1 0.2;

param B (tr): #Quant i dade do recurso k consumido pelo setup de i;
	AA BB CC DD EE FF:=
M1 2 3 2 1 2 3
M2 3 2 1 1 2 3;

param L: #Quantidade de recurso k disponivel no periodo t;
	1 2 3 4 5 6 7 8 9 10 11 12:=
M1 100 100 150 50 100 100 100 50 50 50 50 50
M2 100 100 150 50 100 100 100 50 50 50 50 50;

end;