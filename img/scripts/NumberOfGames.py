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
		"ytick.right": False
	})

	games = pickle.load(open('data/trueskill-experience-evolution-per-player-and-board.pickle', 'rb')).values()
	number_of_games = list(map(len, games))

	lower_bound = 10
	upper_bound = 200
	bin_size = 5
	plt.hist(number_of_games, bins=range(lower_bound, upper_bound, bin_size), color=CB91_Blue)
	plt.xlabel('Partidas jugadas')
	plt.ylabel('Número de jugadores')
	dir_name = 'resultados/general'
	if not os.path.exists(dir_name):
		os.makedirs(dir_name)
	plt.savefig(dir_name + '/number-of-games-hist.pdf', bbox_inches="tight", pad_inches=0)


if __name__ == '__main__':
	main()
