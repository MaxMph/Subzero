extends MeshInstance3D

#func _process(delta):
	#var mat := multimesh_instance.material_override
	#if mat:
		#mat.set_shader_parameter("global_time", Time.get_ticks_msec() * 0.001)

func _process(delta: float) -> void:
	var material = 
