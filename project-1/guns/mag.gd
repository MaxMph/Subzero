extends Node3D

@export var mag_size = 6
var ammo_type = "9mm"
var ammo = 0
@export var start_with_ammo = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_with_ammo:
		ammo = mag_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
