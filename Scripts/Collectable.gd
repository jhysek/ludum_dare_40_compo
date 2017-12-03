extends Area2D

func _on_item_body_enter( body ):
	if body.is_in_group("Player"):
		body.itemCollected()
		queue_free()