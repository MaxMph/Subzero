extends Node3D

@export var value = 40
@export var item_name = "ironsight"
@export var weight = 0.1

@export var fov_change = 4
@onready var aim_pos = $Marker3D.position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#aim_pos = $Marker3D.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
