extends Node3D

@export var thing: PackedScene

@export var spawn_rare: int = 40

@export var spawn_on_start = false
@export var single_spawn = false

func _ready() -> void:
	if spawn_on_start:
		spawn()

func _on_tic_timeout() -> void:
	if single_spawn == false:
		if randi_range(0, spawn_rare) == 0:
			spawn()

func spawn():
	var new_thing = thing.instantiate()
	new_thing.global_position = global_position
	get_tree().root.add_child(new_thing)
	#rotation.y  = randi_range(-180, 180)
