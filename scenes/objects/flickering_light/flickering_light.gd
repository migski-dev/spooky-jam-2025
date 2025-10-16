extends OmniLight3D

var rng = RandomNumberGenerator.new()
@export var noise: FastNoiseLite
var max_energy: float

func _ready():
	max_energy = light_energy

func _process(delta):
	#visible = rng.randf() > 0.9
	var x = noise.get_noise_1d(Time.get_ticks_msec())
	light_energy = clamp(x, 0 , max_energy)
