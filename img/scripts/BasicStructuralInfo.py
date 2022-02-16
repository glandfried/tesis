import os

import matplotlib.pyplot as plt
import networkx as nx
import seaborn as sns

CB91_Blue = '#2CBDFE'
CB91_Green = '#47DBCD'
CB91_Pink = '#F3A0F2'
CB91_Purple = '#9D2EC5'
CB91_Violet = '#661D98'
CB91_Amber = '#F5B14C'


def parse_date(unparsed_date):
    year = unparsed_date[:4]
    month = unparsed_date[4:6]
    day = unparsed_date[-2:]
    return '{}/{}/{}'.format(day, month, year)


def main():
    sns.set(rc={
        'figure.figsize': (6, 4),
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
        "xtick.labelsize": 16,
        "ytick.labelsize": 16,
        "axes.labelsize": 16,
        "xtick.top": False,
        "ytick.color": "dimgrey",
        "ytick.direction": "out",
        "ytick.left": True,
        "ytick.right": False
    })

    files_dir = os.fsencode('data/structural-info')
    listdir_ = os.listdir(files_dir)
    for file_name in listdir_:
        file_path = os.path.join(files_dir, file_name)
        if os.path.isfile(file_path) and os.fsdecode(file_name).endswith('playersonly.graphml'):
            filename_suffix = '-'.join(os.fsdecode(file_name).split('-')[:2])

            g = nx.read_graphml(os.fsdecode(file_path))
            if nx.is_directed(g):
                g = g.to_undirected()

            degrees = []
            for node in g.nodes:
                weighted_degree = 0
                for edge in g.edges(node):
                    weighted_degree += g[edge[0]][edge[1]]['weight']
                    degrees.append(weighted_degree)

            lower_bound = 0
            upper_bound = 80
            bin_size = 5
            plt.hist(degrees, bins=range(lower_bound, upper_bound, bin_size), color=CB91_Blue)
            plt.xlabel('Partidas jugadas')
            plt.ylabel('Número de jugadores')
            dir_name = 'resultados/grado'
            if not os.path.exists(dir_name):
                os.makedirs(dir_name)
            plt.savefig(dir_name + '/hist-cant-partidas-por-jugador-{}.pdf'.format(filename_suffix),
                        bbox_inches="tight", pad_inches=0)
            plt.clf()


if __name__ == '__main__':
    main()
