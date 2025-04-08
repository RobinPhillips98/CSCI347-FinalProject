extends Control

@onready var destinations_menu = $DestinationsMenu
var selected_level: PackedScene
var destination: String = "Select a destination..."
@export var debug_level_select: bool

func _process(delta: float) -> void:
	update_destination()

func _on_destinations_toggled(toggled_on: bool) -> void:
	if toggled_on:
		destinations_menu.visible = true
		get_tree().call_group("destination_menu", "set_disabled", false)
	else:
		destinations_menu.visible = false
		get_tree().call_group("destination_menu", "set_disabled", true)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/colony/colony.tscn")

func update_destination() -> void:
	$DestinationLabel.text = "Destination: " + destination


func _destination_one_selected() -> void:
	if false or debug_level_select:
		destination = "Destination One"
	else:
		return
