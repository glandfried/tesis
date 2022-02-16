import os
import pickle

import matplotlib.pyplot as plt
import seaborn as sns

CB91_Blue = '#2CBDFE'
CB91_Green = '#47DBCD'
CB91_Pink = '#F3A0F2'
CB91_Purple = '#9D2EC5'
CB91_Violet = '#661D98'
CB91_Amber = '#F5B14C'


def get_color(dirname):
    if dirname == 'oneweek':
        return CB91_Amber
    elif dirname == 'overlapping':
        return CB91_Blue
    elif dirname == 'onemonth':
        return CB91_Purple
    else:
        return None


def get_label(dirname):
    if dirname == 'oneweek':
        return 'Una semana'
    elif dirname == 'overlapping':
        return 'Dos semanas'
    elif dirname == 'onemonth':
        return 'Un mes'
    else:
        return None


def plot_all_plots(previously_calculated_values, plots, color, label):
    (meanVerticesPlot, fractionSizesPlot, meanShortestPathsPlot, clusteringCoefficientsPlot) = plots
    window_dates = previously_calculated_values['windowDates']
    mean_vertices = previously_calculated_values['meanVertices']
    fraction_sizes = previously_calculated_values['fracSizes']
    mean_shortest_paths = previously_calculated_values['meanShortestPaths']
    clustering_coefficients = previously_calculated_values['clusteringCoefficients']

    meanVerticesPlot.set_title('Grado\nMedio', x=-0.1, y=0.28, fontsize=10, loc='right')
    meanVerticesPlot.plot_date(window_dates, mean_vertices, label=label, color=color, fmt='-', linewidth=0.5)
    fractionSizesPlot.set_title('Proporción\nComponente Conexa', x=-0.1, y=0.28, fontsize=10, loc='right')
    fractionSizesPlot.plot_date(window_dates, fraction_sizes, label=label, color=color, fmt='-', linewidth=0.5)
    meanShortestPathsPlot.set_title('Largo Promedio\nCaminos Mínimos', x=-0.1, y=0.28, fontsize=10, loc='right')
    meanShortestPathsPlot.plot_date(window_dates, mean_shortest_paths, label=label, color=color, fmt='-', linewidth=0.5)
    clusteringCoefficientsPlot.set_title('Coeficiente de\nClustering', x=-0.1, y=0.28, fontsize=10, loc='right')
    clusteringCoefficientsPlot.plot_date(window_dates, clustering_coefficients, label=label, color=color, fmt='-',
                                         linewidth=0.5)


def main():
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
        "xtick.bottom": False,
        "xtick.color": "dimgrey",
        "xtick.direction": "out",
        "xtick.top": False,
        "ytick.color": "dimgrey",
        "ytick.direction": "out",
        "ytick.left": True,
        "ytick.right": False,
        'legend.title_fontsize': 'x-small',
        'legend.fontsize': 'x-small'
    })

    fig, plots = plt.subplots(4, sharex='all')
    for dirname in ['oneweek', 'overlapping', 'onemonth']:
        previously_calculated_values = pickle.load(
            open('data/{}-duncan-watts-values-updated.pickle'.format(dirname), 'rb'))
        plot_all_plots(previously_calculated_values, plots, get_color(dirname), get_label(dirname))
    handles, labels = plots[0].get_legend_handles_labels()
    fig.legend(handles, labels, bbox_to_anchor=(0.5, 1), loc='center', title='Tamaño de la ventana', ncol=3)
    dir_name = 'resultados/dw'
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)
    plt.savefig(dir_name + '/duncan-watts-metrics.pdf', bbox_inches="tight", pad_inches=0)


if __name__ == '__main__':
    main()
