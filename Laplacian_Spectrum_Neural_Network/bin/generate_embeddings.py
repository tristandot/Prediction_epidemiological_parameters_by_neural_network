#!/usr/bin/env python3

import matplotlib.pyplot as plt
from time import time

from gem.utils      import graph_util, plot_util
from gem.evaluation import visualize_embedding as viz
from gem.evaluation import evaluate_graph_reconstruction as gr

from gem.embedding.gf       import GraphFactorization
from gem.embedding.hope     import HOPE
from gem.embedding.lap      import LaplacianEigenmaps
from gem.embedding.lle      import LocallyLinearEmbedding
from gem.embedding.node2vec import node2vec
from gem.embedding.sdne     import SDNE

import io
import sys
import pandas as pd
import argparse

from ete3 import Tree
from collections import Counter


def name_tree(tree):
    """
    Names all the tree nodes that are not named, with unique names.
    :param tree: ete3.Tree, the tree to be named
    :return: void, modifies the original tree
    """
    existing_names = Counter((_.name for _ in tree.traverse() if _.name))
    i = 0
    for node in tree.traverse('levelorder'):
            node.name = i
            i+=1


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Generates an experimental design', prefix_chars='@')
    parser.add_argument('@tree', type=str, help='name of the tree on which we work')
    parser.add_argument('@id', type=int, help='id of the tree on which we work')
    parser.add_argument('@step', type=int, help='number of trees in a package of trees')
    args = parser.parse_args()

    tree = str(args.tree)

    id = int(args.id)

    step = int(args.step)


    file = open(tree, mode = "r")

    forest = file.read().replace("\n","")

    trees = forest.split(";")

    for i in range(0,step):

        if len(trees[i]) > 0:
            tree = Tree(trees[i] + ";", format = 1)
            name_tree(tree)

            new_format_tree = tree.write(format = 1)

            from Bio import Phylo
            import networkx, pylab
            tree = Phylo.read(io.StringIO(new_format_tree), 'newick')
            net = Phylo.to_networkx(tree)

            net = net.to_directed()


            models = []
            # You can comment out the methods you don't want to run
            #models.append(GraphFactorization(d=30, max_iter=100000, eta=1*10**-4, regu=1.0))
            #models.append(HOPE(d=2, beta=0.01))
            models.append(LaplacianEigenmaps(d=1))
            #models.append(LocallyLinearEmbedding(d=2))
            #models.append(node2vec(d=2, max_iter=1, walk_len=80, num_walks=10, con_size=10, ret_p=1, inout_p=1))
            #models.append(SDNE(d=2, beta=5, alpha=1e-5, nu1=1e-6, nu2=1e-6, K=3,n_units=[50, 15,], rho=0.3, n_iter=50, xeta=0.01,n_batch=500,
            #                modelfile=['./intermediate/enc_model.json', './intermediate/dec_model.json'],
            #               weightfile=['./intermediate/enc_weights.hdf5', './intermediate/dec_weights.hdf5']))

            for embedding in models:
                Y, t = embedding.learn_embedding(graph=net, edge_f=None, is_weighted=True, no_python=True)


            line = pd.DataFrame(Y, columns = [id + i])

            if i == 0:
                result = line
            else:
                result = pd.concat([result, line], axis = 1)


    sys.stdout.write(result.to_csv(sep='\t', index=False, index_label='Index'))
