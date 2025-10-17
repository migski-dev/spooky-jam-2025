extends Node3D

var material : Material
func _ready():
	material = $ScreenGlow.get_surface_override_material(0)
	material.emission_enabled = true
	SignalBus.on_game_start.connect(_on_game_start)

func _on_game_start():
	material.emission_enabled = false
