extends AspectRatioContainer

class_name Cutscene

var scene_name 
var progress = []
var scene_load_status = 0 
var is_video_finished = false

func _ready() -> void: 
	ResourceLoader.load_threaded_request(scene_name)

func _process(delta) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	$Label.text = str(floor(progress[0]*100)) + "%"
	if( scene_load_status == ResourceLoader.THREAD_LOAD_LOADED && is_video_finished):
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		#get_tree().change_scene_to_packed(new_scene)
		get_tree().get_first_node_in_group("main").add_child(new_scene.instantiate())
		queue_free()

func _on_video_stream_player_finished():
	is_video_finished = true
