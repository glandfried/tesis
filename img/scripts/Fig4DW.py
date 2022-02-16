import os
import pickle

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from matplotlib.ticker import ScalarFormatter, FormatStrFormatter
from scipy import stats

CB91_Blue = '#2CBDFE'
CB91_Green = '#47DBCD'
CB91_Pink = '#F3A0F2'
CB91_Purple = '#9D2EC5'
CB91_Violet = '#661D98'
CB91_Amber = '#F5B14C'


if __name__ == '__main__':
    sns.set(rc={
        "axes.axisbelow": False,
        "axes.edgecolor": "dimgrey",
        "axes.facecolor": "None",
        "axes.grid": False,
        "axes.labelcolor": "dimgrey",
        "axes.spines.right": False,
        "axes.spines.top": False,
        "figure.facecolor": "white",
        "lines.solid_capstyle": "round",
        "patch.force_edgecolor": False,
        "text.color": "dimgrey",
        "xtick.bottom": True,
        "xtick.color": "dimgrey",
        "xtick.direction": "out",
        "xtick.major.size": 6,
        "xtick.minor.size": 6,
        "xtick.top": False,
        "ytick.color": "dimgrey",
        "ytick.direction": "out",
        "ytick.left": True,
        "ytick.right": False
    })

    dir_name = 'resultados/dw'
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)

    fig = plt.figure(figsize=(4, 2))
    path = 'data/fig4dw/degree-dist-20060516-20060530.pickle'
    degs = pickle.load(open(path, "rb"))
    total = len(degs)
    bins = np.arange(0, 80, 10)
    # Probabilidad Y de tener grado X
    p, x = np.histogram(degs, bins=bins)
    prob = list(map(lambda freq: freq / total, p))
    ax = plt.gca()
    plt.xlabel('Probabilidad')
    plt.ylabel('Grado')
    ax.plot(x[:-1], prob, marker='o', color=CB91_Blue)
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.xaxis.set_major_formatter(ScalarFormatter())
    ax.xaxis.set_major_formatter(FormatStrFormatter("%.0f"))
    ax.xaxis.set_minor_formatter(ScalarFormatter())
    plt.savefig(dir_name + '/fig4dw-1.pdf', bbox_inches="tight", pad_inches=0.02)
    plt.clf()

    fig = plt.figure(figsize=(4, 2))
    path = 'data/fig4dw/degree-dist-20130122-20130205.pickle'
    degs = pickle.load(open(path, "rb"))
    total = len(degs)
    bins = np.arange(0, 80, 10)
    # Probabilidad Y de tener grado X
    p, x = np.histogram(degs, bins=bins)
    prob = list(map(lambda freq: freq / total, p))
    plt.xlabel('Probabilidad')
    plt.ylabel('Grado')
    ax = plt.gca()
    ax.plot(x[:-1], prob, marker='o', color=CB91_Blue)
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.xaxis.set_major_formatter(ScalarFormatter())
    ax.xaxis.set_major_formatter(FormatStrFormatter("%.0f"))
    ax.xaxis.set_minor_formatter(ScalarFormatter())
    plt.savefig(dir_name + '/fig4dw-2.pdf', bbox_inches="tight", pad_inches=0.02)
    plt.clf()

    fig = plt.figure(figsize=(8, 2))
    ks_values = []
    path = 'data/fig4dw/degree-dist-20060516-20060530.pickle'
    degs1 = pickle.load(open(path, "rb"))
    files_dir = 'data/fig4dw'
    listdir_ = sorted(os.listdir(files_dir))
    for file_name in listdir_:
        file_path = os.path.join(files_dir, file_name)
        if os.path.isfile(file_path) and os.fsdecode(file_name).endswith('.pickle'):
            degs2 = pickle.load(open(file_path, "rb"))
            ks_values.append(stats.ks_2samp(degs1, degs2)[0])

    ax = plt.gca()
    ax.plot(ks_values, color=CB91_Blue)
    ax.set_ylim(0, 0.5)
    plt.savefig(dir_name + '/fig4dw-3.pdf', bbox_inches="tight", pad_inches=0)
    plt.clf()
