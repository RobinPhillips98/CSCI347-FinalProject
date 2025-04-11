extends Node2D

@onready var progress_bar = $CanvasLayer/TopBar/ProgressBar
@onready var progress_label = $CanvasLayer/TopBar/ProgressLabel
@onready var name_label = $CanvasLayer/TopBar/Name

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	progress_bar.max_value = Global.WIN_ENERGY
	progress_bar.value = Global.energy
	progress_label.text = str(Global.energy) + "/" + str(Global.WIN_ENERGY)
	name_label.text = Global.colony_name

func _on_expedition_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/user_interface/expedition_menu.tscn")
