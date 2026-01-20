class_name PressurePlate extends Node2D

signal activated(nama_box: String, nama_cek: String)
signal deactivated(nama_box: String, nama_cek: String)
@export var nama_cek: String = "some_name_here"

@export var check_all_entities : bool = false
signal pressed

var nama_box = "a"
var bodies : int = 0
var is_active : bool = false
var off_rect : Rect2

@onready var area_2d: Area2D = $Area2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_activate : AudioStream = preload("res://res/asset/test/lever-01.wav")
@onready var audio_deactivate : AudioStream = preload("res://res/asset/test/lever-02.wav")
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if check_all_entities : anim.play("set2_up")
	
	area_2d.body_entered.connect( _on_body_entered )
	area_2d.body_exited.connect( _on_body_exited )
	off_rect = sprite.region_rect

func _on_body_entered( b : Node2D ) -> void:
	if b is KotakHuruf and !check_all_entities :
		bodies += 1
		nama_box = b.nama_kotak
		check_is_acivated()
	elif check_all_entities :
		pressed.emit("on")
		anim.play("set2_press")
		play_audio( audio_activate )

func _on_body_exited( b : Node2D ) -> void:
	if b is KotakHuruf and !check_all_entities :
		bodies = max(0, bodies - 1)
		check_is_acivated()
	elif check_all_entities :
		pressed.emit("off")
		anim.play("set2_up")
		play_audio( audio_deactivate )

func check_is_acivated() -> void:
	if bodies > 0 and not is_active :
		is_active = true
		anim.play("press")
		play_audio( audio_activate )
		activated.emit(nama_box,nama_cek)
	elif bodies == 0 and is_active :
		is_active = false
		anim.play("up")
		play_audio( audio_deactivate )
		deactivated.emit(nama_box, nama_cek)

func play_audio( _stream : AudioStream) -> void:
	audio.stream = _stream
	audio.play()
