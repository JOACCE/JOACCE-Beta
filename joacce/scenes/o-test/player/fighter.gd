extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -400.0

@onready var punch: Node2D = $Punch
@onready var kick: Node2D = $Kick

var health = 100

func _ready() -> void:
	if "2" in name:
		SPEED = 0
		JUMP_VELOCITY = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("punch"):
		punch.attack()
		
	if Input.is_action_just_pressed("kick"):
		kick.attack()
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hitarea_body_entered(body: Node2D) -> void:
	if name != body.name:
		print(body, " -", body.health)
		body.health -= 10
