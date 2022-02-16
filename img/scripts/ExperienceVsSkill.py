# coding=utf-8

import math
import os
import pickle

import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy
import seaborn as sns
from cycler import cycler
from scipy import stats

CB91_Blue = '#2CBDFE'
CB91_Purple = '#9D2EC5'
CB91_Green = '#47DBCD'
CB91_Pink = '#F3A0F2'
CB91_Amber = '#F5B14C'
CB91_Red = '#BC6566'
CB91_Brown = '#C2774F'

ALL_COLOURS = [CB91_Brown, CB91_Purple, CB91_Green, CB91_Pink, CB91_Amber, CB91_Red, CB91_Blue]


def plot_experience_vs_skill_mean_per_game(skill_evolution, skill_type):
    skill_values = list(skill_evolution.values())
    games_number = 150
    skills_filtered = list(filter(lambda skill: len(skill) >= games_number, skill_values))
    mean = []
    variance = []
    population = []
    for game in range(games_number):
        values = []
        for player_skills in skills_filtered:
            if len(player_skills) > max(10, game):
                skill_value, _ = player_skills[game]
                if not math.isnan(skill_value):
                    values.append(skill_value)
        if values:
            mean.append(numpy.mean(values))
            variance.append(stats.sem(values, nan_policy='omit'))
            population.append(len(values))
        else:
            mean.append(0)
            variance.append(0)
            population.append(0)
    mean = numpy.array(mean)
    variance = numpy.array(variance)
    p = plt.plot(range(1, len(mean) + 1), mean, color=CB91_Blue)
    plt.fill_between(range(1, len(mean) + 1), mean - variance, mean + variance, color=p[-1].get_color(), alpha=0.2)

    plt.yscale('log')
    plt.xscale('log')
    plt.ylabel('Habilidad ({})'.format(
        'TrueSkill' if skill_type == 'trueskill' else ('TTT' if skill_type == 'ttt' else 'Glicko')))
    plt.xlabel('Partidas jugadas (experiencia)')
    ax = plt.gca()
    ax.get_yaxis().set_minor_formatter(ticker.ScalarFormatter())

    dir_name = 'resultados/curvas-aprendizaje'
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)
    plt.savefig(dir_name + '/hist-evolucion-{}.pdf'.format(skill_type), bbox_inches="tight", pad_inches=0)
    plt.clf()

    ############################################################

    exponents = [3, 4, 5, 6, 7, 8, 9, 10]
    for exp_idx in range(len(exponents) - 1):
        games_number = 2 ** exponents[exp_idx]
        skills_filtered = list(
            filter(lambda skill: 2 ** exponents[exp_idx] <= len(skill) < 2 ** exponents[exp_idx + 1], skill_values))

        mean = []
        variance = []
        population = []
        for game in range(games_number):
            values = []
            for player_skills in skills_filtered:
                if len(player_skills) > game:
                    skill_value, _ = player_skills[game]
                    if not math.isnan(skill_value):
                        values.append(skill_value)
            if values:
                mean.append(numpy.mean(values))
                variance.append(stats.sem(values, nan_policy='omit'))
                population.append(len(values))
            else:
                mean.append(0)
                variance.append(0)
                population.append(0)

        mean = numpy.array(mean)
        variance = numpy.array(variance)
        p = plt.plot(range(1, len(mean) + 1), mean,
                     label='Entre {} y {}'.format(2 ** exponents[exp_idx], 2 ** exponents[exp_idx + 1]))
        plt.fill_between(range(1, len(mean) + 1), mean - variance, mean + variance, color=p[-1].get_color(), alpha=0.2)
    plt.legend(bbox_to_anchor=(0.5, 1.1), loc='center', ncol=4, title='Partidas jugadas')
    plt.yscale('log')
    plt.xscale('log')
    plt.ylabel('Habilidad ({})'.format(
        'TrueSkill' if skill_type == 'trueskill' else ('TTT' if skill_type == 'ttt' else 'Glicko')))
    plt.xlabel('Partidas jugadas (experiencia)')
    plt.gca().get_yaxis().set_major_formatter(ticker.FormatStrFormatter("%.0f"))
    plt.gca().get_yaxis().set_minor_formatter(ticker.FormatStrFormatter("%.0f"))
    plt.savefig("resultados/curvas-aprendizaje/hist-evolucion-{}-poblaciones.pdf".format(skill_type), bbox_inches="tight", pad_inches=0)
    plt.clf()


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
        "xtick.major.size": 6,
        "xtick.minor.size": 6,
        "xtick.top": False,
        "ytick.color": "dimgrey",
        "ytick.direction": "out",
        "ytick.left": True,
        "ytick.right": False,
        'legend.fontsize': 'xx-small',
        'legend.title_fontsize': 'xx-small'
    })
    plt.rc('axes', prop_cycle=cycler(color=ALL_COLOURS))

    skill_types = ['trueskill', 'glicko']
    for skill_type in skill_types:
        exp_evol_per_player = pickle.load(open('data/{}-experience-evolution-per-player-and-board.pickle'.format(skill_type), 'rb'))
        plot_experience_vs_skill_mean_per_game(exp_evol_per_player, skill_type)


if __name__ == '__main__':
    main()
