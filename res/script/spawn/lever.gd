class_name Lever extends StaticBody2D

signal aksiLever

@onready var animation_player: AnimationPlayer = $AnimationPlayer
enum LeverState { OFF, ON }
var condition: LeverState = LeverState.OFF
			

func turn_on_lever() -> void:
	animation_player.play( "turn_on" )

func turn_off_lever() -> void:
	animation_player.play( "turn_off" )

func player_interact() -> void:
	if condition == LeverState.ON :
		aksiLever.emit("off")
		print("matikan")
		turn_off_lever()
		condition = LeverState.OFF
	else :
		aksiLever.emit("on")
		print("nyalakan")
		turn_on_lever()
		condition = LeverState.ON


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player :
		PlayerManager.interact_pressed.connect( player_interact )
		print("bisa Aksi")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player :
		PlayerManager.interact_pressed.disconnect( player_interact )
		print("keluar area aksi")
