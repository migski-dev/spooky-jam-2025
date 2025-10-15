class_name Player
extends CharacterBody3D

#Parameters -
@export var SPEED = 3.0
@export var MOUSE_SENSITIVITY = 0.003
const MIN_CAMERA_X_PITCH = deg_to_rad(-80)
const MAX_CAMERA_X_PITCH = deg_to_rad(80)
const GRAVITY = 9.8
#local variables -
var looking_at_interactable_object : bool = false

@onready var camera = $Camera3D
@onready var flashlight = $SpotLight3D

func _ready():
	CameraManager.transition_start.connect(_on_transition_start)
	CameraManager.transition_complete.connect(_on_transition_end)
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
	
	#Checks for Interactable Objects
	if result and result.collider.has_signal("player_sees_object"):
		result.collider.emit_signal("player_sees_object")
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	move_and_slide()

#When Player looks at an interactable object
func show_interaction(text):
	$UI/InteractionUI/Label.text = text
	$UI/InteractionUI.visible = true

#When Player stops looking at an interactable object
func hide_interaction():
	$UI/InteractionUI.visible = false
	
func _on_transition_start():
	flashlight.visible = false

func _on_transition_end():
	camera.current = true
	flashlight.visible = true
