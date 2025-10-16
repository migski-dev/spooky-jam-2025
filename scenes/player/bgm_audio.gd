extends AudioStreamPlayer

@export var fade_duration: float = 2.0

const VOLUME_SILENT = -80.0
const VOLUME_FULL = 0.0

var layer_states = [true, false, false]

var tween: Tween
var layer_count = 1


func _ready():
	var sync_stream = AudioStreamSynchronized.new()
	sync_stream.stream_count = 3
	
	sync_stream.set_sync_stream(0, preload("res://assets/bgm/Layer 1 - AI Encounter.ogg"))
	sync_stream.set_sync_stream(1, preload("res://assets/bgm/Layer 2 - AI Encounter.ogg"))
	sync_stream.set_sync_stream(2, preload("res://assets/bgm/Layer 3 - AI Encounter.ogg"))
	
	sync_stream.set_sync_stream_volume(0, VOLUME_FULL)
	sync_stream.set_sync_stream_volume(1, VOLUME_SILENT)
	sync_stream.set_sync_stream_volume(2, VOLUME_SILENT)
	
	stream = sync_stream
	#play()
	
func toggle_layer(layer_index: int):
	layer_states[layer_index] = !layer_states[layer_index]
	
	if layer_states[layer_index]:
		fade_layer(layer_index, VOLUME_FULL)
		print("fading in layer ", layer_index + 1)
		
func fade_layer(layer_index: int, target_volume: float):
	var sync_stream = stream as AudioStreamSynchronized
	if not sync_stream:
		print("AudioStreamPlayer doesn't have an AudioStreamSynchronized stream")
		return
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	# Get current volume
	var current_volume = sync_stream.get_sync_stream_volume(layer_index)
	
	# Animate the volume change
	tween.tween_method(
		func(vol): sync_stream.set_sync_stream_volume(layer_index, vol),
		current_volume,
		target_volume,
		fade_duration
	)

func _exit_tree():
	# Clean up tween when node is removed
	if tween:
		tween.kill()
		
func fade_in_layer(layer_index: int):
	if layer_index >= 0 and layer_index < 3:
		layer_states[layer_index] = true
		fade_layer(layer_index, VOLUME_FULL)

func fade_out_layer(layer_index: int):
	if layer_index >= 0 and layer_index < 3:
		layer_states[layer_index] = false
		fade_layer(layer_index, VOLUME_SILENT)

func set_layer_volume_immediate(layer_index: int, _volume_db: float):
	"""Set layer volume immediately without fading"""
	var sync_stream = stream as AudioStreamSynchronized
	if sync_stream and layer_index >= 0 and layer_index < 3:
		sync_stream.set_sync_stream_volume(layer_index, _volume_db)


func restart_playback():
	play(0.0)

func _input(event):
	if(Input.is_action_just_pressed("Flashlight")):
		toggle_layer(layer_count)
		layer_count = layer_count+1
