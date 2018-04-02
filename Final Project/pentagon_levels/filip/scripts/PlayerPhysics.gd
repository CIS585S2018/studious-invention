extends RigidBody

#PlayerPhysics class

const moveSpeed = 90.0; 
const jumpForce = 20.0;

var m_justJumping = false;
var mCamera; 
var meshWeapon;

func _ready():
	mCamera = get_node("CameraBase"); 

func _integrate_forces(state):
	 
	var mMoveDir = calculate_move_dir(); 
	mMoveDir = state.get_linear_velocity().linear_interpolate(mMoveDir, 8.0 * state.get_step());
	mMoveDir.y = state.get_linear_velocity().y;
	
	if(Input.is_key_pressed(KEY_F10)):
		get_tree().quit();
	
	if(Input.is_key_pressed(KEY_F4)):
		OS.window_fullscreen = not OS.window_fullscreen;
	
	if(Input.is_key_pressed(KEY_SPACE)):
		if(!m_justJumping):
			mMoveDir.y = jumpForce; 
			m_justJumping = true;
	else :
		if(m_justJumping):
			m_justJumping = false; 	
		 
	
	#mPlayerBase.linear_velocity = mMoveDir; 
	state.set_linear_velocity(mMoveDir);
	 
	
	
func calculate_move_dir():
	var steer = float(Input.is_key_pressed(KEY_D))-float(Input.is_key_pressed(KEY_A));
	var straight = float(Input.is_key_pressed(KEY_S))-float(Input.is_key_pressed(KEY_W));
	print(mCamera.get_camera_basis());
	return mCamera.get_camera_basis().xform(Vector3(steer,0,straight).normalized())*moveSpeed;
  
		
	