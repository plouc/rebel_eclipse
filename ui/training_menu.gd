extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

@export var selected_item_index: int = 0:
	set(value):
		if value == selected_item_index:
			return

		SoundPlayer.play(SoundPlayer.UI_ACTION)
		selected_item_index = value
		_adjust_selected_item()

var _items: Array[TrainingMenuEnemyItem]

func _input(event: InputEvent):
	if event.is_action_pressed("ui_right"):
		if selected_item_index < _items.size() - 1:
			selected_item_index += 1
	elif event.is_action_pressed("ui_left"):
		if selected_item_index > 0:
			selected_item_index -= 1
	
	elif event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _ready():
	for item_index in range(grid_container.get_child_count()):
		var item: TrainingMenuEnemyItem = grid_container.get_child(item_index) as TrainingMenuEnemyItem
		_items.append(item)

	_adjust_selected_item()

func _adjust_selected_item() -> void:
	for item_index in range(_items.size()):
		var item: TrainingMenuEnemyItem = _items[item_index]
		item.is_active = item_index == selected_item_index
