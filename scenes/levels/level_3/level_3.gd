extends Node3D

@onready var boss = $NavigationRegion3D/BossAi
var player

func _ready():
	get_tree().get_first_node_in_group('player').bgm_audio.fade_in_layer(1)
	player = get_tree().get_first_node_in_group('player')

#func _process(delta):
	#if player != null:
		#if boss.chase_state == true:
			#if player.global_position.y > -0.3 and boss.is_downstairs:
				#boss.global_position = $UpSpawn.global_position
				#boss.is_downstairs = true
			#if player.global_position.y > -2.694 and !boss.is_downstairs:
				#boss.global_position = $DownSpawn.global_position
				#boss.is_downstairs = false
		


func _on_area_3d_2_ai_start_body_entered(body):
	if body.is_in_group('player'):
		boss.chase_state = true
		boss.can_play = true
		boss.play_voice_lines()
		get_tree().get_first_node_in_group('player').bgm_audio.fade_layer(2, 1.0)
