extends Node3D

var max_size = 1

func _ready() -> void:
	$Sprite3D.rotation.z = randf_range(0, 360)
	$Sprite3D.scale = Vector3(max_size, max_size, max_size)


func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
