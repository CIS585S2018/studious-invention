extends KinematicBody

var mult = 0.075;
var moveSpeed = 100 * mult;
var jumpForce = 12.5 * mult;
var gravity = 200 * mult;
var m_justJumping = false;
var gravityCompounded = Vector3();
var max_speed = 999999 * mult;
#camera control
var camera
var third_person = false
var flashlight
var pos_label
var song=0
var can_change_fullscreen = true;
var fullscreen = false;
var gravity_vec
var finalMoveVector = Vector3();

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

func _physics_process(delta):
	var g_norm = get_global_transform().origin.normalized();
	gravity_vec = g_norm  * gravity;
	var mMoveDir = calculate_move_dir(); 
	finalMoveVector += gravity_vec*delta;
	
	move_and_slide(finalMoveVector,-g_norm);
	
	#if(is_on_floor()):
	move_and_slide(mMoveDir,-g_norm);
	
	if(is_on_floor()):
		finalMoveVector = Vector3();
	
	if(Input.is_key_pressed(KEY_SPACE)):
		if(!m_justJumping):
			finalMoveVector -= gravity_vec*jumpForce; 
			m_justJumping = true;
	elif Input.is_key_pressed(KEY_H):
		if !m_justJumping:
			finalMoveVector -= gravity_vec*jumpForce*1.5; 
			m_justJumping = true;
	elif is_on_floor() and m_justJumping:
			m_justJumping = false;
			
	#if(finalMoveVector.length() > max_speed):
	#	finalMoveVector = finalMoveVector.normalized()*max_speed;
	

		
	
"""func _integrate_forces(state):
	
	gravity_vec =  get_global_transform().origin.normalized() * gravity;
	PhysicsServer.area_set_param(get_world().get_space(), PhysicsServer.AREA_PARAM_GRAVITY_VECTOR , gravity_vec);
	
	#finalMoveVector is the vector that combines all forces to one
	var mMoveDir = calculate_move_dir(); 
	var finalMoveVector = state.get_linear_velocity()*0.99 + gravity_vec*state.get_step();
	
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
	var tmp_vec3 = Vector3();
	
	if(contact_monitor):
		tmp_vec3 =  mMoveDir*state.get_step();
		
	state.set_linear_velocity(finalMoveVector + tmp_vec3 );"""

func calculate_move_dir():
	
	var g_norm = get_global_transform().origin.normalized();
	
	var steer = float(Input.is_key_pressed(KEY_D))-float(Input.is_key_pressed(KEY_A));
	var straight = float(Input.is_key_pressed(KEY_S))-float(Input.is_key_pressed(KEY_W));
	
	var x_axis = camera.global_transform.basis.x;
	var y_axis = camera.global_transform.basis.y;
	var z_axis = camera.global_transform.basis.z;
	
	var straightVec3 = g_norm.rotated(x_axis,-PI/2*straight);
	var steerVec3 = g_norm.rotated(z_axis,PI/2*steer);
	
	var fin = (straightVec3 + steerVec3).normalized();
	
	return fin*moveSpeed;
	
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

# cast a ray (a much longer one than the "use item" ray), call onDeath() if the object being hit is killable
func shoot():
	var gun = self.get_node("../yaw/CameraBase/Camera/gun")
	if gun.is_colliding():
		var object = gun.get_collider()
		if object.has_meta("type") and object.get_meta("type") == "killable":
			object.onDeath()

func change_pov():
	if not third_person:
		third_person = true
		camera.translate(Vector3(0,0.75,1.5))
		camera.rotate_x(deg2rad(-30))
	else:
		third_person = false
		camera.rotate_x(deg2rad(30))
		camera.translate(Vector3(0,-0.75,-1.5))

func _input(ie):
	if ie is InputEventKey and Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

#	if ie is InputEventKey and Input.is_key_pressed(KEY_C):
#		change_pov()
		
	if ie is InputEventKey and Input.is_key_pressed(KEY_E):
		use_thing()
		
#	if ie is InputEventKey and Input.is_key_pressed(KEY_CONTROL):
#		shoot()
	
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

func _on_AudioTimer_timeout():
	if song == 0:
		#$AudioStreamPlayer.stream="res://Common/Assets/audio/Hoot.ogg"
		pass
	elif song == 1:
		#$AudioStreamPlayer.stream="res://Common/Assets/audio/Atmosphere.ogg"
		pass
	else:
		pass
