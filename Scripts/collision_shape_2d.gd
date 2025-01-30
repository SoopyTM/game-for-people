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
	
	# Optionally, check if the nodes exist:
	if animatedSprite2D:
		print("Sprite2D node found!")
	else:
		print("Sprite2D node not found!")
	
	if raycast_above:
		print("RayCast2D node found!")
	else:
		print("RayCast2D node not found!")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_pressed("Crouch"):
		animatedSprite2D.play("walk")
		animatedSprite2D.position.y = -40
		# Crouch logic.
		scale.y = 0.5  # Scale CollisionShape2D (height).  # Scale the MeshInstance2D for crouching.
		if Input.is_action_pressed("Walk_Left"):
			lastHFlip = true
			animatedSprite2D.play("walk")
			animatedSprite2D.position.y = -40
			animatedSprite2D.flip_h = lastHFlip
		elif Input.is_action_pressed("Walk_Right"):
			lastHFlip = false
			animatedSprite2D.play("walk")
			animatedSprite2D.position.y = -40
			animatedSprite2D.flip_h = lastHFlip
			
	elif not raycast_above.is_colliding():  # Only allow uncrouching if nothing is above.
		
		# Uncrouch logic.
		scale.y = 1  # Scale CollisionShape2D back to normal height. # Scale the MeshInstance2D back to normal.
		
		if Input.is_action_pressed("Walk_Left"):
			lastHFlip = true
			animatedSprite2D.play("walk")
			animatedSprite2D.position.y = 0
			animatedSprite2D.flip_h = lastHFlip
		elif Input.is_action_pressed("Walk_Right"):
			lastHFlip = false
			animatedSprite2D.play("walk")
			animatedSprite2D.position.y = -40
			animatedSprite2D.flip_h = lastHFlip
