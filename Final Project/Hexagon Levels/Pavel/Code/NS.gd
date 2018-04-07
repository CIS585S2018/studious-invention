extends KinematicBody

var begin = Vector3()
var end = Vector3()

var speed = 75
var direction = Vector3()
var gravity = -9.8
var velocity = Vector3()
var started = false
var an

func start():
	started = true
	an.play("default")

func _process(delta):
	if !started:
		return
		
	var player = get_node("../player")
	if (get_translation().distance_to(player.get_translation()) < 1.5):
		get_node("../End").show()
		get_node("../player").end()
		started = false
		an.stop()
		
	var path = get_node("../Map").get_simple_path(get_translation(),player.get_translation())
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
	pass