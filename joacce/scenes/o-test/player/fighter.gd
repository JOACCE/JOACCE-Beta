extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -600.0




@onready var punch: Node2D = $Punch
@onready var kick: Node2D = $Kick
@onready var charge_bar = $ProgressBar 
@onready var health_bar = $Healthbar/Healthbar
@onready var meter_bar = $Healthbar/Meterbar
var charge_speed = 70.0
var current_charge = 0.0
var max_charge = 100
var charge_stack = 0

var player ={}
#player distinct by player_id
@export var player_id := 1

var health = 100

func _ready() -> void:
	if "2" in name:
		SPEED = SPEED
		JUMP_VELOCITY = JUMP_VELOCITY
	# Initialize healthbar UI
	health_bar.init_health(health)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var direction = 0

	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	if Input.is_action_just_pressed("punch"):
		punch.attack()
		#
	
		
	
	if player_id == 1:
		if Input.is_action_pressed("p1_move_left"):
			direction -=1
		if Input.is_action_pressed("p1_move_right"):
			direction +=1
			print("Player 1 is moving")

		if Input.is_action_pressed("p1_jump") and is_on_floor_only():
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("kick"):
			kick.attack()
		if Input.is_action_pressed("p1_charge"):
			if current_charge < max_charge:
				charge_bar.visible = true
				current_charge += charge_speed * delta
				charge_bar.value = current_charge
				if current_charge > 100:
					print("Fully Charged")
					# WILL CHANGE CURRENTLY HARD CODED MAX OF 5
					charge_stack = min(charge_stack + 1, 5)
					meter_bar.update_charges(charge_stack)
		if Input.is_action_just_released("p1_charge"):
			charge_bar.visible = false
			print("Charged")
			current_charge = 0
			charge_bar.value = current_charge
	if player_id == 2:
		if Input.is_action_pressed("p2_move_left"):
			direction -=1
			print("Player 2 is moving")

		if Input.is_action_pressed("p2_move_right"):
			direction +=1
			print("Player 2 is moving")

		if Input.is_action_pressed("p2_jump") and is_on_floor_only():
			
			velocity.y = JUMP_VELOCITY
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func apply_damage(damage) -> void:
	health -= damage
	# Update healthbar UI state
	health_bar.health = health
	print(name," took ", damage, " damage")

func _on_hitarea_body_entered(body: Node2D) -> void:
	if name != body.name:
		body.apply_damage(5)
