extends Area2D

@export var speed: float = 600
var direction: Vector2 = Vector2.ZERO
@onready var timer: Timer = $Timer

func _ready():
	if direction == Vector2.ZERO:
		print("Bullet has no direction! Defaulting to right.")
		direction = Vector2.RIGHT
	
	timer.timeout.connect(_on_timer_timeout)
	# Connect the body_entered signal to handle enemy collisions
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()

# Handle collision with enemies
func _on_body_entered(body: Node):
	if body.is_in_group("Enemy"):
		queue_free()
