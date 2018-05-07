extends KinematicBody

var begin = Vector3()
var end = Vector3()

var speed = 100
var direction = Vector3()
var gravity = -9.8
var velocity = Vector3()
var started = false
var an
var root
var player

func start():
	started = true
	an.play("default")

func _process(delta):
	if !started:
		return
		
	var player_origin = player.get_global_transform().origin
	var player_relative = root.get_global_transform().origin - player.get_global_transform().origin
	if (get_global_transform().origin.distance_to(player_relative) < 1.5):
		get_node("../End").show()
		#get_node("../player").end()
		started = false
		an.stop()
	
	var map = root.get_node("Map")
	var my_trans = translation
	var path = map.get_simple_path(my_trans,player_relative)
	if (path.size() > 1):
		direction = path[1] - path[0]
		direction = direction.normalized()
		direction = direction * speed * delta
		
		if velocity.y > 0:
			gravity = -20
		else:
			gravity = -30
		velocity.y += gravity * delta
		velocity.x = direction.x
		velocity.z = direction.z
	
		velocity = move_and_slide(velocity, Vector3(0, 1, 0))
		
		var atpos
		if path.size() > 3 && path[3] != null: 
			atpos = path[3]
			look_at(atpos, Vector3(0,1,0))
			rotate(Vector3(0,1,0), deg2rad(180))
		
	pass

func _ready():
	an = get_node("walkinplace")
	root = get_node("../../world")
	#player = get_node("../player")
	#player = get_tree().get_root().get_node("world/player")
	player = get_tree().get_root().get_node("Node/player")
	pass