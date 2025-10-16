extends Node3D

func _ready():
	SignalBus.on_game_start.connect(_on_game_start)

func _on_game_start():
	var material: Material = $ScreenGlow.get_surface_override_material(0)
	material.emission_enabled = false
