extends Node3D


@onready var dialogue_ui: Control = $DialogueUi

@onready var dialogue_triggered: bool = false

func _ready():
	get_tree().get_first_node_in_group('player').bgm_audio.restart_playback()

func _on_area_3d_alpha_trigger_body_exited(body):
	if(body.is_in_group('player')):
		get_tree().get_first_node_in_group('player').start_alpha_video()
		get_tree().get_first_node_in_group('player').play_tweak()



func _on_area_3d_2_dialogue_trigger_body_entered(body):
	if(body.is_in_group('player') and dialogue_triggered != true):
		dialogue_triggered = true
		dialogue_ui.start_text("error: brain-computer interface link corrupted", 0.05)
