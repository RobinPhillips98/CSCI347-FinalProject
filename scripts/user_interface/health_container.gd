extends HBoxContainer

@onready var health_gui = preload("res://scenes/user_interface/health_gui.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	for i in range(player.max_health):
		var health_unit = health_gui.instantiate()
		add_child(health_unit)

func update_hearts():
	var units = get_children()

	for i in range(player.health):
		units[i].update(false)
		
	for i in range(player.health, units.size()):
		units[i].update(true)
