extends OptionButton

@export var game_stats: GameStats

func _ready():
	for difficulty in GameStats.Difficulty.values():
		add_item(
			GameStats.difficulty_label(difficulty as GameStats.Difficulty)
		)

	selected = game_stats.difficulty
	item_selected.connect(func(index: int):
		if index as GameStats.Difficulty != game_stats.difficulty:
			SoundPlayer.play(SoundPlayer.UI_SELECT)

		game_stats.difficulty = index as GameStats.Difficulty
	)
