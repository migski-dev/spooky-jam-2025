class_name ElectricalPanel
extends InteractableObject

signal on_panel_interacted()

#Electrical Panel Parameters
@export var open_degrees = 40

# 0 = Open Electrical Panel | 1 = Flip Breaker On | 2 = Close Electrical Panel
var activation_stage = 0

func _ready():
	#Set Base Hint Text or Inherit it from scene instance
	hint_text = "Open Electrical Panel"
	
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
	#print("is Interactable Object active? - " + str(activated))
	match activation_stage:
		0:
			$Meshes/EP_Hinge.global_rotation.y -= open_degrees
			hint_text = "Turn on Breaker"
			activation_stage = 1
			player_ref.show_interaction(hint_text)
			on_panel_interacted.emit()
		1:
			hint_text = "Close Electrical Panel"
			activation_stage = 2
			player_ref.show_interaction(hint_text)
		2:
			$Meshes/EP_Hinge.global_rotation.y += open_degrees
			stop_interacting = true
			hint_text = ""
			player_ref.show_interaction(hint_text)
			activation_stage = 3
		3:
			return
		
