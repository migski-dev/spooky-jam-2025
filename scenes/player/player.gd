class_name Player
extends CharacterBody3D

#Parameters -
#@export var SPEED = 
@export var SPEED = 8
@export var MOUSE_SENSITIVITY = 0.003
const MIN_CAMERA_X_PITCH = deg_to_rad(-80)
const MAX_CAMERA_X_PITCH = deg_to_rad(80)
const GRAVITY = 9.8
#local variables -
var looking_at_interactable_object : bool = false

@export var random_strength: float = 0.05 
@export var shake_fade: float = 2.0

@onready var camera = $Camera3D
@onready var flashlight = $SpotLight3D
@onready var hint_ui = $UI/HintUI
@onready var interaction_ui = $UI/InteractionUI
@onready var bgm_audio: AudioStreamPlayer = $AI_Audio
@onready var ambiance_audio: AudioStreamPlayer = $Ambiance_Audio

var rng := RandomNumberGenerator.new()
var shake_strength: float = 0.0

var tween: Tween

var turned_on_flashlight = false

func _ready():
	CameraManager.transition_start.connect(_on_transition_start)
	CameraManager.transition_complete.connect(_on_transition_end)
	SignalBus.on_game_start.connect(_on_game_start)
	SignalBus.on_player_hit.connect(_on_player_hit)
	flashlight.visible = false
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED:

		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, MIN_CAMERA_X_PITCH,MAX_CAMERA_X_PITCH)
			
			if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
				return  # Don't process input when mouse is free
			
		#Keyboard Input	
		if(Input.is_action_just_pressed("Flashlight")):
			if(turned_on_flashlight == false):
				turned_on_flashlight = true
				hint_ui.display_hint("Movement", "WASD")
				
				
			if(flashlight.visible == false):
				flashlight.visible = true
				#print("Player Flashlight enabled!")
			else:
				flashlight.visible = false
				#print("Player Flashlight disabled!")
				
		if(Input.is_action_just_pressed("Interact")):
			var space = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(global_position, global_position - global_transform.basis.z * 1000)
			var result = space.intersect_ray(query)
			
			#Checks for Interactable Objects
			if result and result.collider.has_signal("player_interaction"):
				result.collider.emit_signal("player_interaction")

func play_tweak():
	$Tweak_Audio.play()


func _physics_process(delta):
	
	#Mouse Input - Camera & Flashlight rotation
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Move Player
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0
	
	#Make the Flashlight face the player's camera rotation
	flashlight.rotation.x = camera.rotation.x
	
	#Player casts ray in front of them
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position - global_transform.basis.z * 1000)
	var result = space.intersect_ray(query)
	
	#Checks for Interactable Objects fff5c6
	if result and result.collider.has_signal("player_sees_object"):
		result.collider.emit_signal("player_sees_object")
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	move_and_slide()

#When Player looks at an interactable object
func show_interaction(text):
	$UI/InteracableObjectUI.visible = true
	$UI/InteracableObjectUI/Label.text = text

#When Player stops looking at an interactable object
func hide_interaction():
	$UI/InteracableObjectUI.visible = false
	
func _on_transition_start():
	flashlight.visible = false

func _on_transition_end():
	camera.current = true
	flashlight.visible = true
	
func _on_game_start():
	hint_ui.display_hint("Flashlight", "Press F to toggle")
	
func start_alpha_video():
	interaction_ui.start_hallucination()
	
func play_ambiance() -> void:
	ambiance_audio.play()
	

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		camera.h_offset = random_offset()
		camera.v_offset = random_offset()


func apply_shake() -> void:
	shake_strength = random_strength

func random_offset() -> float:
	return rng.randf_range(-shake_strength, shake_strength)
	
func _on_player_hit(): 
	apply_shake()
	
