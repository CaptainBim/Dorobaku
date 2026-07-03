extends CharacterBody2D

@export var speed := 70.0
@onready var path_node: Node = $"../Node"
@onready var anim = $AnimatedSprite2D

var points: Array[Marker2D] = []
var current := 0
var stop_move := false
var current_anim := ""

func play_anim(anim_name: String):
	if current_anim == anim_name:
		return

	current_anim = anim_name
	anim.play(anim_name)

func _ready():
	for child in path_node.get_children():
		if child is Marker2D:
			points.append(child)

func _physics_process(_delta):
	if GlobalVar.GameIsPaused or stop_move:
		return

	if points.is_empty():
		return

	var target = points[current].global_position

	velocity = global_position.direction_to(target) * speed
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		#if collider is KotakHuruf:
			#collider.move(velocity.normalized())

		if collider is Player:
			stop_move = true
			velocity = Vector2.ZERO
			#bug di area ini
			var level = get_tree().current_scene
			level.game_end = true
			level.isFailed = true
			level.timerDis.pause_timer()
			level.timerDis.stop_timer()
			level.selesai()

	if global_position.distance_to(target) < 5:
		current = (current + 1) % points.size()

	update_anim()

func update_anim():
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			play_anim("walk_right")
		else:
			play_anim("walk_left")
	else:
		if velocity.y > 0:
			play_anim("walk_mid")
		else:
			play_anim("walk_back")
			
func _on_aksi_area_body_entered(body: Node2D) -> void:
	if body is Player:
		stop_move = true
		velocity = Vector2.ZERO

		var level = get_tree().current_scene
		level.isFailed = true
		level.selesai()
		
