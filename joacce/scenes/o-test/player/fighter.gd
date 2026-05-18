extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -600.0

@onready var progress_bar: ProgressBar = $Healthbar/ProgressBar
@onready var punch: Node2D = $Punch
@onready var kick: Node2D = $Kick
@onready var alt_marker: Marker2D = $Healthbar/AltMarker
@onready var idle: Sprite2D = $Sprites/Idle
@onready var walk: AnimatedSprite2D = $Sprites/Walk
@onready var punch_frame: Sprite2D = $Sprites/Punch
@onready var kick_frame: Sprite2D = $Sprites/Kick
@onready var damage_frame: Sprite2D = $Sprites/Damage


var health = 100
var attacking = false

func _ready() -> void:
	progress_bar.max_value = health
	progress_bar.value = health
	
	if "2" in name:
		SPEED = 0
		JUMP_VELOCITY = 0
		progress_bar.position = alt_marker.position
		$Sprites.scale.x = -1


func _physics_process(delta: float) -> void:
	if "2" in name:
		move_and_slide()
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("punch"):
		punch.attack()
		show_frame(punch_frame, 1.0)
		
		
	if Input.is_action_just_pressed("kick"):
		kick.attack()
		show_frame(kick_frame, 1.0)
		
	var direction := Input.get_axis("left", "right")
	if direction:
		walk.visible = true
		walk.play()
		idle.visible = false
		velocity.x = direction * SPEED
	else:
		walk.visible = false
		walk.stop()
		idle.visible = not attacking
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func apply_damage(damage) -> void:
	show_frame(damage_frame, 0.7)
	health -= damage
	progress_bar.value  = health
	print(name," took ", damage, " damage")

func _on_hitarea_body_entered(body: Node2D) -> void:
	if name != body.name:
		body.apply_damage(5)

func show_frame(frame: Sprite2D, duration: float) -> void:
	attacking = true
	idle.visible = false
	frame.visible = true
	await get_tree().create_timer(duration).timeout
	attacking = false
	frame.visible = false
	idle.visible = true
