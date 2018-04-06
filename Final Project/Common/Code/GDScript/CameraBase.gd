extends Spatial

var yaw = 0;
var pitch = 0;
var view_sensitivity = .3;

onready var hands = get_node("hands");
onready var camera = get_node("Camera");
onready var player = get_node("../../player");
onready var hands_sx = hands.translation.x;
onready var hands_sy = hands.translation.y;
onready var hands_sz = hands.translation.z;

var xx = 0;
var yy = 0;
var zz = 0;

var rel_x = 0;
var rel_z = 0;

var mov_shift = Vector3(0,0,0);
var last_mov_shift = Vector3(0,0,0);
var hand_mov_help = 0;

#wep
var mNextAttack = 0.0; 
var mIsFiring = [false,false]; 
onready var mRaycast = [get_node("hands/parts/cold_flow/raycast"),get_node("hands/parts/fire_flow/raycast")];

func _ready():	
	print("x: " + String(hands_sx));
	print("y: " + String(hands_sy));
	print("z: " + String(hands_sz));
	set_process_input(true);
	set_process(true);

func _process(delta):
	
	last_mov_shift = mov_shift;
	mov_shift = player.translation;
	hand_mov_help += (mov_shift-last_mov_shift).length()*0.6;
	
	var hand_mov = sin(hand_mov_help)/32;
	
	hands.set_translation(Vector3(xx+rel_x,yy+hand_mov,zz+rel_z));
	
	if(mNextAttack > 0.0):
		mNextAttack -= delta;
		
	if(mNextAttack <= 0.0 && mIsFiring):
		weaponShoot();
		
	
func weaponShoot():
	"""if(!mIsFiring):
		return; 
		
	mNextAttack = 0.1;
	print("trying to shoot");
	if(mRaycast.is_colliding()):
		print("colliging!");
		var mObject = mRaycast.get_collider() ; 
		var getType = mObject.get_meta("type");
		if(getType == "killable"):
			print("hit");
			mObject.queue_free();
			var trf = Transform();
				
			trf.origin = mRaycast.get_collision_point();	"""	
	pass;
		
	
func _input(event):
	#wep
	
	"""if(event is InputEventMouseButton):
		if(event.is_pressed() && event.button_index == BUTTON_LEFT && !mIsFiring[0]):
			mIsFiring[0] = true ;
			print(mIsFiring[0]);
		if(event.is_pressed() && event.button_index == BUTTON_LEFT && !mIsFiring[1]):
			mIsFiring[1] = true ;
			print(mIsFiring[1]);"""
			
			
			
			
	#if(!event.is_pressed() && mIsFiring):
			#mIsFiring = false;				
	
	#if(Input.is_key_pressed(KEY_R)):
	#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	#if(Input.is_key_pressed(KEY_C)):
	#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);


	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			hands.castLeft();
		if event.button_index == BUTTON_RIGHT:
			hands.castRight();
			
		print("left: ");
		print(mIsFiring[0]);
		print("right: ");
		print(mIsFiring[1]);


	if event is InputEventMouseMotion:
		var yaw_change = event.relative.x * view_sensitivity;
		yaw = fmod(yaw - yaw_change, 360);
		pitch = max(min(pitch - event.relative.y * view_sensitivity, 70), -70);
		camera.set_rotation(Vector3(deg2rad(pitch),deg2rad(yaw),0));
	
		var shift_z = 0;
		var shift_y = 0;
		
		var x_tmp_rot = -deg2rad(pitch);
		if(pitch > 0):
			x_tmp_rot = -deg2rad(pitch);
			shift_z = -deg2rad(pitch/2)/4;
			
		if(pitch > 30):
			shift_y += -deg2rad(pitch-30+pitch/2)/8;
			
		
		xx = hands_sx-(deg2rad(min(0,pitch/2))*0.8+shift_z*1.4)*sin(deg2rad(yaw));
		yy = hands_sy+deg2rad(pitch)/PI+shift_z*0.6+shift_y;
		zz = hands_sz-(deg2rad(min(0,pitch/2))*0.8+shift_z*1.4)*cos(deg2rad(yaw));
		
		hands.set_rotation(Vector3(x_tmp_rot,PI+deg2rad(yaw),0));
		
		var my_cos = cos(deg2rad(yaw_change));
		var my_sin = sin(deg2rad(yaw_change));
		
		var bx = hands_sx+rel_x;
		var bz = hands_sz+rel_z;
		
		rel_x = bx * my_cos - bz * my_sin - hands_sx;
		rel_z = bz * my_cos + bx * my_sin - hands_sz;
		
		hands.set_translation(Vector3(xx+rel_x,yy,zz+rel_z));