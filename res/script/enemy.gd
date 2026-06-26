extends CharacterBody2D

const speed = 120;

@export var player: Node2D;
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D;
@onready var animation = $AnimatedSprite2D;
var anim = "idle"
func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized();
	
	velocity = dir * speed;
	if velocity.x > velocity.y:
		if dir.x > 0:
			animation.play("walk_right")
		else:
			animation.play("walk_left")
	else:
		if dir.y > 0:
			animation.play("walk_mid")
		else:
			animation.play("walk_back")
	move_and_slide();

func find_player():
	nav_agent.target_position = player.global_position;
	


func _on_timer_timeout() -> void:
	find_player();


func _on_aksi_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_parent().selesai();
