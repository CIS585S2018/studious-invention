extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var triggered
var completed
var wall

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	triggered = false
	completed = false
	wall = get_node("../Wall")
	wall.visible = false
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _on_Area_area_entered(area):
	if(completed == false): 
		triggered = true
		wall.visible = true
		wall.scale.y = 3
		print("Area has been entered")
	pass # replace with function body
