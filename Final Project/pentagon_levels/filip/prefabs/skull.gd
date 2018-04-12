extends Area


onready var character = get_tree().get_root().get_node("Node").find_node("player");

func _ready():
	self.set_meta("type", "killable");

func _process(delta):
	if(!is_visible()):
		pass;
	
	var mypos = self.get_translation();
	var dir = (character.get_translation()).normalized();

func onDeath():
	self.queue_free();