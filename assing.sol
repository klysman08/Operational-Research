Problem:    assign
Rows:       8
Columns:    12 (12 integer, 12 binary)
Non-zeros:  36
Status:     INTEGER OPTIMAL
Objective:  obj = 4 (MINimum)

   No.   Row name        Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 obj                         4                             
     2 oper[1]                     1                           1 
     3 oper[2]                     1                           1 
     4 oper[3]                     1                           1 
     5 oper[4]                     0                           1 
     6 tarefas[1]                  1             1             = 
     7 tarefas[2]                  1             1             = 
     8 tarefas[3]                  1             1             = 

   No. Column name       Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 x[1,1]       *              1             0             1 
     2 x[1,2]       *              0             0             1 
     3 x[1,3]       *              0             0             1 
     4 x[2,1]       *              0             0             1 
     5 x[2,2]       *              1             0             1 
     6 x[2,3]       *              0             0             1 
     7 x[3,1]       *              0             0             1 
     8 x[3,2]       *              0             0             1 
     9 x[3,3]       *              1             0             1 
    10 x[4,1]       *              0             0             1 
    11 x[4,2]       *              0             0             1 
    12 x[4,3]       *              0             0             1 

Integer feasibility conditions:

KKT.PE: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

KKT.PB: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

End of output
