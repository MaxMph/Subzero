extends Node3D

var sight_pos

@export var mag: PackedScene
@export var sight: PackedScene
@export var muzzle: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#var new_muzzle = muzzle.instantiate()
	$gun_muzzle.add_child(muzzle.instantiate())
	
	#var new_sight = sight.instantiate()
	$gun_sights.add_child(sight.instantiate())
	#new_muzzle.position = $gun_muzzle.position
	
	$gun_mag.add_child(mag.instantiate())
	
	
	sight_pos = $gun_sights.position
	#if sight != null:
		#sight_pos = $gun_sights.position - sight.aim_pos
	if $gun_sights.get_child(0) != null:
		sight_pos = $gun_sights.position + $gun_sights.get_child(0).aim_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot():
	pass
