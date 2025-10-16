class_name LightSwitch
extends InteractableObject

func _ready():
	#Set Base Hint Text or Inherit it from scene instance
	hint_text = "Check the Lights"
	
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
	#TODO play a single switch flick SFX
	#print(self.name + "checked the lights.")
	return
