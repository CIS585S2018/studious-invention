extends KinematicBody
#most of the camera control and movement is taken from a tutorial I found online
var speed = 500
var direction = Vector3()
var gravity = -9.8
var velocity = Vector3()

#camera control
var camera
var view_sensitivity = 0.15
var yaw = 0
var pitch = 0

func _process(delta):
	pass

func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_node("Camera")
	self.set_meta("name","player")

func _enter_scene():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_scene():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var aim = self.get_global_transform().basis
	
	direction = Vector3()
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction -= aim[0]
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction += aim[0]
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction -= aim[2]
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction += aim[2]
	
	direction = direction.normalized()
	direction = direction * speed * delta
	
	if velocity.y > 0:
		gravity = -20
	else:
		gravity = -30
	velocity.y += gravity * delta
	velocity.x = direction.x
	velocity.z = direction.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
		
	#jump
	if is_on_floor() and Input.is_key_pressed(KEY_SPACE):
		velocity.y = 10
	if is_on_floor() and Input.is_key_pressed(KEY_H):
		velocity.y = 20
	
func _input(ie):
	if ie is InputEventKey and Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		pass
	
	if ie is InputEventKey and Input.is_key_pressed(KEY_F):
		OS.window_fullscreen = not OS.window_fullscreen
		pass
		
	#mouse movement
	if ie is InputEventMouseMotion:
		yaw = fmod(yaw - ie.relative.x * view_sensitivity, 360)
		pitch = max(min(pitch - ie.relative.y * view_sensitivity, 90), -90)
		set_rotation(Vector3(0, deg2rad(yaw), 0))
		camera.set_rotation(Vector3(deg2rad(pitch), 0, 0))