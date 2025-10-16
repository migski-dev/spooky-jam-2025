extends Node

signal transition_complete
signal transition_start

var tween: Tween
@onready var camera3d: Camera3D = $Camera3D

var transitioning: bool = false
var player: Player


func _ready():
	camera3d.current = false

func switch_camera(from, to) -> void:
	from.current = false
	to.current = true
	
func transition_camera(from: Camera3D, to: Camera3D, duration: float = 1.0, flashlight_on: bool = true) -> void:
	if transitioning: 
		return
		
	transition_start.emit()	
	
	if(flashlight_on):
		$Camera3D/SpotLight3D.visible = true
	else:
		$Camera3D/SpotLight3D.visible = false

		
	# Copy parameters of source camera
	camera3d.fov = from.fov
	camera3d.cull_mask = from.cull_mask
	
	# Move transition camera to the first camera position
	camera3d.global_transform = from.global_transform
	
	# Make transition camera current
	camera3d.current = true
	transitioning = true

	# Move to dest camera, while also adjusting params to match dest camera
	if tween:
		tween.kill() # garbage collects non-freed tween
		
	tween = create_tween() # creates a tween, object that animates from in between keyframes by interpolation
	tween.set_parallel(true) # allows for tween to animate properties in parallel
	tween.set_ease(Tween.EASE_IN_OUT) # interpolates slowly at start and slowly at the end
	tween.set_trans(Tween.TRANS_CUBIC) # sets transition type
	
	# interpolated animation of global camera's position to the destination camera's position
	tween.tween_property(camera3d ,"global_transform", to.global_transform, duration).from(camera3d.global_transform) 
	# interpolated animation of global camera's fov to the destination camera's fov
	tween.tween_property(camera3d, 'fov', to.fov, duration).from(camera3d.fov) 
	
	await tween.finished
	
	to.current = true
	transitioning = false
	transition_complete.emit()
	
	$Camera3D/SpotLight3D.visible = false
