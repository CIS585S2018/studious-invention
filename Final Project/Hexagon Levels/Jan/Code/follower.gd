extends KinematicBody
# ghost model taken from https://www.blendswap.com/blends/view/89905

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed = 0.25
var trigger_distance = 7.5
var player
var moving = false

func onDeath():
	self.queue_free()
	return

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var scene_root = self.get_node("..")
	var sphere_root = scene_root.get_node("..")
	player = sphere_root.get_node("player")
	self.set_meta("type","killable")
	self.set_meta("name","follower")
	pass
	
	
func get_player_dir():
	var player_pos = player.get_global_transform().origin
	var enemy_pos = self.get_global_transform().origin
	return (player_pos - enemy_pos)
	
# start chasing after the player when they come a little closer
func start_moving():
	if moving or (player == null):
		return

	if get_player_dir().length() <= trigger_distance:
		moving = true
		print("boo!")

func _process(delta):
	if not moving:
		start_moving()
		return
	
	var player_origin = player.get_global_transform().origin
	# turn towards the player
	self.look_at(player_origin, -player.gravity_vec)
	# move towards the player slowly
	self.move_and_slide(get_player_dir() * speed, -player.gravity_vec)
