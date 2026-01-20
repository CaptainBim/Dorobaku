class_name TimeDisplay extends Control

@onready var timer: Timer = $Timer
@onready var num1: Sprite2D = $Panel/HBoxContainer/Panel2/num1
@onready var num2: Sprite2D = $Panel/HBoxContainer/Panel3/num2
@onready var num3: Sprite2D = $Panel/HBoxContainer/Panel4/num3

@onready var clock_anim: AnimationPlayer = $clockAnim
@onready var num_1: AnimationPlayer = $num1
@onready var num_2: AnimationPlayer = $num2
@onready var num_3: AnimationPlayer = $num3
var time_left: float = 0.0

signal timeout

func _process(delta: float) -> void:
	if timer.time_left > 0.0:
		time_left = timer.time_left
		_updateDigits(int(time_left))
	else : timeout.emit()
	
func _updateDigits(val: int) -> void:
	var num = str(val)
	var padded = "000".substr(0, 3 - num.length()) + num
	
	_setDigit(num1, int(padded[0]), "1")
	_setDigit(num2, int(padded[1]), "2")
	_setDigit(num3, int(padded[2]), "3")
	
func _setDigit(node: Sprite2D, val : int, num) -> void:
	node.frame = val

func get_timeLeft() -> int :
	return int(time_left)
	
func pause_timer():
	timer.paused = true
	clock_anim.pause()
	
func stop_timer():
	timer.stop()
	
func start_timer(max_time: float):
	timer.wait_time = max_time
	time_left = max_time
	timer.start()
	clock_anim.play("timer")
