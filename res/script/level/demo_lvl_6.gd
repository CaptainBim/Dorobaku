class_name DemoLevel6 extends Node

var game_end : bool = false
var info : bool = false
var active_count: int = 0
var isCleared : bool = false
var isFailed: bool = false
var saveData = SAVES.new();

@onready var label: Label = $ui_layer/Panel/Label
@onready var timer: Timer = $Timer
@onready var loading: CanvasLayer = $ui_layer/loading
@onready var timerDis: TimeDisplay = $ui_layer/timeDisplay
@onready var dialogue = $Dialogue


var h1 = "s"
var h2 = "u"
var h3 = "p"
var h4 = "i"
var h5 = "r"
var box = "kosong"
@export var maxTime : float
var resetNum = GlobalVar.MaxReset
var timeLeft
var lever1_active : bool = false
var lever2_active : bool = false
@onready var target = $cek_grup.get_child_count()
var cocok = target

func _ready() -> void:
	dialogue.dialogue_started.connect(_on_dialogue_started)
	dialogue.dialogue_finished.connect(_on_dialogue_finished)
	get_node("ui_layer/btn_con/reset_btn").reset_set(0)
	AudioPlayer._play_random_lvl_music()
	$ui_layer/papan.visible = false
	loading.visible = true
	#timer.wait_time = maxTime

	for i in $kotak_grup.get_children() :
		i.add_to_group(i.nama_kotak)
	box_setup()
	#timer.start()
	timerDis.start_timer(maxTime)

func box_setup() -> void:
	print(get_tree());
	get_tree().get_nodes_in_group("s")[0].set_block(h1)
	get_tree().get_nodes_in_group("u")[0].set_block(h2)
	get_tree().get_nodes_in_group("p")[0].set_block(h3)
	get_tree().get_nodes_in_group("i")[0].set_block(h4)
	get_tree().get_nodes_in_group("r")[0].set_block(h5)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") : 
		if isCleared : _nextLvl()
		else : _btn_pause()
	elif Input.is_action_just_pressed("reset") : _on_touch_screen_button_pressed()
	#print(target)
	if game_end == false :
		if target == 0 :
			var door = get_node("door")
			door.open_door()

			timerDis.pause_timer()
			timeLeft = timerDis.get_timeLeft()
			timerDis.stop_timer()

			game_end = true

		elif timerDis.get_timeLeft() < 1 :
			game_end = true
			isFailed = true
			#timeLeft = timerDis.get_timeLeft()
			timerDis.pause_timer()
			selesai()
	
func _on_touch_screen_button_pressed() -> void:
	get_node("ui_layer/btn_con/reset_btn").reset_set(0)
	#if resetNum == 0 : return
	#GlobalVar.MaxReset -= 1
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

	if isCleared:
		get_node("ui_layer/papan").popClear(timeLeft)

		var time_left = timerDis.get_timeLeft()
		var star = 0

		if time_left >= 70:
			star = 3
		elif time_left >= 40:
			star = 2
		elif time_left >= 20:
			star = 1

		saveData.saveData(null, 5, true, star)


	elif isFailed:
		get_node("ui_layer/papan").popFailed()


func _btn_pause() -> void:
	get_node("ui_layer/papan").popPause()
	if !GlobalVar.GameIsPaused : pause_game()
	else : unpause_game()

func pause_game() :
	$ui_layer/movement_btn.visible = false
	$ui_layer/btn_con.visible = false
	$ui_layer/papan.visible = true
	GlobalVar.GameIsPaused = true
	timerDis.pause_timer();

func unpause_game() :
	$ui_layer/movement_btn.visible = true
	$ui_layer/btn_con.visible = true
	$ui_layer/papan.visible = false
	GlobalVar.GameIsPaused = false
	timerDis.start_timer(float(timerDis.get_timeLeft()));

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
	#GlobalVar.MaxReset = 3
	await get_tree().create_timer(0.2).timeout
	loading.transition()
	await loading.on_transition_finished
	AudioPlayer._play_music_menu()
	get_tree().change_scene_to_file("res://res/scene/level/demo_level_7.tscn")

func _on_lever_aksi_lever(condition) -> void:

	# kalau lever 2 aktif, lever 1 tidak bisa ON
	if lever2_active and condition == "on":
		return

	if condition == "on":
		lever1_active = true

		$special2/t2.visible = false
		$special2/t5.visible = false
		$special2/t2/CollisionShape2D.disabled = true
		$special2/t5/CollisionShape2D.disabled = true

	else:
		lever1_active = false

		$special2/t2.visible = true
		$special2/t5.visible = true
		$special2/t2/CollisionShape2D.disabled = false
		$special2/t5/CollisionShape2D.disabled = false
		
func _on_lever_2_aksi_lever(condition) -> void:

	# kalau lever 1 aktif, lever 2 tidak bisa ON
	if lever1_active and condition == "on":
		return

	if condition == "on":
		lever2_active = true

		$special2/t3.visible = false
		$special2/t4.visible = false
		$special2/t3/CollisionShape2D.disabled = true
		$special2/t4/CollisionShape2D.disabled = true

	else:
		lever2_active = false

		$special2/t3.visible = true
		$special2/t4.visible = true
		$special2/t3/CollisionShape2D.disabled = false
		$special2/t4/CollisionShape2D.disabled = false

func _on_dialogue_started():
	timerDis.pause_timer()

func _on_dialogue_finished():
	timerDis.start_timer(timerDis.get_timeLeft())
