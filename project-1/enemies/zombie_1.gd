extends CharacterBody3D

const speed = 5.0

var sight_width = 25
var look_speed = 4
var sight_dist = 25


var cur_state = "idle"

func _physics_process(delta: float) -> void:
	
	
	var player_pos = get_tree().get_first_node_in_group("player").global_position
	$tracker.look_at(get_tree().get_first_node_in_group("player").global_position)
	
	if global_position.distance_to(player_pos) <= sight_dist:
		if $head/eyes.rotation.angle_to(global_position.direction_to(player_pos)) <= deg_to_rad(sight_width):
			$head.global_rotation.move_toward($tracker.global_rotation, look_speed * delta)
			#print($head/eyes.rotation.angle_to(global_position.direction_to(player_pos)))
			#print($head/eyes.global_transform.basis.z.angle_to($head.global_position.direction_to(player_pos)))
			print($head/eyes.global_transform.basis.z.angle_to($head.global_position.direction_to(player_pos)))
	
	#if angle_difference($tracker.global_rotation, $hea
	#if angle_difference($tracker.global_rotation, $head/eyes.global_rotation) < deg_to_rad(25):
		#if $head/eyes.global_rotation.angle_to($tracker.global_rotation) < deg_to_rad(sight_width):
		#	$head.global_rotation.move_toward($tracker.global_rotation, look_speed * delta)
	#print($head/eyes.global_rotation.angle_to($tracker.global_rotation))
		#print(deg_to_rad(sight_width))
	

	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
