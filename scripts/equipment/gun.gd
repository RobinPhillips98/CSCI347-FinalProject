extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var shooting_point = %ShootingPoint

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())	
	
func shoot():
	if player.ammo <= 0:
		return
	player.ammo -= 1
	
	const BULLET = preload("res://scenes/equipment/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = shooting_point.global_position
	new_bullet.global_rotation = shooting_point.global_rotation
	shooting_point.add_child(new_bullet)
