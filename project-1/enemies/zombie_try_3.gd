extends CharacterBody3D

var health = 100
var dmg = 15

var speed = 5.0
var target = null

@export var nav_agent: NavigationAgent3D


var can_attack = true

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity = Vector3.ZERO
	if target != null:
		nav_agent.target_position = target.global_position
		var next_point = nav_agent.get_next_path_position()
		#velocity = (next_point - global_transform.origin)
		look_at(target.global_position)
		velocity = (next_point - global_transform.origin).normalized()
		
		if can_attack == true:
			$attack_range.look_at(target.global_position)
			if $attack_range.is_colliding():
				if $attack_range.get_collider().is_in_group("player"):
					attack()

	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = null

func hit(dmg, bullet):
	health -= dmg
	if health <= 0:
		die()

func die():
	queue_free()

func attack():
	can_attack = false
	await get_tree().create_timer(1.0).timeout
	if $attack_range.is_colliding():
		if $attack_range.get_collider().is_in_group("player"):
			$attack_range.get_collider().hit(dmg)
	
	await get_tree().create_timer(1.0).timeout
	can_attack = true
