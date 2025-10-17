extends CharacterBody3D

var player = null 
var state_machine 
var chase_state = false
var is_downstairs = true

const SPEED = 2.0
const ATTACK_RANGE = 2.0

@export var min_interval: float = 2.0 
@export var max_interval: float = 5.0
@export var voice_line_arr: Array[AudioStream] = []

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree: AnimationTree = $SJ25_LP_ANIM_TEXTURED2/AnimationTree
@onready var voiceline_player: AudioStreamPlayer3D = $Voicelines

var can_play: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	state_machine = anim_tree.get("parameters/playback")
	
func _physics_process(delta):
	match state_machine.get_current_node():
		"IdleTweak":
			anim_tree.set("parameters/conditions/RUN", chase_state)
		"Run":
			if can_play:
				play_voice_lines()
				
			velocity = Vector3.ZERO
			nav_agent.target_position = player.global_position
			var next_nav_point = nav_agent.get_next_path_position()
			look_at(Vector3(next_nav_point.x, global_position.y, next_nav_point.z), Vector3.UP )

			velocity = (next_nav_point - global_position).normalized() * SPEED
			#velocity =  SPEED * Vector3((next_nav_point - global_position).normalized().x, velocity.y - 9.8*delta, (next_nav_point - global_position).normalized().z)
			anim_tree.set("parameters/conditions/ATTACK", target_in_range())

			move_and_slide()
		"Attack":
			anim_tree.set("parameters/conditions/RUN", !target_in_range())
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP )

func target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func check_hit():
	pass


func play_voice_lines():
	if not chase_state:
		return
	var chosen_line: AudioStream = voice_line_arr[randi()% voice_line_arr.size()]
	voiceline_player.stream = chosen_line
	voiceline_player.play()
	can_play = false
	var wait_time = chosen_line.get_length() + randf_range(min_interval, max_interval)
	await get_tree().create_timer(wait_time).timeout
	can_play = true
	
	


func _on_hit_detection_body_entered(body):
	if body.is_in_group("player"):
		print('HITTTTTTTTTTTTTTTTTTT')
		SignalBus.on_player_hit.emit()
