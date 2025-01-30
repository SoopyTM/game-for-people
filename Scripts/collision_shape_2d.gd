extends CollisionShape2D

var sprite2D: Sprite2D
var raycast_above: RayCast2D
var lastHFlip: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the MeshInstance2D player object from the parent (adjust if needed).
	sprite2D = get_parent().get_node("Sprite2D")
	
	# Get the RayCast2D node (make sure it's a child of the player and positioned above the player).
	raycast_above = get_parent().get_node("RayCast2D")
	
	# Optionally, check if the nodes exist:
	if sprite2D:
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
		sprite2D.texture = load("res://Images/Crouching/Base Mage-2.png.png")
		sprite2D.position.y = -40
		# Crouch logic.
		scale.y = 0.5  # Scale CollisionShape2D (height).  # Scale the MeshInstance2D for crouching.
		if Input.is_action_pressed("Walk_Left"):
			lastHFlip = true
			sprite2D.texture = load("res://Images/Crouching/Base Mage-2.png.png")
			sprite2D.position.y = -40
			sprite2D.flip_h = lastHFlip
		elif Input.is_action_pressed("Walk_Right"):
			lastHFlip = false
			sprite2D.texture = load("res://Images/Crouching/Base Mage-2.png.png")
			sprite2D.position.y = -40
			sprite2D.flip_h = lastHFlip
			
	elif not raycast_above.is_colliding():  # Only allow uncrouching if nothing is above.
		sprite2D.texture = load("res://Images/Idle/Better Mage.png")
		# Uncrouch logic.
		scale.y = 1  # Scale CollisionShape2D back to normal height. # Scale the MeshInstance2D back to normal.
		
		if Input.is_action_pressed("Walk_Left"):
			lastHFlip = true
			sprite2D.texture = load("res://Images/Idle/Better Mage.png")
			sprite2D.position.y = 0
			sprite2D.flip_h = lastHFlip
		elif Input.is_action_pressed("Walk_Right"):
			lastHFlip = false
			sprite2D.texture = load("res://Images/Idle/Better Mage.png")
			sprite2D.position.y = 0
			sprite2D.flip_h = lastHFlip
