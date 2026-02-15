extends Node3D

@export var blood_splatter: PackedScene

func hit(dmg, bullet):
	
	var splatter = blood_splatter.instantiate()
	get_tree().root.add_child(splatter)
	splatter.rotation = bullet.rotation# * 0.5
	
	splatter.global_position = global_position
