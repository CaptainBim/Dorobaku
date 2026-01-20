class_name Player extends CharacterBody2D

signal buatAksi

@onready var anim_tree: AnimationTree = $anim_tree
@onready var emote: AnimationPlayer = $emote
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
@onready var cast: ShapeCast2D = $ShapeCast2D

var speed = 200
var can_move = true
var can_aksi = false
var is_moving = false
var push_timer = 0.0
var PUSH_HOLD = 0.02

var withTilemap = false
var detectBox = null

func _ready() -> void:
	emote.play("notif_off")

func _physics_process( delta ):
	if Input.is_action_just_pressed("aksi"):
		PlayerManager.interact_pressed.emit()
		
	if can_move : 
		move(delta)

func move(delta):
	var input_movement = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		input_movement.y -= 1
	elif Input.is_action_pressed("down"):
		input_movement.y += 1
	elif Input.is_action_pressed("right"):
		input_movement.x += 1
	elif Input.is_action_pressed("left"):
		input_movement.x -= 1
		
	if push_timer > 0.0:
		push_timer = max(0.0, push_timer - delta)
		
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/idle/blend_position", input_movement)
		anim_tree.set("parameters/walk/blend_position", input_movement)
		anim_tree.set("parameters/push/blend_position", input_movement)
		velocity = input_movement * speed
		
		#await get_tree().create_timer(0.01).timeout
		cast.force_shapecast_update()
		if cast.is_colliding():
			var hit_count = cast.get_collision_count()
			for i in range(hit_count):
				var collider = cast.get_collider(i)
				if collider is KotakHuruf :
					push_timer = PUSH_HOLD
					anim_state.travel("push")
					if collider.move(input_movement):
						move_and_slide()
				break
						
		if push_timer > 0.0:
			anim_state.travel("push")
		else:	
			anim_state.travel("walk")
	else :
		anim_state.travel("idle")
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_aksi_area( b : Node2D ) -> void:
	if b is Lever : emote.play("notif_on")
	elif b is Buku : emote.play("notif_on")
	else : pass

func _off_aksi_area( b : Node2D) -> void:
	if b is Lever : emote.play("notif_off")
	elif b is Buku : emote.play("notif_off")
	else : pass
