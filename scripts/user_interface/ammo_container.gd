extends HBoxContainer

@onready var ammo_gui = preload("res://scenes/user_interface/ammo_gui.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	for i in range(player.max_ammo):
		var ammo_unit = ammo_gui.instantiate()
		add_child(ammo_unit)

func update_bars():
	var units = get_children()

	for i in range(player.ammo):
		units[i].update(false)
		
	for i in range(player.ammo, units.size()):
		units[i].update(true)
