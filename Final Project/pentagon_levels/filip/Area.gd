extends Area

var lighten_up = true;
onready var lights = get_node("../shoot_level_pentagon/lights");
onready var mid_light = get_node("../shoot_level_pentagon/mid_light");
onready var skulls = get_node("../skulls");


func _on_Area_body_entered(body):
	if(body.name == "player" && lighten_up):
		lighten_up = false;
		lights.show();
		mid_light.hide();
		skulls.show();
	

