import os
import pickle
from bisect import bisect

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

CENTRALITY_NAMES = {'information-centrality': 'Information Centrality',
                    'degree-centrality': 'Degree Centrality',
                    'load-centrality': 'Load Centrality',
                    'eigenvector-centrality': 'Eigenvector Centrality',
                    'closeness-centrality-inverse-distance': 'Closeness',
                    'betweenness-centrality': 'Betweenness',
                    'current-flow-betweenness-centrality': 'Current Flow Betweenness',
                    'communicability-betweenness-centrality': 'Communicability Betweenness',
                    'harmonic-centrality-inverse-weight': 'Harmonic Centrality'}

CB91_Blue = '#2CBDFE'
CB91_Green = '#47DBCD'
CB91_Pink = '#F3A0F2'
CB91_Purple = '#9D2EC5'
CB91_Violet = '#661D98'
CB91_Amber = '#F5B14C'


def get_number_of_windows_until_50_games(player_windows):
    user_games = 0
    for window_idx, window in enumerate(player_windows):
        user_games += len(window)
        if user_games >= 50:
            return True, window_idx + 1
    return False, None


def played_x_games(x, windows):
    return sum([len(window) for window in windows]) >= x


def plot_centralities_hist(centralities_dict):
    windows_per_player = pickle.load(open('data/ttt-experience-evolution-windows-per-player.pickle', 'rb'))
    centrality_groups = {}
    for centrality in CENTRALITY_NAMES.keys():
        cent_means = []
        for user, user_cent_values in centralities_dict[centrality].items():
            if played_x_games(150, windows_per_player[user]):
                played_50_games, windows_until_50_games = get_number_of_windows_until_50_games(windows_per_player[user])
                if played_50_games:
                    mean = np.nanmean(user_cent_values[:windows_until_50_games])
                    if mean > 0:
                        cent_means.append(mean)

        bins = None
        if centrality == 'harmonic-centrality-inverse-weight':
            bins = np.arange(0, 800, 4)
        else:
            bins = np.arange(0, max(cent_means), 0.005)

        centrality_groups[centrality] = [(np.percentile(cent_means, 33)), (np.percentile(cent_means, 67)),
                                         max(cent_means)]

        hist, np_bins = np.histogram(cent_means, bins=bins)
        transformed_bins = np_bins
        if centrality not in ['closeness-centrality-inverse-distance', 'harmonic-centrality-inverse-weight']:
            transformed_bins = np.logspace(np.log10(0.0001), np.log10(np_bins[-1]), len(np_bins))
            plt.xscale('log')
        plt.suptitle(CENTRALITY_NAMES[centrality])
        _, bins, patches = plt.hist(cent_means, bins=transformed_bins, color=CB91_Blue, rwidth=0.8, alpha=0.9)

        dir_name = 'resultados/centralidades/presentation'
        if not os.path.exists(dir_name):
            os.makedirs(dir_name)
        plt.savefig(dir_name + '/{}-150-partidas-hist.pdf'.format(centrality), bbox_inches="tight", pad_inches=0)

        for percentile, colour in zip(centrality_groups[centrality][:-1], [CB91_Amber, CB91_Green]):
            for patch in patches[bisect(bins, percentile):]:
                patch.set_fc(colour)
        plt.savefig(dir_name + '/{}-150-partidas-hist-coloured.pdf'.format(centrality), bbox_inches="tight", pad_inches=0)
        plt.clf()


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
        "ytick.left": False,
        "ytick.right": False
    })
    sns.set_context("talk")

    centrality_per_player = pickle.load(open('data/centrality-per-player.pickle', 'rb'))
    plot_centralities_hist(centrality_per_player)


if __name__ == '__main__':
    main()
