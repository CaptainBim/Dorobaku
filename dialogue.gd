class_name Dialogue extends Control
@onready var label: Label = $Label;
@onready var timer: Timer = $Timer;
@onready var box: TextureRect = $TextureRect;
@onready var panel: Panel = $Panel;
@onready var uiButton = get_parent().get_node("ui_layer").find_child("movement_btn").find_child("HBoxContainer").find_child("BoxContainer");
@onready var timerDis: TimeDisplay = $ui_layer/timeDisplay
signal dialogue_started
signal dialogue_finished

var open: bool = false;


@export var dialogue_array : Array = [
	
]

var dialogue_index : int = 0:
	set(value):
		dialogue_index = value;
		label.visible_characters = -1;

func _ready():
	label.text = "";
	timer.timeout.connect(animate_label);
	

func animate_label():
	if !open:
		visible = true
		open = true
		uiButton.visible = false
		dialogue_started.emit()

	if dialogue_index >= dialogue_array.size():
		visible = false
		open = false
		uiButton.visible = true
		dialogue_index = 0
		dialogue_finished.emit()
		return

	label.text = dialogue_array[dialogue_index]
	label.visible_characters += 1

	if label.visible_ratio == 1:
		dialogue_index += 1
	else:
		timer.start()
		
func _on_button_pressed() -> void:
	animate_label();


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player :
		PlayerManager.interact_pressed.connect( animate_label )
		print("bisa Aksi")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player :
		PlayerManager.interact_pressed.disconnect( animate_label )
		print("keluar area aksi")
