extends CharacterBody2D



func _on_aksi_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		owner.get_parent().isFailed = true;
		owner.get_parent().selesai();
