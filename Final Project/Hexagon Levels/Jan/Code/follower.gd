extends KinematicBody
# ghost model taken from https://www.blendswap.com/blends/view/89905

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed = 0.5
var trigger_distance = 5
var player
var moving = false

func onDeath():
	self.queue_free()
	return

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("../player")
	self.get_node("Area").set_meta("type","killable")
	self.get_node("Area").set_meta("name","follower")
	pass
	
# start chasing after the player when they come a little closer
func start_moving():
	if moving:
		return
	var player_pos = player.translation
	var my_pos = self.translation
	var dir = player_pos - my_pos
	var dist = dir.length()
#	print(dist)
	if dist <= trigger_distance:
		moving = true

func _process(delta):
	start_moving()
	if not moving:
		return
	
	# move towards the player slowly
	var player_origin = player.get_global_transform().origin
	var enemy_origin = self.get_global_transform().origin
	var direction = player_origin - enemy_origin
	direction.y = 0
	self.move_and_slide(direction * speed, Vector3(0,1,0))
	# turn towards the player
	self.look_at(player_origin, Vector3(0,1,0))
	pass
