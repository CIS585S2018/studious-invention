extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var entered
var NS
var root

func _ready():
	entered = false
	root = get_node("../../world")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_EndState_body_entered( body ):
	if ( body.name == "player" ):#get_tree().get_root().get_node("player") ):
		if (root.entered):
			entered = false
			NS.queue_free()
		else:
			entered = true
			var scene = load("res://Hexagon Levels/Pavel/Assets/NS.tscn")
			NS = scene.instance()
			NS.set_name("Nightshade")
			
			#var node = load("res://Hexagon Levels/Pavel/Code/NS.gd").new()
			#node.set_name("Nightshade")
			var nextExit = get_node("../NSPoint" + str(name[-1].to_int()))
			
			#var nextExit_origin = nextExit.get_global_transform().origin
			var nextExit_origin = nextExit.translation
			
			#NS.get_global_transform().origin = nextExit_origin
			NS.translate(nextExit_origin)
			root.add_child(NS)
			NS.start()
			
			var runaway = get_node("../RunAway")
			runaway.translate(nextExit_origin)
			runaway.play()

func _on_EndState_body_exited(body):
	pass
