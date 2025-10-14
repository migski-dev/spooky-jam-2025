class_name Door
extends InteractableObject

#Door Parameters
@export var open_degrees = 90

func _ready():
	#Set Base Hint Text or Inherit it from scene instance
	hint_text = "Open Door"
	
	#get memory reference to player
	player_ref = get_tree().get_first_node_in_group("Player")
	
	#Player Interaction Bound
	$ActivationBound.body_entered.connect(on_body_entered)
	$ActivationBound.body_exited.connect(on_body_exited)
	
	#Player sees object, display UI if in Range
	player_sees_object.connect(on_player_display_ui)
	player_interaction.connect(on_interaction_activated)

#
func _physics_process(_delta: float) -> void:
	pass

#When the player interacts with the object at hand
func on_interaction_activated():
	#State-Based-Activation-Logic
	print("is Interactable Object active? - " + str(activated))
	if(activated == false):
		self.global_rotation.y += open_degrees
		activated = true
		hint_text = "Close Door"
		player_ref.show_interaction(hint_text)
	else:
		self.global_rotation.y -= open_degrees
		activated = false
		hint_text = "Open Door"
		player_ref.show_interaction(hint_text)
