class_name InteractableObject
extends StaticBody3D

#Interactable Object Parameters
@export var hint_text = "[Set a hint text on the IO child]"
var stop_interacting: bool = false

var player_in_bounds : bool = false
var player_looking_at_object : bool = false
var hint_displayed : bool = false
var activated : bool = false
var player_ref : Player

#Signals
signal player_sees_object
signal player_interaction


func _ready():
	player_ref = get_tree().get_first_node_in_group("player")
	
	#Player Interaction Bound
	$ActivationBound.body_entered.connect(on_body_entered)
	$ActivationBound.body_exited.connect(on_body_exited)
	
	#Player sees object, display UI if in Range
	player_sees_object.connect(on_player_display_ui)
	player_interaction.connect(on_interaction_activated)
	

func _physics_process(_delta: float) -> void:
	pass



func on_body_entered(body):
	if body.is_in_group("player"):
		print("BODY ENTERED")
		player_in_bounds = true
		
func on_body_exited(body):
	if body.is_in_group("player"):
		print("BODY EXITED")
		player_in_bounds = false
		if(hint_displayed):
			player_ref.hide_interaction()
			hint_displayed = false

#When the player interacts with the object
func on_interaction_activated():
	#State-Based-Activation-Logic Example
		#print("is Interactable Object active? - " + str(activated))
		#if(activated == false):
		#	self.global_rotation.y += open_degrees
		#	activated = true
		#else:
		#	self.global_rotation.y -= open_degrees
		#	activated = false
	pass

#When the player is looking at the object, but has not activated it
func on_player_display_ui():
	if player_ref == null:
			player_ref = get_tree().get_first_node_in_group("player")
	
	if player_ref and (stop_interacting == false):
		if(player_in_bounds):
			#print("showing player ui...")
			if(!hint_displayed):
				player_ref.show_interaction(hint_text)
				hint_displayed = true
		else:
			#print("Player reference cannot be found by " + self.name + "_ready() method!")
			return
