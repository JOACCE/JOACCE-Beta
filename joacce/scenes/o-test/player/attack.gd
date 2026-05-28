class_name Attack
extends Node2D
@onready var hitarea: Area2D = $Hitarea

@onready var color_rect: ColorRect = $ColorRect
@onready var hitbox: CollisionShape2D = $Hitarea/Hitbox
@export var damage : int

@export var speed: float = 600.0
var direction: Vector2 = Vector2.RIGHT

var in_action = false
const linger = 0.3
var time_out = 0

func _ready() -> void:
	_disable_hit()
	# rotates the whole fireball (including particles) to face the travel direction
	rotation = direction.angle()

func _process(delta: float) -> void:
	if in_action:
		time_out += delta
		if time_out >= linger:
			_disable_hit()
			time_out = 0

func attack():
	_enable_hit()

func _enable_hit():
	in_action = true
	hitbox.disabled = false
	color_rect.visible = true

func _disable_hit():
	in_action = false
	hitbox.disabled = true
	color_rect.visible = false
	

func _physics_process(delta: float) -> void:
	# Moves the fireball forward horizontally
	global_position += direction * speed * delta
