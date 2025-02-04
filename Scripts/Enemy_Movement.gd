extends CharacterBody2D

const SPEED = 450.0
const RUN_SPEED = 550.0
const GRAVITY = 980.0
const CHANGE_DIRECTION_INTERVAL = 1.5
const DAMAGE_AMOUNT = 10.0

@onready var raycast: RayCast2D = $RayCast2D
@onready var shapeCast: ShapeCast2D = $ShapeCast2D

var direction: Vector2 = Vector2.ZERO
var time_since_change: float = 0.0
var player: Node2D = null
var health: float = 100.0

func _ready():
    randomize()
    change_direction()

func _physics_process(delta: float) -> void:
    handle_collisions()
    time_since_change += delta

    if player:
        follow_player()
    else:
        wander_around(delta)

    apply_gravity(delta)
    move_and_slide()

    if health <= 0:
        death()

func handle_collisions():
    if shapeCast.is_colliding():
        var collider = shapeCast.get_collider(0)
        if collider == player or collider.is_in_group("enemy"):
            take_damage(DAMAGE_AMOUNT)

    raycast.force_raycast_update()
    if raycast.is_colliding() and raycast.get_collider().is_in_group("player"):
        player = raycast.get_collider()
    else:
        player = null

func take_damage(amount: float):
    health -= amount

func follow_player():
    var direction_to_player: Vector2 = (player.global_position - global_position).normalized()
    velocity.x = direction_to_player.x * RUN_SPEED

func wander_around(delta: float):
    if time_since_change >= CHANGE_DIRECTION_INTERVAL:
        change_direction()
        time_since_change = 0.0
    velocity.x = direction.x * SPEED

func apply_gravity(delta: float):
    velocity.y += GRAVITY * delta

func change_direction():
    direction.x = randf_range(-1.0, 1.0)
    direction.y = 0

func death():
    queue_free()
