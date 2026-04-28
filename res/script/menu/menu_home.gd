class_name HomeMenu extends Node

@onready var loading: CanvasLayer = $loading
@onready var notif: Panel = $Panel/notif
@onready var notifTxt: Label = $Panel/notif/notifTxt
#@onready var notifPos = notif.position

var saveData = SAVES.new()
var GAME_DATA

func _ready() -> void:
	AudioPlayer._play_music_menu()
	$loading.visible = true
	#notif.position = notifPos + Vector2 (0 , 70)
	GAME_DATA = saveData.loadSave()
	
	match GAME_DATA.status:
		SAVES.SaveStatus.NEW:
			pushNotif("New Save File has been Created.....")
		SAVES.SaveStatus.OK:
			pushNotif("Save Loaded Successfully.....")
		SAVES.SaveStatus.ERROR:
			pushNotif("Save File Corrupted, Recreating Save.....")
		SAVES.SaveStatus.OUTDATED:
			pushNotif("Outdated Save detected, Updating.....")
		

func _press_btnCredits() -> void:
	AudioPlayer._play_fx_btn7()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://res/scene/menu/credits.tscn")

func _press_btnPlay() -> void:
	AudioPlayer._play_fx_btn7()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://res/scene/menu/menu_lvl.tscn")

func pushNotif(notif_text):
	notifTxt.text = notif_text
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_interval(0.25)
	#tween.tween_property(notif, "position", notifPos, 0.5)
	tween.tween_interval(1.75)
	#tween.tween_property(notif, "position", notifPos + Vector2(0, 70), 0.5)


func _on_btn_quit_pressed() -> void:
	AudioPlayer._play_fx_btn7()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
