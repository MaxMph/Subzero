extends Node3D

@export var branch_holders: Array[Node3D] = []
@export var multimesh: MultiMeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in branch_holders:
		for b in i.get_children():
			multimesh.multimesh.instance_count += 1
	
	var index = 0
	for i in branch_holders:
		for b in i.get_children():
			index += 1
			#multimesh.multimesh.instance_count += 1
			#multimesh.multimesh.get_instance_transform(i.global_transform)
			multimesh.multimesh.set_instance_transform(index, multimesh.global_transform.affine_inverse() * b.global_transform)
			#b.queue_free()
			print(b.global_transform)
	
	for i in branch_holders:
		i.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
