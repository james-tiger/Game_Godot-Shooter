extends CharacterBody3D

var player = null
var state_machine
var health = 8

signal zombie_hit

const SPEED = 4.5
const ATTACK_RANGE = 2.0

@export var player_path := "/root/World/Map/NavigationRegion3D/Player"
@onready var attack_sound = $attack_sound
@onready var getup_sound = $getup_sound
@onready var die_sound = $die_sound
@onready var run_sound = $run_sound

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)  # تأكد من تعيين اللاعب
	state_machine = anim_tree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO

	# تأكد من أن اللاعب تم تعيينه بشكل صحيح قبل الوصول إلى global_position
	if player != null:
		match state_machine.get_current_node():
			"Run":
				# Play running sound if not already playing
				if !$run_sound.playing:  # Check if sound is already playing
					$run_sound.stream = run_sound
					$run_sound.play()
				# Navigation
				nav_agent.set_target_position(player.global_transform.origin)
				var next_nav_point = nav_agent.get_next_path_position()
				velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
				rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
			"Attack":
				# Play attack sound if not already playing
				if !$attack_sound.playing:  # Check if sound is already playing
					$attack_sound.stream = attack_sound
					$attack_sound.play()
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			"GetUp":
				# Play get up sound if not already playing
				if !$getup_sound.playing:  # Check if sound is already playing
					$getup_sound.stream = getup_sound
					$getup_sound.play()
			"Die":
				# Play die sound if not already playing
				if !$die_sound.playing:  # Check if sound is already playing
					$die_sound.stream = die_sound
					$die_sound.play()
		
		# Conditions
		anim_tree.set("parameters/conditions/attack", _target_in_range())
		anim_tree.set("parameters/conditions/run", !_target_in_range())

		move_and_slide()
	else:
		print("Player not found")

# This function checks if the target (player) is within range for an attack
func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

# When the hit is finished, damage the player if within range
func _hit_finished():
	if player != null and global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)

# Handle zombie hit and health reduction
func _on_area_3d_body_part_hit(dam):
	health -= dam
	emit_signal("zombie_hit")
	if health <= 0:
		anim_tree.set("parameters/conditions/die", true)
		await get_tree().create_timer(4.0).timeout
		queue_free()
