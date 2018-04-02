extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var lights_flicker = 10;
var timer = 0;
var next_wait = 0.1;
onready var mylights = [get_node("SpotLight"),get_node("SpotLight2"),get_node("SpotLight3"),get_node("SpotLight4"),get_node("SpotLight5")];
var can_perform = false;

func _ready():
	randomize();
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if(is_visible()):
		can_perform = true;
	if(can_perform):
		timer += delta;
			
		if(timer > next_wait):
			timer = 0;
			lights_flicker -= 1;
			next_wait = rand_range(0.05, 0.2);
			
			if(is_visible()):
				self.hide();
			else:
				self.show();
			
		if(lights_flicker <= 0):
			self.queue_free();