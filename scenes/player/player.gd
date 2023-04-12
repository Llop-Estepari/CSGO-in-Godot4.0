extends CharacterBody3D

enum STATE {IDLE, WALK, RUN, CROUCH, AIR, DEAD}

@onready var head = $Pivot
@onready var weapons_manager = $Pivot/Camera3D/weapons_manager

const WALK_SPEED = 3.0
const RUN_SPEED = 5.0
const AIR_SPEED = 2.0
const JUMP_VELOCITY = 6.7

var mouse_sens = .15
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cur_state = STATE.RUN
var health :int= 100
var armor :int= 100

func _input(event):
	if event is InputEventMouseMotion:
		if cur_state != STATE.DEAD:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-79), deg_to_rad(89))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("action_esc"): get_hit(25)
	match cur_state:
		STATE.IDLE: pass 
		STATE.WALK: _movement(WALK_SPEED, delta)
		STATE.RUN: _movement(RUN_SPEED, delta)
		STATE.CROUCH: pass
		STATE.AIR: _air(delta)
		STATE.DEAD: pass

func _movement(speed, delta):
	if Input.is_action_just_pressed("action_jump") and is_on_floor(): velocity.y = JUMP_VELOCITY
	if not is_on_floor(): cur_state = STATE.AIR
	var direction = get_direction()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	get_floor_normal()
	move_and_slide()

func _air(delta):
	if not is_on_floor(): 
		velocity.y -= gravity * delta
	else: cur_state = STATE.RUN
	move_and_slide()

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
			cur_state = STATE.DEAD
			weapons_manager.queue_free()
			return
		health -= dmg
	Global.emit_signal("health_changed", health, armor)
