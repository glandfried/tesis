#import os
#import math
import numpy as np
from numpy.random import normal as rnorm
from matplotlib import pyplot as plt 

def simple_gamble(size):
    r = np.random.random()
    if r <= 0.5:
        res = 1.5*size
    else:
        res = 0.6*size
    return res

def walk_simple_gamble(iteratons):
    res = [1]
    for i in range(iteratons):
        res.append(simple_gamble(res[-1]))
    return res
    
def incest_rule(communities_size,exogamy=0.05):
    res = []
    migration_per_community = exogamy*sum(communities_size)/len(communities_size)
    for c in range(len(communities_size)):
        res.append(communities_size[c]*(1-exogamy) + migration_per_community)
    return res 

def init_communities(n_communities):
    communities = []
    for i in range(n_communities):
        communities.append(1.0)
    return communities

def walk_incest(iteratons,n_communities,incest=1):     
    communities = init_communities(n_communities)
    history = []
    history.append(communities)
    for i in range(iteratons):
        history.append(list(map(lambda x: simple_gamble(x), incest_rule(history[-1],incest) ) ))
    return history


def incest_rule_free_rider(communities_size,free_rider,exogamy=0.05):
    res = []
    n_free_riders = len(free_rider)
    size_not_free_rider = sum(map(lambda i: 0 if i in free_rider else communities_size[i], range(len(communities_size))))
    migration_per_community = exogamy*size_not_free_rider/len(communities_size)
    for c in range(len(communities_size)):#c=0
        res.append( communities_size[c]*(1-exogamy*int(not c in free_rider)) + migration_per_community)
    return res

def walk_incest_free_rider(iteratons,n_communities,n_free_riders=1,incest=1):
    communities = init_communities(n_communities)
    free_riders = list(range(n_free_riders))
    history = []
    history.append(communities)
    for i in range(iteratons):
        history.append(list(map(lambda x: simple_gamble(x), incest_rule_free_rider(history[-1],free_riders,incest) ) ))
    return history
 
