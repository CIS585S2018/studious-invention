extends KinematicBody
#most of the camera control and movement is taken from a tutorial I found online
var speed = 250
var direction = Vector3()
var gravity = -9.8
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
	
	#if velocity.y > 0:
	#	gravity = -20
	#else:
	#	gravity = -30
	
	var gravity_vec = get_global_transform().origin.normalized() * delta * 10;		
	
	var begin = get_global_transform().origin;
	var end = get_global_transform().origin;
	var mid = get_global_transform().origin;
	var begin2 = get_global_transform().origin;
	var end2 = get_global_transform().origin;
	end.x += 0.2;
	begin.x -= 0.2;
	end2.z += 0.2;
	begin2.z -= 0.2;
	
	"""var im = get_node("../draw");
	im.set_material_override(m);
	im.clear()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	im.add_vertex(begin)
	im.add_vertex(end)
	im.add_vertex(begin2)
	im.add_vertex(end2)
	im.end()
	
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	im.add_vertex(Vector3())
	im.add_vertex(mid)
	im.end()"""
	if is_on_floor():
		velocity.x += direction.x;
		velocity.z += direction.z;
	
	velocity += gravity_vec;
	
	velocity = move_and_slide(velocity,gravity_vec*(-1));
	#set_rotation(gravity_vec);
		
	#jump
	if is_on_floor() and Input.is_key_pressed(KEY_SPACE):
		velocity -= gravity_vec*10;
	if is_on_floor() and  Input.is_key_pressed(KEY_H):
		velocity -= gravity_vec*20;
	
	if is_on_floor():
		print("onfloor");
		#print(get_global_transform().origin);
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