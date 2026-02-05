class_name STARS extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer


func showStars(value):
	anim.play("star"+value);
