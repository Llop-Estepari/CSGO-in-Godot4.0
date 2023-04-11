extends CharacterBody3D

enum STATE {IDLE, WALK, RUN, CROUCH}

@onready var head = $Pivot

const SPEED = 5.0
const JUMP_VELOCITY = 4.0

var mouse_sens = .15
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cur_state = STATE.WALK

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-60), deg_to_rad(89))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("action_esc"): get_tree().quit()
	match cur_state:
		STATE.IDLE: pass
		STATE.WALK: _movement(delta)
		STATE.RUN: pass
		STATE.CROUCH: pass
	_air(delta)

func _movement(delta):
	if Input.is_action_just_pressed("action_jump") and is_on_floor(): velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func _air(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
