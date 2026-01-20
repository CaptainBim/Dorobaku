class_name Buku extends StaticBody2D

signal aksiBuku

@export_multiline var hint_text : String = "Insert\nHint\nHere"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
enum BookState { OFF, ON }
var condition: BookState = BookState.OFF

func _ready() -> void:
	$Label.visible = false
	$Label.text = hint_text

func turn_on_lever() -> void:
	animation_player.play( "on" )

func turn_off_lever() -> void:
	animation_player.play( "off" )

func player_interact() -> void:
	if condition == BookState.ON :
		aksiBuku.emit("off")
		print("matikan")
		turn_off_lever()
		condition = BookState.OFF
	else :
		aksiBuku.emit("on")
		print("nyalakan")
		turn_on_lever()
		condition = BookState.ON
		await get_tree().create_timer(5.0).timeout
		aksiBuku.emit("off")
		print("matikan")
		turn_off_lever()
		condition = BookState.OFF


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player :
		PlayerManager.interact_pressed.connect( player_interact )
		print("bisa Aksi")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player :
		PlayerManager.interact_pressed.disconnect( player_interact )
		print("keluar area aksi")
