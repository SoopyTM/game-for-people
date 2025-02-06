extends CollisionShape2D

var animatedSprite2D: AnimatedSprite2D
var raycastAbove: RayCast2D
var lastHFlip: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animatedSprite2D = get_parent().get_node("AnimatedSprite2D")
	raycastAbove = get_parent().get_node("Roof Detection Ray")
	animatedSprite2D.play("Walking")
	animatedSprite2D.position.y = 0
	animatedSprite2D.flip_h = lastHFlip


func _process(delta: float) -> void:
	if Input.is_action_pressed("Crouch") or raycastAbove.is_colliding():
		_crouch()
	else:
		_stand()

	if Input.is_action_just_released("Crouch"):
		if not raycastAbove.is_colliding():
			_stand()

func _crouch() -> void:
	animatedSprite2D.play("Crouching")
	animatedSprite2D.position.y = -35
	scale.y = 0.5
	_update_flip()

func _stand() -> void:
	scale.y = 1
	animatedSprite2D.position.y = 7
	if Input.is_action_pressed("Walk_Left") or Input.is_action_pressed("Walk_Right"):
		animatedSprite2D.play("Walking")
	else:
		animatedSprite2D.play("Idle")
	_update_flip()

func _update_flip() -> void:
	if Input.is_action_pressed("Walk_Left"):
		lastHFlip = true
	elif Input.is_action_pressed("Walk_Right"):
		lastHFlip = false
	animatedSprite2D.flip_h = lastHFlip
