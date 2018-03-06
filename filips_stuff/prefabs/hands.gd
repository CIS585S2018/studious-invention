extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var an = get_node("AnimationPlayer");
#var test_yaw = 0;

func _ready():
	an.play("ArmatureAction");
	
func _process(delta):
	if !an.is_playing():
		an.play("ArmatureAction");
		
#func _input(event):		
	"""if(Input.is_key_pressed(KEY_C)):
		test_yaw -= 2;
		
	if(Input.is_key_pressed(KEY_V)):
		test_yaw += 2;
		
	#set_translation((Vector3(0, -0.065057,-3)));
	rotate_object_local(Vector3(0,1,0),deg2rad(2));
	#set_translation((Vector3(0, 0, 0)));"""