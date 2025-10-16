extends CharacterBody3D

var player = null 
var state_machine 

const SPEED = 2.0
const ATTACK_RANGE = 2.0


@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree: AnimationTree = $SJ25_LP_ANIM_TEXTURED/AnimationTree

func _ready():
	player = get_tree().get_first_node_in_group("player")
	state_machine = anim_tree.get("parameters/playback")
	
func _physics_process(delta):
	match state_machine.get_current_node():
		"IdleTweak":
			anim_tree.set("parameters/conditions/RUN", true)
		"Run":
			velocity = Vector3.ZERO
			
			nav_agent.target_position = player.global_position
			var next_nav_point = nav_agent.get_next_path_position()
			look_at(Vector3(next_nav_point.x, global_position.y, next_nav_point.z), Vector3.UP )
			velocity = (next_nav_point - global_position).normalized() * SPEED
			anim_tree.set("parameters/conditions/ATTACK", target_in_range())
			move_and_slide()
		"Attack":
			anim_tree.set("parameters/conditions/RUN", !target_in_range())
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP )

func target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func check_hit():
	pass


func _on_hit_detection_body_entered(body):
	if body.is_in_group("player"):
		print('player hit')
