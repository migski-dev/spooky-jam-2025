extends Node3D


func _on_area_3d_alpha_trigger_body_exited(body):
	if(body.is_in_group('player')):
		get_tree().get_first_node_in_group('player').start_alpha_video()
