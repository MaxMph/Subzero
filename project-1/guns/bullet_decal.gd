extends Node3D

var scale_randomization = 1.0
var fade_speed = 0.6

var start_fade = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.01).timeout#Engine.get_process_frames()
	$CPUParticles3D.emitting = true
	#lobal_scale()
	var parent_scale = get_parent().global_transform.basis.get_scale()
	$MeshInstance3D.scale = Vector3(
	0.15 / parent_scale.x,
	0.15 / parent_scale.y ,
	0.15 / parent_scale.z
	)
	#$MeshInstance3D.set_disable_scale(true)
	#$MeshInstance3D.rotation.x = deg_to_rad(randi_range(0, 4) * 90)
	#var rand_scale = randf_range(1.0, scale_randomization)
	#scale = Vector3(rand_scale, rand_scale, rand_scale)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $MeshInstance3D.transparency < 1.0 and start_fade == true:
		$MeshInstance3D.transparency += delta * fade_speed


func _on_timer_timeout() -> void:
	start_fade = true
