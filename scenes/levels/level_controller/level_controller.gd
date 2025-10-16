extends Node3D

class_name Level

@export var cutscene_packed: Resource = preload("res://scenes/cutscene/cutscene.tscn")
@export var next_level_path: String = "res://scenes/levels/test_level/test2.tscn"
@export var camera_transition_time: float = 3
@export var is_starting_level: bool = false
# Change this to the correct trigger Node 
@export var end_trigger: Area3D

@export var main: Node3D
@export var player: Player 
@onready var transition_camera: Camera3D = $Camera3D
@onready var start_position: Marker3D = $StartPosition

func _ready() -> void: 
	# Change body_entered to the correct signal from the end_trigger node
	end_trigger.body_entered.connect(_on_area_3d_body_entered) 
	
	if is_starting_level:
		main = get_tree().get_first_node_in_group('main')
		player = get_tree().get_first_node_in_group('player')
	else:
		main = get_tree().get_first_node_in_group('main')
		player = get_tree().get_first_node_in_group('player')
		player.position = start_position.global_position

func _on_area_3d_body_entered(body)-> void:
	if main == null:
		print_debug('MAIN NOT CONFIGURED ON LEVEL')
		return
	if player == null:
		print_debug('PLAYER NOT CONFIGURED ON LEVEL')
		return
		
	if body.is_in_group('player'):
		# Transition the camera		
		print('asdfasdf')
		CameraManager.transition_camera(player.camera, transition_camera, camera_transition_time)
		await CameraManager.transition_complete
		call_deferred("play_end_cutscene") 

func play_end_cutscene() -> void:
	var cutscene = cutscene_packed.instantiate()
	cutscene.scene_name = next_level_path
	main.add_child(cutscene)
	get_parent().queue_free()
	
