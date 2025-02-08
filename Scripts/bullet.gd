extends Area2D

@export var speed: float = 1000
@export var direction: Vector2 = Vector2.RIGHT

var animatedSprite2D

var is_ready: bool = false

@onready var timer: Timer = $Timer

func _ready():
	is_ready = true
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	
	timer.timeout.connect(_on_timer_timeout)
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if is_ready:
		animatedSprite2D = get_node("AnimatedSprite2D")
		animatedSprite2D.play()
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("Enemy") or body.is_in_group("Floor"):
		queue_free()
