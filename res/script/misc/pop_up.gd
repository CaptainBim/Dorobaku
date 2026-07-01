class_name PopMenu extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer

@export var b1_task : String
@export var b2_task : String 
@export var b3_task : String 
var taskStr = "Time > "
@onready var c1: Label = $pause_con/VBoxContainer/b1/c1
@onready var c2: Label = $pause_con/VBoxContainer/b2/c2
@onready var c3: Label = $pause_con/VBoxContainer/b3/c3
@onready var volumeBtn: TouchScreenButton = $pause_con/VBoxContainer/btns_con/Panel5/volume
@onready var restart: TouchScreenButton = $pause_con/VBoxContainer/btns_con/Panel4/restart
@onready var resumeBtn: TouchScreenButton = $pause_con/VBoxContainer/btns_con/Panel4/resume
var muted = false;

signal _exit
var b1 : int
var b2 : int
var b3 : int

func _ready() -> void:
	b1 = int(b1_task)
	b2 = int(b2_task)
	b3 = int(b3_task)

	c1.text = taskStr + b1_task
	c2.text = taskStr + b2_task
	c3.text = taskStr + b3_task

	restart.visible = false

func popPause() :
	anim.play("pause")
	volumeBtn.visible = true
	restart.visible = false
	resumeBtn.visible = true

func popClear(time: int):
	anim.play("clear")
	await anim.animation_finished

	if time >= b3:
		anim.play("b3")
	elif time >= b2:
		anim.play("b2")
	elif time >= b1:
		anim.play("b1")
	else:
		anim.play("b0")

	volumeBtn.visible = false
	restart.visible = false
	resumeBtn.visible = true

func popFailed():
	print("FAILED DIPANGGIL")

	anim.play("failed")
	await anim.animation_finished

	print("MAIN B0")

	anim.play("b0")

	print("HIIIIIIII");
	restart.visible = true

	resumeBtn.visible = false
	volumeBtn.visible = false;

func exit() -> void:
	AudioPlayer._play_fx_btn7()
	_exit.emit(true)

func resume() -> void:
	AudioPlayer._play_fx_btn7()

func restartLvl() -> void:
	AudioPlayer._play_fx_btn7()

func _volume() -> void:
	AudioPlayer._play_fx_btn7()
	if muted:
		AudioPlayer._non_mute_music();
		muted = false;
	else:
		AudioPlayer._mute_music();
		muted = true;
