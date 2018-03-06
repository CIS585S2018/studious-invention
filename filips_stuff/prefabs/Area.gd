extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var character = get_node("../../PlayerBase");

func _ready():
	self.set_meta("type", "killable");
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if(!is_visible()):
		pass;
	
	var mypos = self.get_translation();
	var dir = (character.get_translation()).normalized();

	