extends Node

@onready var loading: CanvasLayer = $loading

func _ready() -> void:
	loading.visible = true

func _on_touch_screen_button_pressed() -> void:
	AudioPlayer._play_fx_btn7()
	await get_tree().create_timer(0.2).timeout
	loading.transition()
	await loading.on_transition_finished
	get_tree().change_scene_to_file("res://res/scene/menu/menu_lvl.tscn")
