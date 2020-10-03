set I;

param R{I};
param CMP {I};
param CMOD {I};
param C{i in I}:= CMP[i] + CMOD[i];
param L{i in I}:= R[i] - C[i];
param A {I};
param K {I};
param DA;
param DK;
param D{I};

var x{I}, >= 0;

maximize LUCRO: sum{i in I}L[i]*x[i];

s.t. R1: sum{i in I} A[i]*x[i] <= DA;
s.t. R2: sum{i in I} K[i]*x[i] <= DK;
s.t. R3{i in I}: x [i] <= D[i];


solve;
display LUCRO;
display x;

data;

set I:=
1
2;

param DA:= 100;
param DK:= 80;

param R:=
1 27
2 21;

param CMP:=
1 10
2 9;

param CMOD:=
1 14
2 10;

param A:=
1 2
2 1;

param K:=
1 1
2 1;

param D:=
1 40
2 30;

end;
