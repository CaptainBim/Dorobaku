extends Node

@onready var loading: CanvasLayer = $loading
@onready var anim: VBoxContainer = $Panel/VBoxContainer

func _ready() -> void:
	loading.visible = true
	anim.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(anim, "modulate:a", 1.0, 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_back_pressed() -> void:
	AudioPlayer._play_fx_btn7()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://res/scene/menu/menu_home.tscn")
