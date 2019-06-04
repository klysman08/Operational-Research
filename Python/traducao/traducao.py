#!/usr/bin/python
# -*- coding: utf-8 -*-
# ------------------------------
# Leitura de um arquivo de dados da literatura
#   do problema do job shop e imprimir 
#   um arquivo .dat
# 
#  
# Carlos Roberto Venancio de Carvalho
# 16/11/2017
# agradecimento as contribuicoes do Prof. Ricardo Camargo, DEP
# ------------------------------
import sys
import os





# ----------------------------------------------------------------------
#
# Funcoes par definir os nomes dos arquivos de entrada e saida
#
# ----------------------------------------------------------------------

def arquivoEntrada():
    return r"./sdata/abz5"
    
    
def arquivoSaida():
    return "./saida/abz5.dat"



    

# ----------------------------------------------------------------------
#
# Funcao para abrir um arquivo do job shop e ler dos dados deste arquivo
#
# ----------------------------------------------------------------------

def LerDados(arquivo):

    # tentar abrir o arquivo, se nao existe, aborta o programa
    if (os.path.isfile(arquivo) == False):
        raise ValueError('ERRO: Arquivo {:s} nao encontrado'.format(arquivo))
    
    fl = open(arquivo,'r')
    # -------------------------
    # le linhas e remove linhas em branco 
    # -------------------------
    lines = (line.strip() for line in fl)
    lines = (line for line in lines if line)
    
    # -------------------------
    # le dados 
    # -------------------------
 
    # le a primeira linha, separando
    # os elementos por espacos em branco
    # os elementos sao lidos como string
    ln = next(lines).split()
    for it in ln: 
        nm = int(it)
        nj = int(it)

    # contar o numero total de operacoes
    int nTotOp = 0

    # numOpJob: vetor do tamanho do numero de jobs, cada posicao do vetor possui
    #         o numero de operacoes do job referente a posicao
    # lisMaqJob: lista de jobs, cada elemento da lista possui a sequencia de maquinas do job
    #           correspondente ao elemento da lista
    # lisTemProcJob: lista de jobs, cada elemento da lista possui o tempo de processamento de
    #           cada operacao da sequencia de operacoes do job correspondente ao
    #           elemento da lista

    # criar o vetor numOpJob com todos elementos iguais a zero
    numOpJob = []
    for i in range(nj):
        numOpJob.append(0)

    # criar as listas listTemProcJob e listMaqJob vazias
    lisTemProcJob = []
    lisMaqJob = []

    # criar as listas com seus respectivos elementos
    for j in range(nj):
        linhaArq = []
        ln = next(lines).split()
        for it in ln:
            linhaArq.append(int(it))
        i = 0
        numOpJob[j] = linhaArq[i]
        numVect = numOpJob[j] * 3
        i = 0
        ii = 1
        linhaTemp = []
        linhaMaq = []
        while ii < numVect:
            linhaTemp.append(linhaArq[ii])
            ii = ii + 2
            linhaMaq.append(linhaArq[ii])
            ii = ii + 1

        lisTemProcJob.append(linhaTemp)
        lisMaqJob.append(linhaMaq)
        del(linhaTemp)
        del(linhaMaq)
        del(linhaArq)
        

    # -------------------------
    # fechando arquivo de dados 
    # -------------------------
    fl.close() 
    return nm,nj,numOpJob,lisTemProcJob,lisMaqJob





# ----------------------------------------------------------------------
#
# Funcao para abrir um arquivo do job shop e escrever dos dados neste arquivo
#
# ----------------------------------------------------------------------


def ImpDados(arquivo,no,listOper,nA,A):
    sys.stdout = open(arquivo,'w')

    print("\n Numero de operacoes: {:0d}\n".format(no))

   # imprimir a lista de operacoes
    
    print("\nLista de Operacoes\n")
    print("\nOper   Job   Maq   Temp Proc\n")
    for i in range(no):
        print(" {:3d}    {:2d}    {:2d}   {:2d}".format(i + 1,listOper[i][0],listOper[i][1],listOper[i][2]))

    # imprimir os pare de A
    print("\nNumero de pares em A  :  {:0d}\n".format(nA))
    for i in range(nA):
        print("{:2d}: ({:2d},{:2d})".format(i + 1,A[i][0],A[i][1]))

    sys.stdout.close()
    




# ----------------------------------------------------------------------
#
# Programa Principal
#
# ----------------------------------------------------------------------



if __name__ == "__main__":

    # definir o nome do arquivo dos dados de entrada
    arqLer = arquivoEntrada()

    # ler os dados do arquivo de entrada
    nm,nj,numOpJob,lisTemProcJob,lisMaqJob = LerDados(arqLer)

    # imprimir valores lidos
    print("")
    print("Numero de maquinas  :  {:0d}".format(nm))
    print("Numero de jobs      :  {:0d}".format(nj))
    # print("")
    i = 0
    while i < nj:
        print("\n")
        print("Job {:0d}".format(i + 1))
        ii = 0
        print("Numero total de operacoes {:0d} - ".format(numOpJob[i]))
        print("Temp de proc - Maq")
        while ii < numOpJob[i]:
            print("        {:0d}       {:0d}".format(lisTemProcJob[i][ii],lisMaqJob[i][ii]))
            ii = ii + 1
        i = i + 1

    # Calculo do numero de operacoes
    no = 0
    for i in range(nj):
        no = no + numOpJob[i]

    # criando uma lista vazia com do tamanho do numero de operacoes,
    # cada elemento da lista contem o job, a maquina e o tempo de processamento
    listOper = []
    for i in range(no):
        # cria a linha linha com zeros
        linhaListOper = []
        for j in range(3):
            linhaListOper.append(0)
        # colocar a linha na lista de operacoes
        listOper.append(linhaListOper)

    # colocar as informacoes na lista de operacoes
    i = 0           # para percorrer a lista de operacoes
    for ii in range(nj):
        for jj in range(numOpJob[ii]):
            j = 0       # para percorer a linha da lista de operacoes
            listOper[i][j] = ii + 1
            j = j + 1
            listOper[i][j] = lisMaqJob[ii][jj]
            j = j + 1
            listOper[i][j] = lisTemProcJob[ii][jj]
            i = i + 1

    # imprimir a lista de operacoes
    print("\nLista de Operacoes\n")
    print("\nOper   Job   Maq   Temp Proc\n")
    for i in range(no):
        print(" {:0d}   {:0d}   {:0d}  {:0d}".format(i + 1,listOper[i][0],listOper[i][1],listOper[i][2]))

    # numero de elementos de A
    nA = 0

    # criar os pares de operacoes A
    A = []
    for i in range(no - 1):
        if (listOper[i][0] == listOper[i + 1][0]):
            nA = nA + 1
            par = []
            for j in range(2):
                par.append(0)
            par[0] = i + 1
            par[1] = i + 2
            A.append(par)

    # imprimir os pare de A
    print("\nNumero de pares em A  :  {:0d}\n".format(nA))
    for i in range(nA):
        print("{:2d}: ({:2d},{:2d})".format(i + 1,A[i][0],A[i][1]))

    # define o nome do arquivo de saida
    arqImp = arquivoSaida()

    # imprime os dados no arquivo de saida
    ImpDados(arqImp,no,listOper,nA,A)
