class_name AnimatedBG extends Control

@onready var glint: AnimationPlayer = $glint
@onready var stripe: AnimationPlayer = $stripe
@onready var bgTimer: Timer = $Timer

@export_range(0, 100) var playAnimChances: int = 80
@export var delay: float = 10.0

var allAnims: Array = [
		["glint", "glint1"],
		["glint", "glint2"],
		["stripe", "s1"],
		["stripe", "s2"],
		["stripe", "s3"],
		]
var prevAnims: Array = []

func _ready() -> void:
	randomize()
	bgTimer.start(delay)
	await bgTimer.timeout
	_startLoop()
	
func _startLoop():
	_playLoop()
	
func _playLoop():
	await get_tree().process_frame
	while true:
		var roll = randf() * 100
		if roll <= playAnimChances:
			var picked = allAnims.pick_random()
			
			while picked == prevAnims and allAnims.size() > 1:
				picked = allAnims.pick_random()
			
			prevAnims = picked
			
			var target_node = glint if picked[0] == "glint" else stripe
			var anim_name = picked[1]
			
			target_node.play(anim_name)
			await target_node.animation_finished
		bgTimer.start(delay)
		await bgTimer.timeout
			
