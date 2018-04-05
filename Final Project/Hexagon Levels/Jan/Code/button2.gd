extends Spatial

var state = 1
var set1
var set2
var wall_parent

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.get_node("Area").set_meta("type","usable")
	self.get_node("Area").set_meta("name","button")	
	wall_parent = get_node("../walls") #get_tree().get_root().get_node("maze/walls")
	set1 = wall_parent.get_node("generated_maze3")
	set2 = wall_parent.get_node("generated_maze4")
	set1.visible = true
	wall_parent.remove_child(set2) #we don't want the second set yet

func swap_to_2():
	wall_parent.add_child(set2)
	set1.start_animation(true, -1, 0)
	set2.start_animation(false, 1, 30)
	set2.visible = true
	self.get_node("OmniLight").visible = false
	self.translation += Vector3(0, -20, 0)
	pass

func use(object):
	print(object.get_meta("name")," is attempting to use button")
	match(state):
		1:
			swap_to_2()
	state += 1
	pass