extends StaticBody2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name != "Player" and body.name != "layer2"):
		#print(body.name);
		body.disappear();
