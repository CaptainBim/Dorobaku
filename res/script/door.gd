class_name Door extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

func open_door() -> void:
	animation_player.play( "door_open" )
	pass

func close_door() -> void:
	animation_player.play( "door_close" )
	pass
