extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var health_bar = $CanvasLayer/healthContainer
@onready var ammo_bar = $CanvasLayer/AmmoContainer
@onready var medkit_count = $CanvasLayer/MedkitGUI

func _process(_delta: float) -> void:
	update_status()
	$Crosshair.global_position = get_global_mouse_position()
	

func update_status():
	pass


func _on_player_health_changed() -> void:
	health_bar.update_hearts()


func _on_player_ammo_changed() -> void:
	ammo_bar.update_bars()


func _on_player_medkits_changed() -> void:
	medkit_count.update()
