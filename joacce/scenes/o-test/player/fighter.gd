extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -800.0

@onready var progress_bar: ProgressBar = $Healthbar/ProgressBar
@onready var punch: Node2D = $Punch
@onready var kick: Node2D = $Kick
@onready var alt_marker: Marker2D = $Healthbar/AltMarker

var health = 100

func _ready() -> void:
	progress_bar.max_value = health
	progress_bar.value = health
	
	if "2" in name:
		SPEED = 0
		JUMP_VELOCITY = 0
		progress_bar.position = alt_marker.position


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

func apply_damage(damage) -> void:
	health -= damage
	progress_bar.value  = health
	print(name," took ", damage, " damage")

func _on_hitarea_body_entered(body: Node2D) -> void:
	if name != body.name:
		body.apply_damage(5)
