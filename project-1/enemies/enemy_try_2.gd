extends CharacterBody3D


var speed = 1.0
var sight_dist = 20
var lookspeed = 4.0
var turnspeed = 0.4

var target

func _ready() -> void:
	$pointer.target_position.z = -sight_dist
	$head/eyes/eyemarker.position = $head/eyes.target_position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#raycast stuff
	$pointer.look_at(get_tree().get_first_node_in_group("player").global_position)
	if $pointer.is_colliding():
		if $pointer.get_collider().is_in_group("player"):
			$head.global_rotation = $head.global_rotation.move_toward($pointer.global_rotation, lookspeed * delta)
			#print("bleh")
	
	#$Armature/Skeleton3D/LookAtModifier3D.target_node = $head/eyes/eyemarker
	$head.global_position = $Armature/Skeleton3D/PhysicalBoneSimulator3D/head_bone/head_col.global_position
	$pointer.global_position = $Armature/Skeleton3D/PhysicalBoneSimulator3D/head_bone/head_col.global_position
	
	#velocity = global_position.direction_to(get_tree().get_first_node_in_group("player").global_position) * speed
	#velocity.y = 0
	#rotation = rotation.move_toward(look_at(get_tree().get_first_node_in_group("player").global_position), (turnspeed + abs(velocity.x) + abs(velocity.Z)) * delta)
	
	#rotation = rotation.move_toward(look_at($head/eyes/eyemarker.global_position), delta)
	
	#rotation = rotation.move_toward($pointer.global_rotation, lookspeed * delta)
	var temp_turnspeed = turnspeed 
	global_rotation.y = lerp(global_rotation.y, $pointer.global_rotation.y, (turnspeed * (abs(velocity.x) + abs(velocity.z))) * delta)
	move_and_slide()

#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if

func interacted():
	pass
