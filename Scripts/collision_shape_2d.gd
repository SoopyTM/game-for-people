extends CollisionShape2D

var animatedSprite2D: AnimatedSprite2D
var raycast_above: RayCast2D
var lastHFlip: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the MeshInstance2D player object from the parent (adjust if needed).
	animatedSprite2D = get_parent().get_node("AnimatedSprite2D")
	
	# Get the RayCast2D node (make sure it's a child of the player and positioned above the player).
	raycast_above = get_parent().get_node("RayCast2D")
	
	lastHFlip = false
	animatedSprite2D.play("Walking")
	animatedSprite2D.position.y = 0
	animatedSprite2D.flip_h = lastHFlip

@warning_ignore("unused_parameter")

# PREPARE YOURSELF FOR THE DISASTER THAT IS TIRED BRAIN CODE >:)
func _process(delta: float) -> void:
	if Input.is_action_pressed("Crouch") or raycast_above.is_colliding():
		animatedSprite2D.play("Crouching")
		animatedSprite2D.position.y = -40
		scale.y = 0.5  # Scale CollisionShape2D (height).
		if Input.is_action_pressed("Walk_Left"):
			lastHFlip = true
		elif Input.is_action_pressed("Walk_Right"):
			lastHFlip = false
		animatedSprite2D.flip_h = lastHFlip
	else:
		scale.y = 1  # Scale CollisionShape2D back to normal height.
		if Input.is_action_pressed("Walk_Left"):
			lastHFlip = true
			animatedSprite2D.play("Walking")
		elif Input.is_action_pressed("Walk_Right"):
			lastHFlip = false
			animatedSprite2D.play("Walking")
		else:
			animatedSprite2D.play("Idle")
		animatedSprite2D.position.y = 7
		animatedSprite2D.flip_h = lastHFlip

	if Input.is_action_just_released("Crouch") or Input.is_action_just_released("Walk_Left") or Input.is_action_just_released("Walk_Right"):
		animatedSprite2D.play("Idle")
		animatedSprite2D.position.y = 7
		animatedSprite2D.flip_h = lastHFlip


# A side effect of this is it will crouch when you hit the roof, but that's just an accecibility feature.
