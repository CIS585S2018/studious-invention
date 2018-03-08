extends Spatial

var positions = [[Vector3(83,.5,0),Vector3(83,.5,-18)],
				 [Vector3(-47,.5,20),Vector3(-40,.5,15)]]
var rotations = [[0,0],[0,61]]
var state = 0

func _ready():
	pass
	


func _on_Timer_timeout():
	self.get_child(0).translation=positions[0][state]
	self.get_child(1).translation=positions[1][state]
	self.get_child(1).rotation_degrees=Vector3(0,rotations[1][state],0)
	
	state += 1
	if (state >= 2):
		state = 0
