extends CharacterBody2D

@export var bullet: PackedScene

const MAX_SPEED = 700.0
const JUMP_VELOCITY = -870.0
const CROUCH_SPEED = 350
const DECELERATION_TIME = 0.05
const COYOTE_TIME = 0.2


var raycast_above: RayCast2D
var acceleration := MAX_SPEED / 0
var deceleration := MAX_SPEED / DECELERATION_TIME
var coyote_timer := 0.0
var playerHealth: float = 100.0
var canShoot: bool = true

func _ready() -> void:
	raycast_above = get_node("RayCast2D")

func _physics_process(delta: float) -> void:
	spawn_bullets()
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		coyote_timer += delta
	else:
		coyote_timer = 0.0

	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_timer <= COYOTE_TIME):
		velocity.y = JUMP_VELOCITY
		coyote_timer = COYOTE_TIME

	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = 0

	var direction := Input.get_axis("Walk_Left", "Walk_Right")

	if direction != 0:
		if Input.is_action_pressed("Crouch") and is_on_floor():
			velocity.x = move_toward(velocity.x, direction * CROUCH_SPEED, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		
	if not Input.is_action_pressed("Crouch") and raycast_above.is_colliding():
		velocity.x = move_toward(velocity.x, direction * CROUCH_SPEED, acceleration * delta)

	if position.y >= 2000 or playerHealth == 0:
		death()

	move_and_slide()

func death() -> void:
	position = Vector2(0, 0)
	playerHealth = 100.0
	
func spawn_bullets():
	if canShoot:
		if Input.is_action_pressed("Shoot"):
			if bullet:
				var bullet_instance = bullet.instantiate()
				bullet_instance.global_transform = global_transform  # Set position

				# Get player's facing direction based on sprite flip_h
				var player_facing_direction = Vector2(-1 if get_node("CollisionShape2D").animatedSprite2D.flip_h else 1, 0)  
				bullet_instance.direction = player_facing_direction  # Set bullet direction

				get_parent().add_child(bullet_instance)
				canShoot = false
				await get_tree().create_timer(0.2).timeout
				canShoot = true
			else:
				push_error("Bullet scene is not assigned!")

			
