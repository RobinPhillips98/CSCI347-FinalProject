extends Panel

@onready var sprite = $Sprite2D

func update(lost: bool):
	if lost:
		sprite.frame = 0
	else:
		sprite.frame = 3
