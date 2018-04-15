extends KinematicBody
# ghost model taken from https://www.blendswap.com/blends/view/89905

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed = 0.25
var trigger_distance = 5
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
	
	
func get_distance():
	var player_pos = player.translation
	var my_pos = self.translation
	var dir = player_pos - my_pos
	return dir.length()
	
# start chasing after the player when they come a little closer
func start_moving():
	if moving or (player == null):
		return
		
	# broken in 3d sphere
	if get_distance() <= trigger_distance:
		moving = true

func _process(delta):
#	start_moving()
#	if not moving:
#		return	
#	print(get_distance())
	
	var player_origin = player.get_global_transform().origin
	var enemy_origin = self.get_global_transform().origin
	var direction = player_origin - enemy_origin
#	print(enemy_origin, player_origin, direction)
	# turn towards the player
	self.look_at(player_origin, -player.gravity_vec)
	# move towards the player slowly
	self.move_and_slide(direction * speed, -player.gravity_vec)
	pass
