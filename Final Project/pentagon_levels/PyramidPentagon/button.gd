extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var wall

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.get_node("Area").set_meta("type","usable")
	self.get_node("Area").set_meta("name","button")	
	wall = get_node("../../PentagonWall/Wall")
	wall.visible = false
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func use(object):
	print(object.get_meta("name")," is attempting to use button")
	#player.translation = teleport_spot.translation
	wall.scale.y = 0
	wall.visible = false
	get_node("../../PentagonWall/Area").completed = true
	pass