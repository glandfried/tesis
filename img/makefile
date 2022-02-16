all: datos figuras trueskill


datos:
	wget -O data.zip "https://github.com/glandfried/centrality-ogs-dataset/releases/download/tesis_cairo_data_img/data.zip"
	unzip -o data.zip
	rm -rf __MACOSX
	rm data.zip


figuras:
	python3 scripts/BasicStructuralInfo.py
	python3 scripts/CentralitiesHistograms.py
	python3 scripts/CentralityCategorization.py
	python3 scripts/CentralityCategorizationFilteredTTT.py
	python3 scripts/CentralityCategorizationInitialTTT.py
	python3 scripts/DuncanWattsMetrics.py
	python3 scripts/ExperienceVsSkill.py
	python3 scripts/Fig4DW.py
	python3 scripts/InitialTTTHistogram.py
	python3 scripts/NumberOfGames.py
	python3 scripts/ExampleSigmoid.py
	python3 scripts/PresentationDuncanWattsMetrics.py
	python3 scripts/PresentationSigmoid.py


trueskill:
	cd trueskill && $(MAKE)


clean:
	find . -name "*.pdf" -type f -delete
