class_name PopMenu extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer

@export var b1_task : String
@export var b2_task : String 
@export var b3_task : String 
var taskStr = "Time > "
@onready var c1: Label = $pause_con/VBoxContainer/b1/c1
@onready var c2: Label = $pause_con/VBoxContainer/b2/c2
@onready var c3: Label = $pause_con/VBoxContainer/b3/c3
@onready var helpBtn: TouchScreenButton = $pause_con/VBoxContainer/btns_con/Panel5/help
@onready var restart: TouchScreenButton = $pause_con/VBoxContainer/btns_con/Panel4/restart
@onready var resumeBtn: TouchScreenButton = $pause_con/VBoxContainer/btns_con/Panel4/resume

signal _exit
var b1 = int(b1_task)  
var b2 = int(b2_task)  
var b3 = int(b3_task)  

func _ready() -> void:
	c1.text = taskStr + b1_task
	c2.text = taskStr + b2_task
	c3.text = taskStr + b3_task
	restart.visible = false

func popPause() :
	anim.play("pause")
	helpBtn.visible = true
	restart.visible = false
	resumeBtn.visible = true

func popClear(time : int) :
	anim.play("clear")
	await anim.animation_finished
	
	if time < b1: anim.play("b0")
	elif time <= b2: anim.play("b1")
	elif time <= b3: anim.play("b2")
	else: anim.play("b3")
	
	helpBtn.visible = false
	restart.visible = false
	resumeBtn.visible = true

func popFailed() :
	anim.play("failed")
	await anim.animation_finished
	anim.play("b0")
	if GlobalVar.MaxReset > 0 :
		restart.visible = true
	resumeBtn.visible = false
	

func exit() -> void:
	AudioPlayer._play_fx_btn7()
	_exit.emit(true)

func resume() -> void:
	AudioPlayer._play_fx_btn7()
	
func help() -> void:
	AudioPlayer._play_fx_btn7()

func restartLvl() -> void:
	AudioPlayer._play_fx_btn7()
