extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("gain_medkit") and body.medkits < body.max_medkits:
		body.gain_medkit()
		queue_free()
