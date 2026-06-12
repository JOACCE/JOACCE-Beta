extends Attack 
@export var ball_speed: float = 600.0
var ball_direction: Vector2 = Vector2.RIGHT
var source_player: Node2D = null
@onready var fire_fx: CPUParticles2D = $fire_fx
@onready var fireball: Sprite2D = $fireball

const FX_RIGHT = preload("res://assets/vfx/fireball.png")
const FX_LEFT  = preload("res://assets/vfx/fireball_flip.png")

func _ready() -> void:
	if ball_direction.x < 0:
		fire_fx.texture = FX_LEFT
		fire_fx.direction.x *= -1
		fire_fx.gravity.x *= -1
		fireball.scale.x *= -1
	else:
		fire_fx.texture = FX_RIGHT
		
func _physics_process(delta: float) -> void:
	global_position += ball_direction * ball_speed * delta
	
func _on_hitarea_body_entered(body: Node2D) -> void:
	if not is_instance_valid(source_player):
		return 
	if body == source_player:
		return
	if "id" in body:
		if body.id == source_player.id:
			return
		if body.has_method("apply_damage"):
			body.apply_damage(25) 
		queue_free()
