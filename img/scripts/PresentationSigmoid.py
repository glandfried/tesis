import math

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from matplotlib.ticker import FormatStrFormatter, NullLocator, MultipleLocator

CB91_Blue = '#2CBDFE'
CB91_Green = '#47DBCD'
CB91_Pink = '#F3A0F2'
CB91_Purple = '#9D2EC5'
CB91_Violet = '#661D98'
CB91_Amber = '#F5B14C'
CB91_Red = '#BC6566'
CB91_Brown = '#C2774F'


def sigmoid(x):
    a = []
    for item in x:
        a.append(1 / (1 + math.exp(-item)))
    return a


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
        "xtick.color": "dimgrey",
        "xtick.direction": "out",
        "xtick.top": False,
        "xtick.bottom": False,
        "ytick.color": "dimgrey",
        "ytick.direction": "out",
        "ytick.left": False,
        "ytick.right": False
    })

    x = np.arange(-6., 6., 0.2)
    sig = sigmoid(x)
    plt.margins(x=0)
    plt.plot(x, sig, color="black")
    ax = plt.gca()
    ax.xaxis.set_major_locator(NullLocator())
    ax.xaxis.set_minor_locator(NullLocator())
    ax.yaxis.set_major_locator(MultipleLocator(1.0))
    ax.yaxis.set_major_formatter(FormatStrFormatter("%.0f"))
    ax.yaxis.set_minor_locator(NullLocator())
    plt.axvline(-3, color="dimgrey", alpha=0.5, linestyle='--', linewidth=1)
    plt.axvline(0, color="dimgrey", alpha=0.5, linestyle='--', linewidth=1)
    plt.axvline(3, color="dimgrey", alpha=0.5, linestyle='--', linewidth=1)
    plt.axvspan(-6, -3, color=CB91_Blue, alpha=0.1)
    plt.axvspan(-3, 0, color=CB91_Red, alpha=0.1)
    plt.axvspan(0, 3, color=CB91_Amber, alpha=0.1)
    plt.axvspan(3, 6, color=CB91_Pink, alpha=0.1)
    plt.text(-4.5, .6, "0", color=CB91_Blue, fontsize='xx-large', weight='bold', ha='center')
    plt.text(-1.5, .6, "1", color=CB91_Red, fontsize='xx-large', weight='bold', ha='center')
    plt.text(1.5, .6, "2", color=CB91_Amber, fontsize='xx-large', weight='bold', ha='center')
    plt.text(4.5, .6, "3", color=CB91_Pink, fontsize='xx-large', weight='bold', ha='center')
    plt.savefig("presentation-sigmoid.pdf", bbox_inches="tight", pad_inches=0)
