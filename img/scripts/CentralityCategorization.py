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


def get_label_name(cent_band):
    if cent_band == 'low':
        return 'baja'
    elif cent_band == 'medium':
        return 'media'
    else:
        return 'alta'


def plot(skill_evolution, skill):
    games_number = 250
    active_players = set()
    skill_values = []
    for player, skills in skill_evolution.items():
        if len(skills) >= games_number:
            active_players.add(player)
            skill_values.append(skills)

    for centrality in CENTRALITY_NAMES.keys():
        for summary_type in ['mean', 'median', 'last', 'max']:
            cents = pickle.load(open('data/categorization-groups/{}-{}-categorization-groups.pickle'.format(summary_type, centrality), 'rb'))

            fig, exp_skill_ax = plt.subplots()
            exp_skill_ax.set_xlim([1, games_number])
            if skill == 'ttt':
                exp_skill_ax.yaxis.set_major_locator(ticker.MultipleLocator(0.5))
            else:
                exp_skill_ax.yaxis.set_major_locator(ticker.MultipleLocator(1))
            exp_skill_ax.set_ylabel('Habilidad ({})'.format(get_axis_name(skill)))
            exp_skill_ax.set_xlabel('Partidas jugadas (experiencia)')

            for cent_band, player_set in [('low', cents['low']), ('medium', cents['medium']), ('high', cents['high'])]:
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
                exp_skill_ax.plot(game_numbers, mean, label="Centralidad {}".format(get_label_name(cent_band)),
                                  color=get_color(cent_band))
                exp_skill_ax.fill_between(game_numbers, mean - stde, mean + stde, alpha=0.2, color=get_color(cent_band))

            exp_skill_ax.legend(loc='lower right', fontsize='large')

            dir_name = get_dir_name(skill).format(summary_type)
            if not os.path.exists(dir_name):
                os.makedirs(dir_name)
            fig.savefig(get_file_name(skill).format(summary_type, centrality), bbox_inches="tight", pad_inches=0)
            plt.close(fig)


def get_dir_name(skill):
    if 'trueskill' == skill:
        return 'resultados/evolucion-ts/{}'
    elif 'ttt' == skill:
        return 'resultados/evolucion-ttt/no-filtered/{}'


def get_file_name(skill):
    if 'trueskill' == skill:
        return get_dir_name(skill) + '/evolucion-trueskill-{}.pdf'
    elif 'ttt' == skill:
        return get_dir_name(skill) + '/evolucion-ttt-{}.pdf'


def get_axis_name(skill):
    if 'trueskill' == skill:
        return 'TrueSkill'
    elif 'ttt' == skill:
        return 'TrueSkill Through Time'


def get_color(cent_band):
    if cent_band == 'low':
        return CB91_Blue
    elif cent_band == 'medium':
        return CB91_Amber
    elif cent_band == 'high':
        return CB91_Green


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

    skill_evolution = pickle.load(open('data/trueskill-experience-evolution-per-player-and-board.pickle', 'rb'))
    plot(skill_evolution, 'trueskill')

    skill_evolution = {}
    skill_windows_pp = pickle.load(open('data/ttt-experience-evolution-windows-per-player.pickle', 'rb'))
    for player, skills in skill_windows_pp.items():
        skill_evolution[player] = [skill_std_pair for window in skills for skill_std_pair in window]
    plot(skill_evolution, 'ttt')


if __name__ == '__main__':
    main()
