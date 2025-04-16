extends Panel

@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")

func update():
	sprite.frame = player.medkits
