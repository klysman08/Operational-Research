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
import os
import random

import cplex
from cplex.exceptions import CplexError

# biblioteca para lidar com arquivos json
import json                #(*@\label{ln:json}@*)
from pprint import pprint

# ------------------------------
# pacotes adicionais interessantes 
# ------------------------------
import time
import six
import matplotlib.pyplot as plt
from matplotlib import colors
from reportlab.lib.units import cm
from reportlab.pdfgen import canvas

'''
como vamos criar funcoes para nos auxiliar
na construcao do modelo, vamos importar as
funcoes que sao feitas nesse arquivo basicoio.py 
'''
# ------------------------------
#
# ------------------------------
from basicoio import *

if __name__ == "__main__":
   try:
      # verifica se dois comandos
      # foram passados na linha de comando
      if (len(sys.argv) != 2):
         print("Uso:\n python {:s} [arquivo de dados - txt ou json]".format(sys.argv[0]))
         sys.exit(-1)

      tipo_arquivo = sys.argv[1][sys.argv[1].rfind('.')+1:len(sys.argv[1])]   #(*@\label{ln:filetype}@*)
      if (tipo_arquivo == "txt"):
         # le parametros de um arquivo txt
         np,nm,obj,lado_direito,restricoes  = le_dados_txt(sys.argv[1])
      else:
         # le parametros de um arquivo json
         np,nm,obj,lado_direito,restricoes  = le_dados_json(sys.argv[1])

      prob = cplex.Cplex()
      prob.objective.set_sense(prob.objective.sense.maximize)

      prob.variables.add(obj   = obj, lb    = [0.0] * np, ub    = [cplex.infinity] * np, names = [ "x_P{:d}".format(j+1) for j in range(np)]) #(*@\label{ln:of}@*) 

      # com um unico comando de instrucao
      # podemos criar as restricoes 
      [prob.linear_constraints.add(lin_expr = [ 
                               cplex.SparsePair([j for j in range(np)], [restricoes[i][j] for j in range(np)]) ], 
                               senses   = "L", 
                               rhs      = [lado_direito[i]], 
                               names    = ["M{:d}".format(i+1)]) for i in range(nm)]    #(*@\label{ln:constraints}@*)
     
      prob.solve()
  
      if (prob.solution.get_status() == prob.solution.status.optimal):
         print("")
         print("Status       : {:d} ({:s})".format(prob.solution.get_status(),
                                                   prob.solution.status[prob.solution.get_status()]))
         of = prob.solution.get_objective_value()
         print("Solucao otima: ${:10.2f}".format(of))
       
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
           
         faz_grafico_pizza(np,x) #(*@\label{ln:plotpie}@*)
         faz_grafico_barra(np,x) #(*@\label{ln:plotbar}@*)
         faz_relatorio(np,x,of)         #(*@\label{ln:report}@*)
      else:
         print("")
         print("Status       : {:d} ({:s})".format(prob.solution.get_status(),
                                                   prob.solution.status[prob.solution.get_status()]))
         raise ValueError('Erro ao otimizar o modelo')
          
   except CplexError as exc:
      print(exc)
      sys.exit(-1)

# ------------------------------
#
# ------------------------------
def le_dados_txt(arquivo):
    if (os.path.isfile(arquivo) == False):
       raise ValueError('Arquivo {:s} nao encontrado'.format(arquivo))
        
    fl = open(arquivo,'r')
    # -------------------------
    # le linhas e remove linhas em branco 
    # -------------------------
    lines = (line.strip() for line in fl)
    lines = (line for line in lines if line)
    
    # -------------------------
    # le dados 
    # -------------------------
    np = int(next(lines))        # numero de produtos 
    nm = int(next(lines))        # numero de maquinas 

    # le uma linha, separando
    # os elementos por espacos em branco
    # os elementos sao lidos como string
    ln = next(lines).split()
    obj = []                     # criando um vetor dinamicamente
    for it in ln: 
        obj.append(float(it))    # inserindo elementos dinamicamente no vetor 

    # le uma linha separando por espaco em branco 
    # e mapeando num vetor com valores do tipo float
    lado_direito = map(float,next(lines).split())

    # le uma matriz
    restricoes = [map(float,next(lines).split()) for i in range(nm)] 
    # -------------------------
    # fechando arquivo de dados 
    # -------------------------
    fl.close() 
    return np,nm,obj,lado_direito,restricoes
# ------------------------------
#
# ------------------------------
def le_dados_json(arquivo):
    if (os.path.isfile(arquivo) == False):
       raise ValueError('Arquivo {:s} nao encontrado'.format(arquivo))

    # le o arquivo json
    with open(arquivo) as fl:
         dados = json.load(fl)

    # imprime arquivo json
    #pprint(dados)

    np = dados["np"]
    nm = dados["nm"]
    obj = dados["obj"]
    lado_direito = dados["lado"] 
    restricoes = dados["restricoes"] 
    return np,nm,obj,lado_direito,restricoes
    
# ------------------------------ 
#                               
# ------------------------------
def faz_grafico_pizza(np,x): 
    colors_ = [v for (u,v) in list(six.iteritems(colors.cnames))]
    cores = [colors_[random.randint(0,len(colors_))] for i in range(np)]

    total_produzido = sum(x)
    rotulos = ["Produto {:d}".format(j+1) for j in range(np)]      
    tamanhos = [x[j]/total_produzido for j in range(np)] 

    fig = plt.figure()
    plt.pie(tamanhos, labels=rotulos, colors = cores, autopct='%1.1f%%', shadow=True, startangle=90)
    plt.axis('equal')
    plt.show()
    fig.savefig("piechart.pdf",format='pdf')
    fig.savefig("piechart.png",format='png')
# ------------------------------
#
# ------------------------------
def faz_grafico_barra(np,x):
    colors_ = [v for (u,v) in list(six.iteritems(colors.cnames))]
    cores = [colors_[random.randint(0,len(colors_))] for i in range(np)]
    
    rotulos = ["Produto {:d}".format(j+1) for j in range(np)]      
    posicao = [i for i in range(np)]

    fig = plt.figure()
    plt.bar(posicao, x, align="center", alpha=0.5)#, colors = cores)
    plt.ylabel("Producao")
    plt.title("Producao de cada produto")
    plt.xticks(posicao,rotulos)
    plt.show()
    fig.savefig("barchart.pdf",format='pdf')
    fig.savefig("barchart.png",format='png')
# ------------------------------
#
# ------------------------------
def faz_relatorio(np,x,of):
    c = canvas.Canvas("report.pdf")
    c.setLineWidth(.3)
    c.setFont('Helvetica', 12)
 
    c.drawString(250,800,"RELATORIO DE PRODUCAO")
    c.drawString(30,750,'EMPRESAS PRODUTIVAS REUNIDAS')

    c.drawString(500,750,time.strftime("%d/%m/%y"))
    c.line(480,747,580,747)

    c.drawString(30,725,'ELABORADO POR:')
    c.line(140,725,580,725)
    c.drawString(140,727,"Joao Silva")
 
    c.drawString(380,700,'RECEITA TOTAL:')
    c.drawString(500,703,"${:10.2f}".format(of))
    c.line(480,700,580,700)
 
    c.drawImage("barchart.png",200,300,width=8*cm,preserveAspectRatio=True) 
    c.drawImage("piechart.png",200,100,width=8*cm,preserveAspectRatio=True) 

    c.save()
