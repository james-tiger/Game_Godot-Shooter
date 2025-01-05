extends Button

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# تأكد من أن الزر متصل بالإشارة الصحيحة
	self.pressed.connect(self._on_button_pressed)

# دالة لتعامل مع الضغط على الزر
func _on_button_pressed() -> void:
	# التحقق مما إذا كانت اللعبة في حالة إيقاف مؤقت
	if get_tree().paused:
		get_tree().paused = false  # استئناف اللعبة
		print("Game resumed")
	else:
		get_tree().paused = true   # إيقاف اللعبة
		print("Game paused")
	
	# تغيير المشهد إلى المشهد الجديد
	var scene_path = "res://Scenes/World.tscn"
	var dir = DirAccess.open("res://")  # فتح المسار للتأكد من وجود المشهد
	if dir != null and dir.file_exists(scene_path):
		get_tree().change_scene(scene_path)
	else:
		print("Scene not found: " + scene_path)  # إذا لم يتم العثور على المشهد، يتم طباعة خطأ
