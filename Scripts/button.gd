extends Button

func _ready() -> void:

	self.pressed.connect(self._on_button_pressed)


func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
