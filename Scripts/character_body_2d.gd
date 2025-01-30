extends CharacterBody2D

const MAX_SPEED = 700.0 
const JUMP_VELOCITY = -870.0
const CROUCH_SPEED = 350 # Currently Unused
const DECELERATION_TIME = 0.05 # Time to stop (in seconds)
const COYOTE_TIME = 0.2 # Time window after leaving the ground to still be able to jump (in seconds)

var acceleration := MAX_SPEED / 0
var deceleration := MAX_SPEED / DECELERATION_TIME
var coyote_timer := 0.0 # Timer to track coyote time

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		# Count time spent in the air for coyote time
		coyote_timer += delta
	else:
		# Reset the coyote timer when the player is on the floor
		coyote_timer = 0.0

	# Handle jump with coyote time
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_timer <= COYOTE_TIME):
		velocity.y = JUMP_VELOCITY
		# Reset the coyote timer when the jump happens
		coyote_timer = COYOTE_TIME

	# Interrupt jump if the button is released mid-air
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		# Immediately start falling by reducing upward velocity
		velocity.y = 0

	# Get input direction
	var direction := Input.get_axis("Walk_Left", "Walk_Right")

	if direction != 0:
		if Input.is_action_pressed("Crouch") and is_on_floor():
			velocity.x = move_toward(velocity.x, direction * CROUCH_SPEED, acceleration * delta)
		else:
			# Interrupt deceleration and accelerate towards the new direction
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, acceleration * delta)
	else:
		# Gradually decelerate to 0 when no input
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	# Check if the player falls below a certain point, triggering respawn
	if position.y >= 2000:
		death()

	# Apply movement
	move_and_slide()

# Respawn function
func death() -> void:
	position.x = 0
	position.y = 0
