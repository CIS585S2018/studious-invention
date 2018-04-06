extends Spatial

onready var player = get_node("../player");

var timer = 0;
var avg_origin = Vector3();
var cnt = 0;

func _ready():
	set_process(true);
	pass

func _process(delta):
	var pos = player.get_global_transform().origin;
	print(pos);
	var tmp = -pos.normalized();
	look_at_from_position(pos,Vector3(0,0,0),Vector3(0,0,1));
	rotate_object_local(Vector3(1,0,0),-PI/2);
	