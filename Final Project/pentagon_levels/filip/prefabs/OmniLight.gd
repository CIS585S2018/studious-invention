extends OmniLight

var starting_position;
var change_in_y = 0;
var change_in_x = 0;
var change_in_z = 0;
var sin_help = 0;

func _ready():
	starting_position = get_translation ();
	pass

func _process(delta):
	set_translation(Vector3(starting_position.x+change_in_x,starting_position.y+change_in_y,starting_position.z+change_in_z));
	sin_help += PI*2*delta/4;
	change_in_y = sin(sin_help)*2;
	pass
