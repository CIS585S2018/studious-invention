extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var lighten_up = true;
onready var lights = get_node("../polygon_shoot_level/lights");
onready var mid_light = get_node("../polygon_shoot_level/mid_light");
onready var skulls = get_node("../skulls");

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area_body_entered( body ):
	if(body.name == "player" && lighten_up):
		lighten_up = false;
		lights.show();
		mid_light.hide();
		skulls.show();
	pass # replace with function body
