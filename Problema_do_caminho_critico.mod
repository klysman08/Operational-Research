#Programa do Assign
#                           Klysman Rezende 
#                           10/06


/*  PROBLEMA DO CAMINHO CRITICO */

set J;
#CONJUNTO DE ATIVIDADES

set P{j in J}, in J, default {};
#SUB-CONJUNTO DE TAREFAS QUE PRECEDE IMEDIATAMENTE O TRABALHO j

param t{j in J}, >= 0;
#DURAÇÃO NECESSÁRIA PRA EXECUTAR O TRABALHO j

var x{j in J}, >= 0;
#HORA DE INICIO DO TRABALHO j

s.t. phi{j in J, k in P[j]}: x[j] >= x[k] + t[k];
#TRABALHO SÓ PODE COMEÇAR DEPOIS DE TODOS OS TRABALHOS IMEDIATAMENTE ANTERIORES TEREM SIDO COMPLETAMENTE EXECUTADO

var z;
#PROJETO MAKESPAN

s.t. fin{j in J}: z >= x[j] + t[j];
# QUE É O MAXIMO DOS TEMPOS DE CONCLUSÃO DE TODOS OS TRABALHOS

minimize obj: z;
#OBJETIVO É TORNAR O Z O MENOR POSSÍVEL

data;

/* The optimal solution is 46 */

param : J :  t :=
        A    3    /* Excavate */
        B    4    /* Lay foundation */
        C    3    /* Rough plumbing */
        D   10    /* Frame */
        E    8    /* Finish exterior */
        F    4    /* Install HVAC */
        G    6    /* Rough electric */
        H    8    /* Sheet rock */
        I    5    /* Install cabinets */
        J    5    /* Paint */
        K    4    /* Final plumbing */
        L    2    /* Final electric */
        M    4    /* Install flooring */
;

set P[B] := A;
set P[C] := B;
set P[D] := B;
set P[E] := D;
set P[F] := D;
set P[G] := D;
set P[H] := C E F G;
set P[I] := H;
set P[J] := H;
set P[K] := I;
set P[L] := J;
set P[M] := K L;

end;
