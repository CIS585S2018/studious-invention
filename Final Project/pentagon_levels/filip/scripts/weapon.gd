extends Node
var mNextAttack; 
var mIsFiring; 
var mRaycast;

func _ready():
	mNextAttack = 0.0; 
	mIsFiring = false; 
	mRaycast = self.get_node("raycast");
		
func _input(event):
	if(event is InputEventMouseButton):
		if(event.is_pressed() && event.button_index == BUTTON_LEFT && !mIsFiring):
			mIsFiring = true ;
			
	if(!event.is_pressed() && mIsFiring):
			mIsFiring = false;				
		
		
	
	
func _process(delta):
	if(mNextAttack > 0.0):
		mNextAttack -= delta;

func _physics_process(delta):
	if(mNextAttack <= 0.0 && mIsFiring):
		weaponShoot();
	
			
func weaponShoot():
	if(!mIsFiring):
		return; 
		
	mNextAttack = 0.1;
	
	if(mRaycast.is_colliding()):
		print("colliging!");
		var mObject = mRaycast.get_collider() ; 
		var getType = mObject.get_meta("type");
		if(getType == "killable"):
			print("hit");
			mObject.queue_free();
			var trf = Transform();
				
			trf.origin = mRaycast.get_collision_point();		
		
		
 

 

