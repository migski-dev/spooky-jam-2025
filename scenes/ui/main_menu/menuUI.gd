extends SubViewportContainer

@onready var viewport = $SubViewport

func _ready():
	stretch = true
	
func _process(_delta):
	# Keep viewport size synced with container
	var container_size = Vector2i(size)
	if viewport.size != container_size:
		viewport.size = container_size
