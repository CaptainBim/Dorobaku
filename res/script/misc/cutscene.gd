extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim2: AnimationPlayer = $AnimationPlayer2
@onready var anim3: AnimationPlayer = $AnimationPlayer3

@onready var frame_1: Sprite2D = $CenterContainer/VBoxContainer/Panel/frame1
@onready var frame_2: Sprite2D = $CenterContainer/VBoxContainer/Panel3/frame2
@onready var frame_3: Sprite2D = $CenterContainer/BoxContainer/Panel2/frame3
@onready var portal: Sprite2D = $CenterContainer/VBoxContainer/Panel3/frame2/portal
@onready var no_book: Sprite2D = $CenterContainer/VBoxContainer/Panel/frame1/noBook
@onready var buku: Sprite2D = $CenterContainer/VBoxContainer/Panel/buku
@onready var chara: Sprite2D = $CenterContainer/BoxContainer/Panel2/frame3/chara
@onready var play: TouchScreenButton = $CanvasLayer/play
@onready var loading: CanvasLayer = $loading

func _ready() -> void:
	$loading.visible = true
	AudioPlayer.stop()
	AudioPlayer._play_story_music()
	frame_1.modulate.a = 0.0
	frame_2.modulate.a = 0.0
	frame_3.modulate.a = 0.0
	play.modulate.a = 0.0
	no_book.modulate.a = 0.0
	portal.scale = Vector2(0, 0)
	
	var bukuPos = buku.position
	buku.position = bukuPos + Vector2(0, 400)
	var charaPos = chara.position
	chara.position = charaPos + Vector2(0, 400)
	
	var tween = create_tween()
	anim.play("frame1")
	tween.tween_property(frame_1, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(1.8).timeout
	tween = create_tween().tween_property(no_book, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween = create_tween().tween_property(buku, "position", bukuPos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(1.7).timeout
	
	tween = create_tween().tween_property(frame_2, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	anim2.play("frame2")
	await get_tree().create_timer(2.45).timeout
	tween = create_tween().tween_property(portal, "scale", Vector2(14, 11), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	anim2.play("portal")
	await get_tree().create_timer(2.45).timeout
	
	anim3.play("frame3")
	tween = create_tween().tween_property(frame_3, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	tween = create_tween().tween_property(chara, "position", charaPos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(1.0).timeout
	tween = create_tween().tween_property(play, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	

func _on_play_pressed() -> void:
	AudioPlayer._play_fx_btn7()
	await get_tree().create_timer(0.2).timeout
	loading.transition()
	await loading.on_transition_finished
	get_tree().change_scene_to_file("res://res/scene/level/demo_level_1.tscn")
