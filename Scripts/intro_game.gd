extends CanvasLayer


@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var skip_button: Button = $Control/skip_button  

const MUSIC_PATH = "res://music/music_player.wav"  
const MENU_SCENE_PATH = "res://Scenes/menu.tscn" 

func _ready() -> void:
	# Verify nodes exist
	if animation_player == null:
		print("Error: AnimationPlayer node is null.")
		return

	if audio_stream_player == null:
		print("Error: AudioStreamPlayer node is null.")
		return

	if skip_button == null:
		print("Error: SkipButton node is null.")
		return

	# Load and play music
	load_and_play_music()


	if not skip_button.is_connected("pressed", Callable(self, "_on_skips_pressed")):
		skip_button.connect("pressed", Callable(self, "_on_skips_pressed"))
		print("SkipButton signal connected successfully.")


	if not animation_player.is_connected("animation_finished", Callable(self, "_on_animation_player_animation_finished")):
		animation_player.connect("animation_finished", Callable(self, "_on_animation_player_animation_finished"))
		print("AnimationPlayer 'animation_finished' signal connected successfully.")

func load_and_play_music() -> void:
	# Preload the music stream
	var music_stream = preload(MUSIC_PATH)
	if music_stream == null:
		print("Error: Music file not found.")
		return


	audio_stream_player.stream = music_stream
	print("Music stream loaded successfully.")

	if not audio_stream_player.playing:
		audio_stream_player.play()
		print("Playing music...")


	audio_stream_player.connect("finished", Callable(self, "_on_music_finished"))

func _on_music_finished() -> void:

	audio_stream_player.play()
	print("Music restarted.")

func _on_skips_pressed() -> void:

	print("Skip button pressed.")
	if audio_stream_player != null and audio_stream_player.playing:
		audio_stream_player.stop()


	transition_to_scene(MENU_SCENE_PATH)

func transition_to_scene(scene_path: String) -> void:

	if not ResourceLoader.exists(scene_path):
		print("Error: Scene not found:", scene_path)
		return


	get_tree().change_scene_to_file(scene_path)
	print("Scene transitioned to:", scene_path)


func _on_skip_button_toggled(_button_pressed) -> void:

	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:

	print("Animation finished:", anim_name)
