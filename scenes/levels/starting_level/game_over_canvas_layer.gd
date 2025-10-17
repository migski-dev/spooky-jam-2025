extends CanvasLayer

signal on_transition_finished
signal on_transition_started
signal on_quit

@onready var background = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	self.visible = false
	background.visible = true
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	#Gameover transition finished, display UI
	if anim_name == "fade_to_black":
		self.visible = true
	elif anim_name == "fade_to_normal":
		background.visible = false
		self.visible = false
		get_tree().reload_current_scene()

#Emit this from GameOver Singleton to start the gameover sequence
func transition():
	on_transition_started.emit()
	self.visible = true
	animation_player.play("fade_to_black")

func _on_retry_button_up() -> void:
	animation_player.play("fade_to_normal")
	on_transition_finished.emit()
	self.visible = false
	background.visible = true

func _on_quit_button_button_up() -> void:
	on_quit.emit()
