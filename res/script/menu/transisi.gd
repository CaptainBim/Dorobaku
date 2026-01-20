extends CanvasLayer

signal on_transition_finished

@onready var showLoading = $BoxContainer
@onready var anim = $AnimationPlayer

func _ready():
	showLoading.visible = false
	anim.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	on_transition_finished.emit()
	anim.play("fade_out")
	
func transition():
	await get_tree().create_timer(0.15).timeout
	showLoading.visible = true
	anim.play("fade_in")
