extends CharacterBody3D

enum STATE {WALK, AIR}

@onready var head = $Camera_Pivot
@onready var weapons_manager = $Camera_Pivot/Camera3D/weapons_manager

var cur_state := STATE.WALK
var new_state := false

#MOVEMENT
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const ACCEL = 2.0
const AIR_ACCEL = ACCEL / 2
const MAX_SPEED = 8.0
const MAX_AIR_SPEED = 15.0
const JUMP_VELOCITY = 8.0
const FRICTION = 8.0

var can_jump := true

#CONFIG
var mouse_sens = .15

#PLAYER
var health : int = 100
var armor : int = 100

func _input(event):
	if event is InputEventMouseMotion:
#		if cur_state != STATE.DEAD:#
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("action_esc"): get_tree().quit()
	
	match cur_state:
		STATE.WALK:
			_movement(delta)
		STATE.AIR:
			air(delta)
	
	move_and_slide()
	$Debug/DEBUG_LABEL.text = str("State: ", cur_state, " , new: ", new_state,"\nDirection: ", get_direction(), "\nVelocity: ", velocity, "\nIs on floor: ", is_on_floor() ,"\nInput(w-s,a-d): ", Input.get_vector("forward", "backward", "left", "right"))

func _movement(delta):
	if new_state:
		new_state = false
	if Input.is_action_just_pressed("action_jump") and is_on_floor() and can_jump:
		velocity.y = JUMP_VELOCITY
	if get_direction():
		velocity.z += get_direction().z * ACCEL
		velocity.z = clamp(velocity.z, -MAX_SPEED, MAX_SPEED)
		velocity.x += get_direction().x * ACCEL
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.z = lerp(velocity.z, 0.0, .3)
	velocity.x = lerp(velocity.x, 0.0, .3)
	
	if not is_on_floor():
		change_state(STATE.AIR)

func air(delta):
	if new_state:
		new_state = false
	velocity.y -= gravity * delta
	if is_on_floor():
		change_state(STATE.WALK)

func change_state(_state):
	new_state = true
	cur_state = _state

func get_direction() -> Vector3:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func get_hit(dmg):
	if health == 0:
		return
	if armor > 0:
		while armor > 0:
			if dmg == 0: break
			armor -= 1
			dmg -= 1
	if dmg > 0 and armor == 0:
		if health - dmg <= 0:
			health = 0
			Global.emit_signal("health_changed", health, armor)
#			cur_state = STATE.DEAD
			weapons_manager.queue_free()
			return
		health -= dmg
	Global.emit_signal("health_changed", health, armor)
