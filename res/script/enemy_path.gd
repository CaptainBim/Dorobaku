extends PathFollow2D

@export var speed: float = 100.0

var previous_position: Vector2
var velocity: Vector2
@onready var orgs = $orgs

func _ready():
	previous_position = global_position

func _physics_process(delta: float) -> void:
	if !GlobalVar.GameIsPaused:
		progress += speed * delta

		velocity = (global_position - previous_position) / delta
		previous_position = global_position

		var direction = velocity.normalized()

		if abs(velocity.x) > abs(velocity.y):
			if direction.x > 0:
				orgs.get_node("AnimatedSprite2D").play("walk_right")
			else:
				orgs.get_node("AnimatedSprite2D").play("walk_left")
		else:
			if direction.y > 0:
				orgs.get_node("AnimatedSprite2D").play("walk_mid")
			else:
				orgs.get_node("AnimatedSprite2D").play("walk_back")
