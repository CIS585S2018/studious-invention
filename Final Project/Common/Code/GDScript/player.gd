extends RigidBody

var moveSpeed = 40;
var jumpForce = 1;
var gravity = 10;
var m_justJumping = false;
var gravityCompounded = Vector3();
var max_speed = 40;
#camera control
var camera
var third_person = false
var flashlight
var pos_label
var song=0
var can_change_fullscreen = true;
var fullscreen = false;
var gravity_vec

onready var yaw = get_node("../yaw")


func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_node("../yaw/CameraBase/Camera")
	self.set_meta("name","player")
	flashlight = get_node("../yaw/CameraBase/Camera/SpotLight")
	flashlight.visible = false
	#$AudioStreamPlayer.play()

func _enter_scene():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_scene():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _integrate_forces(state):
	
	gravity_vec =  get_global_transform().origin.normalized() * gravity;
	PhysicsServer.area_set_param(get_world().get_space(), PhysicsServer.AREA_PARAM_GRAVITY_VECTOR , gravity_vec);
	
	#finalMoveVector is the vector that combines all forces to one
	var mMoveDir = calculate_move_dir(); 
	var finalMoveVector = state.get_linear_velocity() + (mMoveDir + gravity_vec)*state.get_step();
		
	#jumping
	if(Input.is_key_pressed(KEY_SPACE)):
		if(!m_justJumping):
			finalMoveVector -= gravity_vec*jumpForce; 
			m_justJumping = true;
	else :
		if(m_justJumping):
			m_justJumping = false; 	
		
	#limit the max speed
	if(finalMoveVector.length() > max_speed):
		finalMoveVector = finalMoveVector.normalized()*max_speed;
	
	#apply force
	state.set_linear_velocity(finalMoveVector);

func calculate_move_dir():
	var steer = float(Input.is_key_pressed(KEY_D))-float(Input.is_key_pressed(KEY_A));
	var straight = float(Input.is_key_pressed(KEY_S))-float(Input.is_key_pressed(KEY_W));
	return camera.global_transform.basis.xform(Vector3(steer,0,straight).normalized())*moveSpeed;
	
# cast a short ray and call the use() method if the object we hit is usable
func use_thing():
	var ray = self.get_node("../yaw/CameraBase/Camera/ray")
	if ray.is_colliding():
		var object = ray.get_collider()
		print("ray colliding with ",object)
		var type = object.get_meta("type")
		if type == "usable":
#			print("attempting to use ",object," of type ",type," and name ",object.get_meta("name"))
			object.get_node("..").use(self)
	pass
	
# cast a ray (a much longer one than the "use item" ray), call onDeath() if the object being hit is killable
func shoot():
	var gun = self.get_node("../yaw/CameraBase/Camera/gun")
	if gun.is_colliding():
		var object = gun.get_collider()
		var type = object.get_meta("type") # spams errors if the object doesn't have a type set, doesn't crash tho
		print("shooting at ",object)
		if type == "killable":
			object.onDeath()
	pass
	
func change_pov():
	if not third_person:
		third_person = true
		camera.translate(Vector3(0,0.75,1.5))
		camera.rotate_x(deg2rad(-30))
	else:
		third_person = false
		camera.rotate_x(deg2rad(30))
		camera.translate(Vector3(0,-0.75,-1.5))
	pass
		
func _input(ie):
	if ie is InputEventKey and Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		pass
	if ie is InputEventKey and Input.is_key_pressed(KEY_C):
		change_pov()
		pass
		
	if ie is InputEventKey and Input.is_key_pressed(KEY_E):
		use_thing()
		pass
		
	if ie is InputEventKey and Input.is_key_pressed(KEY_CONTROL):
		shoot()
		pass
	
	if ie is InputEventKey and !Input.is_key_pressed(KEY_F):
		can_change_fullscreen = true;
		
	if ie is InputEventKey and Input.is_key_pressed(KEY_P):
		self.translation = Vector3(0,0,0)
			
	if ie is InputEventKey and Input.is_key_pressed(KEY_F) && can_change_fullscreen:
		can_change_fullscreen = false;
		fullscreen = !fullscreen;
		OS.set_window_fullscreen(fullscreen);
#		get_node("crosshair/Label").visible = not get_node("crosshair/Label").visible
		
	if ie is InputEventKey and Input.is_key_pressed(KEY_L):
		flashlight.visible = not flashlight.visible
		pass

func _on_AudioTimer_timeout():
	if song == 0:
		#$AudioStreamPlayer.stream="res://Common/Assets/audio/Hoot.ogg"
		pass
	elif song == 1:
		#$AudioStreamPlayer.stream="res://Common/Assets/audio/Atmosphere.ogg"
		pass
	else:
		pass
