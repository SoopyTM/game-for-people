extends CharacterBody2D

const SPEED = 450.0
const RUN_SPEED = 550.0
const GRAVITY = 980.0
const CHANGE_DIRECTION_INTERVAL = 1.5

var direction: Vector2 = Vector2.ZERO
var time_since_change = 0.0
var player = null
var health: float = 100.0
@onready var raycast = $RayCast2D
@onready var shapeCast = $ShapeCast2D

func _ready():
	randomize()
	change_direction()

func _physics_process(delta: float) -> void:
	if shapeCast.is_colliding() and shapeCast.get_collider(0) == player:
		health -= 10

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
	
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	if health <= 0:
		death()

func change_direction():
	direction.x = randf_range(-1.0, 1.0)
	direction.y = 0
	
func death():
	queue_free()
