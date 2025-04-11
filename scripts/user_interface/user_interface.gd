extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var health_bar = $CanvasLayer/healthContainer

func _process(_delta: float) -> void:
	update_status()
	$CanvasLayer/Crosshair.position = get_global_mouse_position()
	

func update_status():
	pass


func _on_player_health_changed() -> void:
	health_bar.update_hearts()
