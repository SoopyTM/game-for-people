extends CharacterBody2D

const SPEED = 300.0
const RUN_SPEED = 500.0
const GRAVITY = 980.0  # Gravity strength
const CHANGE_DIRECTION_INTERVAL = 1.5  # Change direction every 1.5 seconds

var direction: Vector2 = Vector2.ZERO
var time_since_change = 0.0
var player = null
@onready var raycast = $RayCast2D

func _ready():
	randomize()
	change_direction()

func _physics_process(delta: float) -> void:
	time_since_change += delta
	
	if player:
		raycast.target_position = (player.global_position - global_position).normalized() * raycast.target_position.length()
	raycast.force_raycast_update()
	
	if raycast.is_colliding() and raycast.get_collider().is_in_group("player"):
		player = raycast.get_collider()
	else:
		player = null
	
	if player:
		var direction_to_player = (player.global_position - global_position).normalized()
		velocity.x = direction_to_player.x * RUN_SPEED
	else:
		if time_since_change >= CHANGE_DIRECTION_INTERVAL:
			change_direction()
			time_since_change = 0.0
		velocity.x = direction.x * SPEED
	
	velocity.y += GRAVITY * delta  # Apply gravity
	move_and_slide()

func change_direction():
	direction.x = randf_range(-1.0, 1.0)
	direction.y = 0
