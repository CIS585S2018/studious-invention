extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var state = 1
var set1
var set2
var set3
var set4
var wall_parent
var ghost
var ghost_parent

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.get_node("Area").set_meta("type","usable")
	self.get_node("Area").set_meta("name","button")	
	wall_parent = get_tree().get_root().get_node("maze/walls")
	set1 = wall_parent.get_node("maze1") #a set of walls that makes up the first part of the maze
	set2 = wall_parent.get_node("maze2")
	set3 = wall_parent.get_node("generated_maze1")
	set4 = wall_parent.get_node("generated_maze2")
	ghost_parent = get_tree().get_root().get_node("maze")
	ghost = ghost_parent.get_node("follower")
	ghost.translation.y -= 20
	set1.visible = true
	wall_parent.remove_child(set2) #we don't want the second set yet
	wall_parent.remove_child(set3)
	wall_parent.remove_child(set4)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func swap_to_4():
	wall_parent.add_child(set4)
	set4.visible = true
	set3.start_animation(true, -3, 0)
	set4.start_animation(false, 3, 45)
	self.get_node("OmniLight").visible = true
	wall_parent.get_node("../DirectionalLight").visible = false
	ghost_parent.add_child(ghost)
	self.translation.y = -20
	ghost.translation.y += 20

func swap_to_3():
	wall_parent.add_child(set3)
	set2.start_animation(true, -1, 0)
	set3.start_animation(false, 3, 45)
	set3.visible = true
	self.get_node("OmniLight").visible = true
	wall_parent.get_node("../DirectionalLight").visible = false
	wall_parent.get_node("../floor").translation -= Vector3(0,0.5,0)
	self.translation.x = 0
	self.translation.z = 0
	
# swaps to the second set of walls. Code could be much nicer, but a lot of weird stuff happens in each "level"
func swap_to_2():
	wall_parent.add_child(set2)
	set1.start_animation(true, -1, 0)
	set2.start_animation(false, 1, 30)
	set2.visible = true
	self.get_node("OmniLight").visible = false
	self.translation = Vector3(-17.43, 0.475, -3.13)
	pass

func use(object):
	print(object.get_meta("name")," is attempting to use button")
	match(state):
		1:
			swap_to_2()
		2:
			swap_to_3()
		3:
			swap_to_4()
	state += 1
	pass