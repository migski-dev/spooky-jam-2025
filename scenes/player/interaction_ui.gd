extends Control

func _ready():
	self.visible = false

func _on_video_stream_player_finished():
	self.visible = false
	print('ALPHA FINISHED ')

func start_hallucination():
	self.visible = true
	#$VideoStreamPlayer.stream = load(video_path)
	$VideoStreamPlayer.play()
