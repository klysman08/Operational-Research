# -*- coding: utf-8 -*-
# ------------------------------
# exemplo: modelo basico
#        max 5x1 + 3,5x2 + 4,5x3
# sujeito a: 3x1 + 5x2 + 4x3 <= 480    M1
#            6x1 + 1x2 + 3x3 <= 540    M2
#            x1,x2,x3 >= 0
#
# ------------------------------
import sys
import cplex
from cplex.exceptions import CplexError

if __name__ == "__main__":
   try:
      # parametros
      obj = [5,3.5,4.5]
      lb  = [0.0,0.0,0.0] 
      ub  = [cplex.infinity,cplex.infinity, cplex.infinity]
      nome_vars = ["x_P1", "x_P2", "x_P3"]

      restricoes = [[ ["x_P1","x_P2","x_P3"],[3.0,5.0,4.0] ],
                    [ [0,1,2],[6.0,1.0,3.0]                ] ]
      lado_direito = [480,540]
      nome_restricoes = ["M1", "M2"]
      sentido = "LL"

      prob = cplex.Cplex()
      prob.objective.set_sense(prob.objective.sense.maximize)

      prob.variables.add(obj   = obj,
                         lb    = lb,
                         ub    = ub, 
                         names = nome_vars) 
    
      # com um unico comando de instrucao
      # podemos criar as restricoes 
      prob.linear_constraints.add(lin_expr = restricoes,
                                  senses   = sentido,
                                  rhs      = lado_direito,
                                  names    = nome_restricoes)
     
      prob.solve()
  
      if (prob.solution.get_status() == prob.solution.status.optimal):
         print("")
         print("Status       : {:d} ({:s})".format(prob.solution.get_status(),
                                                   prob.solution.status[prob.solution.get_status()]))
         print("Solucao otima: ${:10.2f}".format(prob.solution.get_objective_value()))
       
         numcols = prob.variables.get_num()

         x = prob.solution.get_values()

         print("")
         print("Produto  : Producao ")
         for j in range(numcols): 
             print("{:8d} : {:10.2f}".format(j+1,x[j]))

         numlins = prob.linear_constraints.get_num()

         folgas = prob.solution.get_linear_slacks()

         print("")
         print("Maquina  : Folga ")
         for i in range(numlins): 
             print("{:8d} : {:10.2f}".format(i+1,folgas[i]))

      else:
         print("")
         print("Status       : {:d} ({:s})".format(prob.solution.get_status(),
                                                   prob.solution.status[prob.solution.get_status()]))
         raise ValueError('Erro ao otimizar o modelo')
          
   except CplexError as exc:
      print(exc)
      sys.exit(-1)
