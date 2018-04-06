extends KinematicBody
#most of the camera control and movement is taken from a tutorial I found online
var speed = 20;
var direction = Vector3()
var gravity = 9.8
var velocity = Vector3()
var m = SpatialMaterial.new();

#camera control
var camera
var third_person = false
#var view_sensitivity = 0.15
#var yaw = 0
#var pitch = 0
var flashlight

var pos_label

#func _process(delta):

func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_node("yaw/CameraBase/Camera")
	self.set_meta("name","player")
	flashlight = get_node("yaw/CameraBase/Camera/SpotLight")
	flashlight.visible = false

func _enter_scene():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_scene():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var aim = get_node("yaw").get_global_transform().basis
	
	
	direction = Vector3()
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction -= Vector3(1,0,0);
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction += Vector3(1,0,0);
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction -= Vector3(0,0,1);
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction += Vector3(0,0,1);
	
	direction = camera.global_transform.basis.xform(direction);
	direction = direction.normalized();
	direction = direction * speed * delta
	
	
	var gravity_vec = get_global_transform().origin.normalized() * delta * gravity;		
	
	if is_on_floor():
		velocity.x += direction.x;
		velocity.z += direction.z;
	
	velocity += gravity_vec;
	
	rotate_model(delta);
	
	velocity = move_and_slide(velocity,-gravity_vec);
		
	#jump
	if (is_on_floor() and Input.is_key_pressed(KEY_SPACE)):
		velocity += -gravity_vec*100;
	if (is_on_floor() and  Input.is_key_pressed(KEY_H)):
		velocity += -gravity_vec*200;
		
	
func rotate_model(delta):
	var t = get_transform()
	var rotTransform = t.looking_at(Vector3(0,0,0),Vector3(0,1,0))
	var thisRotation = Quat(t.basis).slerp(rotTransform.basis,1)
	"""
	value += delta
	if value>1:
		alue = 1
		"""

	set_transform(Transform(thisRotation,t.origin))
	
	#var position = Vector3(10, 0, 0)#get_global_transform().origin;
	"""
	var target = Vector3()
	var pos = get_global_transform().origin
	var up = Vector3(0, 1, 0)
	
	var delta = pos - target
	
	pos = target + delta
	
	look_at_from_position(pos, target, up)
	
	# Turn a little up or down
	var t = get_transform()
	t.basis = Basis(t.basis[0], deg2rad(0.0))*t.basis
	set_transform(t)
	global_rotate(Vector3(0, 0, 1), -deg2rad(90.0))
	"""
	#var point_direction = -position.normalized()
	#var quat = Quat(-normalized_position.x, -normalized_position.y, -normalized_position.z, 0)
	#var bVec = Vector3(
	#normalized_position.z, 
	#normalized_position.x, 
	#normalized_position.y);
	#transform = Transform(Basis(Quat(-point_direction.x, -point_direction.y, -point_direction.z, 0)), position)
	#transform = Transform()
	#look_at_from_position(position, Vector3(), get_global_transform().basis.y)
	#rotate_y(PI)
	#rotate_z(-PI/2)
	#transform = transform.xform(Basis(position));
	#transform = transform.rotated(Quat(-normalized_position.x, -normalized_position.y, -normalized_position.z, 0), 0)
	#transform = transform.looking_at(Vector3(), Vector3(0, 0, 0));
	
	#var gravity_vec = get_global_transform().origin.normalized() * delta * gravity;
	#var up = -gravity_vec.normalized();
	#look_at(-get_global_transform().origin, Vector3(0,0,-1)); 
	# at this point, the player's body is always facing the floor belly-first.
	# just need to turn the model 90 more degrees to fix the rotation.
#	set_rotation(Vector3(0, deg2rad(90), 0));

# cast a short ray and call the use() method if the object we hit is usable
func use_thing():
	var ray = self.get_node("yaw/CameraBase/Camera/ray")
	if ray.is_colliding():
		var object = ray.get_collider()
		var type = object.get_meta("type")
		if type == "usable":
#			print("attempting to use ",object," of type ",type," and name ",object.get_meta("name"))
			object.get_node("..").use(self)
	pass
	
# cast a ray (a much longer one than the "use item" ray), call onDeath() if the object being hit is killable
func shoot():
	var gun = self.get_node("yaw/CameraBase/Camera/gun")
	if gun.is_colliding():
		var object = gun.get_collider()
		var type = object.get_meta("type") # spams errors if the object doesn't have a type set, doesn't crash tho
		print("shooting at ",object)
		if type == "killable":
			object.get_node("..").onDeath()
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
	
	if ie is InputEventKey and Input.is_key_pressed(KEY_F):
		OS.window_fullscreen = not OS.window_fullscreen
#		get_node("crosshair/Label").visible = not get_node("crosshair/Label").visible
		pass
		
	if ie is InputEventKey and Input.is_key_pressed(KEY_L):
		flashlight.visible = not flashlight.visible
		pass
	#mouse movement
	#if ie is InputEventMouseMotion:
	#	yaw = fmod(yaw - ie.relative.x * view_sensitivity, 360)
	#	pitch = max(min(pitch - ie.relative.y * view_sensitivity, 90), -90)
	#	set_rotation(Vector3(0, deg2rad(yaw), 0))
	#	camera.set_rotation(Vector3(deg2rad(pitch), 0, 0))