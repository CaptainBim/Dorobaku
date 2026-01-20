class_name DemoLevel2 extends Node

var game_end : bool = false
var info : bool = false
var isCleared : bool = false
var isFailed: bool = false
@onready var label: Label = $ui_layer/Panel/Label
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var musicLvl = preload("res://res/asset/sound/bgm3.mp3")
@onready var loading: CanvasLayer = $ui_layer/loading
@onready var timerDis: TimeDisplay = $ui_layer/timeDisplay


var h1 = "i"
var h2 = "z"
var h3 = "n"
var h4 = "j"
var box = "kosong"
@export var maxTime : float
var resetNum = GlobalVar.MaxReset
var timeLeft

@onready var target = $cek_grup.get_child_count()
var cocok = target

func _ready() -> void:
	get_node("ui_layer/btn_con/reset_btn").reset_set(resetNum)
	AudioPlayer._play_lvl_music(musicLvl)
	$ui_layer/papan.visible = false
	loading.visible = true
	anim.play("jembatans_sets")
	#timer.wait_time = maxTime
	for i in $kotak_grup.get_children() :
		i.add_to_group(i.nama_kotak)
	box_setup()
	#timer.start()
	timerDis.start_timer(maxTime)
				
func box_setup() -> void:
	get_tree().get_nodes_in_group("i")[0].set_block(h1)
	get_tree().get_nodes_in_group("z")[0].set_block(h2)
	get_tree().get_nodes_in_group("i")[1].set_block(h1)
	get_tree().get_nodes_in_group("n")[0].set_block(h3)
	get_tree().get_nodes_in_group("j")[0].set_block(h4)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") : 
		if isCleared : _nextLvl()
		else : _btn_pause()
	elif Input.is_action_just_pressed("reset") : _on_touch_screen_button_pressed()
	
	if game_end == false :
		if target == 0 :
			var door = get_node("door")  # Adjust path
			door.open_door()
			timerDis.pause_timer()
			timeLeft = timerDis.get_timeLeft()
			timerDis.stop_timer()
			game_end = true
		elif timerDis.get_timeLeft() < 1 :
			game_end = true
			isFailed = true
			timerDis.pause_timer()
			selesai()
		
func _on_touch_screen_button_pressed() -> void:
	get_node("ui_layer/btn_con/reset_btn").btn_press(resetNum)
	if resetNum == 0 : return
	GlobalVar.MaxReset -= 1
	print(GlobalVar.MaxReset)
	await get_tree().create_timer(0.2).timeout
	restart()
	
func restart():
	game_end = false
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _send_cek(nama_box,nama_cek) -> void:
	if nama_box == nama_cek :
		target -= 1
		print("cek sisa " + str(target))

func _exit_cek(nama_box,nama_cek) -> void:
	if nama_box == nama_cek :
		target += 1
		print("exit balik " + str(target))

func _finish(body: Node2D) -> void:
	if body is Player :
		isCleared = true
		selesai()

func selesai():
	$ui_layer/movement_btn.visible = false
	$ui_layer/btn_con.visible = false
	$ui_layer/papan.visible = true
	if isCleared : get_node("ui_layer/papan").popClear(timeLeft)
	elif isFailed : get_node("ui_layer/papan").popFailed()
	$Player.visible = false

func _btn_pause() -> void:
	get_node("ui_layer/papan").popPause()
	if !GlobalVar.GameIsPaused : pause_game()
	else : unpause_game()

func pause_game() :
	$ui_layer/movement_btn.visible = false
	$ui_layer/btn_con.visible = false
	$ui_layer/papan.visible = true
	GlobalVar.GameIsPaused = true
	
func unpause_game() :
	$ui_layer/movement_btn.visible = true
	$ui_layer/btn_con.visible = true
	$ui_layer/papan.visible = false
	GlobalVar.GameIsPaused = false

func _exit(exit) -> void:
	if exit :
		GlobalVar.GameIsPaused = false
		await get_tree().create_timer(0.2).timeout
		loading.transition()
		await loading.on_transition_finished
		AudioPlayer._play_music_menu()
		get_tree().change_scene_to_file("res://res/scene/menu/menu_lvl.tscn")
func _nextLvl() :
	GlobalVar.GameIsPaused = false
	GlobalVar.MaxReset = 3
	await get_tree().create_timer(0.2).timeout
	loading.transition()
	await loading.on_transition_finished
	AudioPlayer._play_music_menu()
	get_tree().change_scene_to_file("res://res/scene/level/demo_level_3.tscn")


func _on_lever1(condition) -> void:
	if condition == "on" :
		anim.play("jembatan1_on")
		$lobang2.set_collision_layer_value(5,false)
		$lobang2.set_collision_layer_value(1,false)
	else : 
		anim.play("jembatan1_off")
		$lobang2.set_collision_layer_value(5,true)
		$lobang2.set_collision_layer_value(1,true)

func _on_lever2(condition) -> void:
	if condition == "on" :
		anim.play("jembatan2_on")
		$lobang.set_collision_layer_value(5,false)
		$lobang.set_collision_layer_value(1,false)
	else : 
		anim.play("jembatan2_off")
		$lobang.set_collision_layer_value(5,true)
		$lobang.set_collision_layer_value(1,true)
