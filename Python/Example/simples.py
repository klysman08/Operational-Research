#!/usr/bin/python
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
      # criamos um objeto com o resolvedor CPLEX 
      prob = cplex.Cplex()

      # informamos que o sentido da otimizacao
      # sera de maximizacao
      prob.objective.set_sense(prob.objective.sense.maximize)

      # criamos as variaveis informando 
      # os coeficientes  na funcao objetivo (obj), 
      # os limites inferiores (lb) e superiores (ub),
      # os nomes de cada variavel de decisao
      prob.variables.add(obj   = [5,3.5,4.5],
                         lb    = [0.0,0.0,0.0], 
                         ub    = [cplex.infinity,cplex.infinity, cplex.infinity],
                         names = ["x_P1", "x_P2", "x_P3"])
     
      # ha diversas formas de adicionar as restricoes
      # ao modelo
      # 1) informando o nome das variaveis e os coeficientes (lin_expr)
      # de cada restricao, juntamente com o tipo de desigualdade
      # (senses) e o lado direito da desigualdade (rhs). O nome
      # da restricao tambem pode ser informado
      # Tipos de restricoes:
      #      L : <=
      #      G : >=
      #      E : =
      prob.linear_constraints.add(lin_expr = [[ ["x_P1", "x_P2", "x_P3"], [3.0,5.0,4.0] ]],
                                  senses   = "L",
                                  rhs      = [480],
                                  names    = ["M1"])
     
      # 2) podemos informar no lugar dos nomes das variaveis
      # os respectivos indices ([0,1,2]) 
      prob.linear_constraints.add(lin_expr = [[ [0,1,2], [6.0,1.0,3.0] ]],
                                  senses   = "L",
                                  rhs      = [540],
                                  names    = ["M2"])
     
      # invocamos o resolver do CPLEX para otimizar o modelo 
      prob.solve()
  
      # verificamos se o resolver teve exito    
      if (prob.solution.get_status() == prob.solution.status.optimal):
         # imprimimos o status da solucao
         print("")
         print("Status       : {:d} ({:s})".format(prob.solution.get_status(),
                                                   prob.solution.status[prob.solution.get_status()]))
         # imprimimos o valor otimo da funcao objetivo
         print("Solucao otima: ${:10.2f}".format(prob.solution.get_objective_value()))
       
         # pegamos o numero de variaveis
         numcols = prob.variables.get_num()

         # pegamos os valores otimos das variaveis de decisao
         x = prob.solution.get_values()

         print("")
         print("Produto  : Producao ")
         for j in range(numcols): 
             print("{:8d} : {:10.2f}".format(j+1,x[j]))

         # pegamos o numero de restricoes 
         numlins = prob.linear_constraints.get_num()

         # pegamos a folga de cada maquina (recurso)
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
