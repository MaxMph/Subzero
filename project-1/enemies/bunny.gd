extends CharacterBody3D


@export var speed = 110.0
@export var run_mult = 4.0
@export var run_dist_mod = 2.0

@export var health = 12.0

#roaming
@export var next_roam_dist = 10.0
@export var target_allowence = 1.0
@export var roam_dist = 0.0
var original_pos

@export var idle_time_max = 6.0

enum states {IDLE, TRAVELING, jumping, RUNNING, DEAD}
var state = states.IDLE

var target: Vector3

func _ready() -> void:
	original_pos = global_position
	original_pos.y = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	match state:
		states.IDLE:
			idle()
		states.TRAVELING:
			travel(delta)
		states.RUNNING:
			run(delta)
		states.DEAD:
			dead()

	move_and_slide()

func place_target():
	#var temp_target = global_position + Vector3(randf_range(-next_roam_dist, next_roam_dist), 0, randf_range(-next_roam_dist, next_roam_dist))
	#$RayCast3D.target_position.z = -1 * abs(position.distance_to(temp_target))
	#$RayCast3D.look_at(temp_target)
	#if $RayCast3D.is_colliding():
		#place_target()
	#else:
		#target = temp_target
	#
	
	target = global_position + Vector3(randf_range(-next_roam_dist, next_roam_dist), 0, randf_range(-next_roam_dist, next_roam_dist))
	if state == states.RUNNING:
		target * run_dist_mod
		#target = global_position + Vector3(randf_range(-next_roam_dist, next_roam_dist), 0, randf_range(-next_roam_dist, next_roam_dist))
	if target.distance_to(original_pos) > roam_dist and roam_dist != 0.0:
		place_target()
	

	#return global_position + Vector3(randf_range(-next_roam_dist, next_roam_dist), 0, randf_range(-next_roam_dist, next_roam_dist))

func idle():
	if $idle_timer.is_stopped():
		$idle_timer.wait_time = randf_range(0, idle_time_max)
		$idle_timer.start()
	
	velocity.x = 0
	velocity.z = 0

func travel(delta):
	if abs((global_position - target).length()) < target_allowence:
		state = states.IDLE
	else:
		velocity = global_position.direction_to(target) * speed * delta
		
		$RayCast3D.target_position.z = -1 * abs(position.distance_to(target))
		$RayCast3D.look_at(target)
		if $RayCast3D.is_colliding():
			place_target()

func run(delta):
	if $run_timer.is_stopped():
		$run_timer.start()
	
	if abs((global_position - target).length()) < target_allowence:
		place_target()
	else:
		#print("123")
		velocity = global_position.direction_to(target) * speed * run_mult * delta
		
		$RayCast3D.target_position.z = -1 * abs(position.distance_to(target))
		$RayCast3D.look_at(target)
		if $RayCast3D.is_colliding():
			place_target()

func dead():
	velocity.x = 0
	velocity.z = 0
	print("dead")
	

func _on_idle_timer_timeout() -> void:
	if state == states.IDLE:
		place_target()
		state = states.TRAVELING


func _on_run_timer_timeout() -> void:
	if state == states.RUNNING:
		state = states.IDLE

func hit(dmg):
	health -= dmg
	print("hit")
	if health <= 0.0:
		state = states.DEAD
	else:
		state = states.RUNNING
