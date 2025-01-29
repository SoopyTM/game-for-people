extends CollisionShape2D

var MeshInstance2DPlayer: MeshInstance2D
var raycast_above: RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the MeshInstance2D player object from the parent (adjust if needed).
	MeshInstance2DPlayer = get_parent().get_node("MeshInstance2D")
	
	# Get the RayCast2D node (make sure it's a child of the player and positioned above the player).
	raycast_above = get_parent().get_node("RayCast2D")
	
	# Optionally, check if the nodes exist:
	if MeshInstance2DPlayer:
		print("MeshInstance2D node found!")
	else:
		print("MeshInstance2D node not found!")
	
	if raycast_above:
		print("RayCast2D node found!")
	else:
		print("RayCast2D node not found!")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_pressed("Crouch"):
		# Crouch logic.
		scale.y = 0.5  # Scale CollisionShape2D (height).
		MeshInstance2DPlayer.scale.y = 0.5 * 85  # Scale the MeshInstance2D for crouching.
	elif not raycast_above.is_colliding():  # Only allow uncrouching if nothing is above.
		# Uncrouch logic.
		scale.y = 1  # Scale CollisionShape2D back to normal height.
		MeshInstance2DPlayer.scale.y = 1 * 85  # Scale the MeshInstance2D back to normal.
