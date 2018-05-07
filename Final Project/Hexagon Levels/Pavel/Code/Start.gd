extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Start_body_entered( body ):
	if ( body == get_node("../player") ):
		
		var scene = load("res://Hexagon Levels/Pavel/Assets/NS.tscn")
		var scene_instance = scene.instance()
		scene_instance.set_name("Nightshade")
		
		#var node = load("res://Hexagon Levels/Pavel/Code/NS.gd").new()
		#node.set_name("Nightshade")
		scene_instance.translate(get_node("../StartPoint").translation)
		get_node("../../world").add_child(scene_instance)
		get_node("../Nightshade").start()
		get_node("../RunAway").play()