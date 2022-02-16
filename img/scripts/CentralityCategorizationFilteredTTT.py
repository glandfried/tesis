import math
import os
import pickle

import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np
import seaborn as sns
from scipy import stats

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


def plot_graphs(skill_evolution, ttt):
    games_number = 150
    for centrality in CENTRALITY_NAMES.keys():
        cents = pickle.load(open(
            'data/initial-ttt-filtered-no-med-categorization-groups/{}-ttt-{}-50-games-no-med-cent-categorization-groups.pickle'.format(
                centrality, ttt), 'rb'))

        fig, exp_skill_ax = plt.subplots()
        exp_skill_ax.set_xlim([1, games_number])
        exp_skill_ax.get_yaxis().set_major_formatter(ticker.FormatStrFormatter("%.2f"))
        exp_skill_ax.get_yaxis().set_minor_formatter(ticker.FormatStrFormatter("%.2f"))
        exp_skill_ax.set_ylabel('Habilidad ({})'.format('TrueSkill Through Time'))
        exp_skill_ax.set_xlabel('Partidas jugadas (experiencia)')

        for cent_band, player_set in [('low', cents['low']), ('high', cents['high'])]:
            mean = []
            stde = []
            game_numbers = []
            for game in range(1, games_number + 1):
                values = []
                for player in player_set:
                    player_skills = skill_evolution[player]
                    if len(player_skills) > game:
                        skill_value, _ = player_skills[game - 1]
                        if not math.isnan(skill_value):
                            values.append(skill_value)
                if values:
                    mean.append(np.mean(values))
                    stde.append(stats.sem(values, nan_policy='omit'))
                    game_numbers.append(game)

            mean = np.array(mean)
            stde = np.array(stde)
            fig.suptitle(CENTRALITY_NAMES[centrality], fontsize=18)
            exp_skill_ax.plot(game_numbers, mean,
                              label="Centralidad {} ({} jug.)".format(get_label_name(cent_band), len(player_set)),
                              color=get_color(cent_band))
            exp_skill_ax.fill_between(game_numbers, mean - stde, mean + stde, alpha=0.2, color=get_color(cent_band))

        exp_skill_ax.legend(loc='lower right', fontsize='large')
        dir_name = 'resultados/evolucion-ttt/filtered-no-med'
        if not os.path.exists(dir_name):
            os.makedirs(dir_name)
        fig.savefig(dir_name + '/evolucion-{}-{}.pdf'.format(get_file_name(ttt), centrality), bbox_inches="tight", pad_inches=0)
        plt.close(fig)


def get_label_name(cent_band):
    if cent_band == 'low':
        return 'baja'
    elif cent_band == 'med':
        return 'media'
    else:
        return 'alta'


def get_file_name(ttt):
    if 'med' == ttt:
        return 'ttt-inicial-med'
    elif 'low' == ttt:
        return 'ttt-inicial-low'
    elif 'high' == ttt:
        return 'ttt-inicial-high'


def get_color(cent_band):
    if cent_band == 'low':
        return CB91_Blue
    elif cent_band == 'high':
        return CB91_Amber


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

    skill_windows_pp = pickle.load(open('data/ttt-experience-evolution-windows-per-player.pickle', 'rb'))

    skill_evolution = {}
    for player, skills in skill_windows_pp.items():
        flattened = [skill_std_pair for window in skills for skill_std_pair in window]
        if len(flattened) > 0 and 6 <= flattened[0][0] <= 10:
            skill_evolution[player] = flattened
    plot_graphs(skill_evolution, "low")

    skill_evolution = {}
    for player, skills in skill_windows_pp.items():
        flattened = [skill_std_pair for window in skills for skill_std_pair in window]
        if len(flattened) > 0 and 11 <= flattened[0][0] <= 15:
            skill_evolution[player] = flattened
    plot_graphs(skill_evolution, "med")

    skill_evolution = {}
    for player, skills in skill_windows_pp.items():
        flattened = [skill_std_pair for window in skills for skill_std_pair in window]
        if len(flattened) > 0 and 16 <= flattened[0][0] <= 20:
            skill_evolution[player] = flattened
    plot_graphs(skill_evolution, "high")


if __name__ == '__main__':
    main()
