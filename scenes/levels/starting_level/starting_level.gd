extends Node3D
@onready var camera = $MainMenuCanvasLayer/AspectRatioContainer/SubViewportContainer/SubViewport/Camera3D
@onready var monitor_model = $PC2/Monitor
@onready var menu_ui = $MainMenuCanvasLayer/AspectRatioContainer/SubViewportContainer

@onready var screen_top_left = $PC2/Monitor/top_left.position  # 3D position relative to monitor
@onready var screen_bottom_right = $PC2/Monitor/bot_right.position

@onready var living_room_light = $LivingRoomLight


func _ready():
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_update_ui_positioning()
	SignalBus.on_game_start.connect(_on_game_start)
	

func _on_game_start():
	get_tree().get_first_node_in_group('main').in_main_menu = false
	
	for light in get_tree().get_nodes_in_group("light"):
		light.visible = false
		
	get_tree().get_first_node_in_group('player').play_ambiance()

func _on_viewport_size_changed():
	print('viewport size changed')
	_update_ui_positioning()
	
func _update_ui_positioning():
	# Get the four corners of the screen in 3D space (world coordinates)
	var top_left_world = monitor_model.global_transform * screen_top_left
	var top_right_world = monitor_model.global_transform * Vector3(screen_bottom_right.x, screen_top_left.y, screen_top_left.z)
	var bottom_left_world = monitor_model.global_transform * Vector3(screen_top_left.x, screen_bottom_right.y, screen_bottom_right.z)
	var bottom_right_world = monitor_model.global_transform * screen_bottom_right
	
	# Project 3D points to 2D screen space
	var top_left_2d = camera.unproject_position(top_left_world)
	var top_right_2d = camera.unproject_position(top_right_world)
	var bottom_left_2d = camera.unproject_position(bottom_left_world)
	var bottom_right_2d = camera.unproject_position(bottom_right_world)
	
	# Calculate the bounding rectangle
	var min_x = min(top_left_2d.x, min(top_right_2d.x, min(bottom_left_2d.x, bottom_right_2d.x)))
	var max_x = max(top_left_2d.x, max(top_right_2d.x, max(bottom_left_2d.x, bottom_right_2d.x)))
	var min_y = min(top_left_2d.y, min(top_right_2d.y, min(bottom_left_2d.y, bottom_right_2d.y)))
	var max_y = max(top_left_2d.y, max(top_right_2d.y, max(bottom_left_2d.y, bottom_right_2d.y)))
	
	# Update SubViewportContainer position and size
	menu_ui.position = Vector2(min_x, min_y)
	menu_ui.size = Vector2(max_x - min_x, max_y - min_y)


func _on_area_3d_light_trigger_body_entered(body):
	if body.is_in_group('player'):
		living_room_light.visible = true


func _on_area_3d_whisper_trigger_body_entered(body):
	if body.is_in_group('player'):
			living_room_light.visible = false
			$Audio_Whispers.play()
			
func _on_door_opened():
	$Audio_Whispers.stop()
			
func _on_area_3d_hint_prompt_body_entered(body):
	if body.is_in_group('player'):
		get_tree().get_first_node_in_group('player').hint_ui.display_hint("Restore Power", "reset breaker in basement")
