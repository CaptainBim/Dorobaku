class_name LvlSelectMenu extends Node

@onready var loading: CanvasLayer = $loading
@onready var notif: Panel = $Panel/notif
@onready var notifTxt: Label = $Panel/notif/notifTxt
@onready var notifPos = notif.position
@export var chapterKey : String = "ch0"

var saveData = SAVES.new()
var GAME_DATA

func _ready() -> void:
	$loading.visible = true
	GAME_DATA = saveData.loadSave()
	print("GAME_DATA loaded = ", GAME_DATA.data.keys())
	notif.position = notifPos + Vector2 (0 , 70)
	unlockCheck(chapterKey)

func _on_level_pressed(lvl: int, btn) -> void:
	AudioPlayer._play_fx_btn7()
	btn.process_mode = Node.PROCESS_MODE_DISABLED;
	await get_tree().create_timer(0.2).timeout
	loading.transition()
	await loading.on_transition_finished
	
	var path = "res://res/scene/level/demo_level"
	GlobalVar.MaxReset = 3
	path += "_" + str(lvl) + ".tscn"
	# If that scene doesnt exist, go to 'coming_soon'
	if !ResourceLoader.exists(path):
		path = "res://res/scene/level/coming_soon.tscn"
	if lvl == 1 :
		get_tree().change_scene_to_file("res://res/scene/menu/cutscene/story1.tscn")
		return
	print(path);
	get_tree().change_scene_to_file(path)

func _on_back_pressed() -> void:
	AudioPlayer._play_fx_btn7()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://res/scene/menu/menu_home.tscn")

func unlockCheck(chapter: String) :
	if not GAME_DATA.data.has(chapter):
		pushNotif("Chapter key %s not found in save data!" % chapter)
		return
	
	var lvlStates = GAME_DATA.data[chapter]
	var btn_group = get_tree().get_nodes_in_group("level_button");
	print(btn_group)
	
	for key in range(btn_group.size()):
		var btn = btn_group[key]
		if btn is TouchScreenButton:
			var btnName = String(btn.name)
			var lvlIndex = int(btnName.substr(3, btnName.length() - 3)) - 1
			
			
			if lvlIndex < 0 or lvlIndex >= lvlStates.size() :
				continue
			
			var lvlData = lvlStates[lvlIndex]
			var state = lvlData["state"]
			var stars = lvlData["star"]
			
			var starCons = btn.get_node("starCon")
			var closeTex = btn.get_node("closeTex")
			
			closeTex.visible = true
			starCons.visible = true
			
			if state == 3 : #LOCKED
				closeTex.visible = true
				starCons.visible = false
			elif state == 2 : #UNLOCKED
				if btn.pressed.is_connected(_on_level_pressed):
					btn.pressed.disconnect(_on_level_pressed)
				btn.pressed.connect(Callable(self, "_on_level_pressed").bind(lvlIndex + 1, btn))
				closeTex.visible = false
				starCons.visible = true
				starCons.showStars(str(int(stars)))
			elif state == 0 or state == 1 : #CLEAR or PLAYED 
				if btn.pressed.is_connected(_on_level_pressed):
					btn.pressed.disconnect(_on_level_pressed)
				btn.pressed.connect(Callable(self, "_on_level_pressed").bind(lvlIndex + 1, btn))
				closeTex.visible = false
				starCons.visible = true
				starCons.showStars(str(int(stars)))

func pushNotif(notif_text):
	notifTxt.text = notif_text
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_interval(0.25)
	tween.tween_property(notif, "position", notifPos, 0.5)
	tween.tween_interval(1.75)
	tween.tween_property(notif, "position", notifPos + Vector2(0, 70), 0.5)


#func _on_back_2_pressed() -> void:
#	var path = "res://res/scene/level/demo_level_10.tscn"
