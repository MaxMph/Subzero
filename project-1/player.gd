extends CharacterBody3D


var speed = 4.6
var acc = 20
var fric = 20

var hunger = 100
var matabolism = 0.001
var warmth = 100

var jump_vel = 6

@export var head: Node3D
@export var cam: Camera3D

var root_gun_pos

var time: float

var item = null

@onready var inv = $inv

#@onready var hand_to_gun_aim: AimModifier3D = $head/cam_holder/Camera3D/arms/hand_to_gun_l

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	root_gun_pos = $head/cam_holder/Camera3D/gun_holder.position
	$head/cam_holder/Camera3D/root_gun_pos.global_position = $head/cam_holder/Camera3D/gun_holder.global_position
	$gun_follow.global_position = $head/cam_holder/Camera3D/gun_holder.global_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * Global.sense)
		cam.rotate_x(-event.relative.y * Global.sense)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(delta: float) -> void:
	time += delta
	hunger -= time * matabolism
	warmth -= time * 0.001
	
	$Control/ColorRect.material.set_shader_parameter("blur_amount", 1 - warmth / 100)
	$Control/HBoxContainer/hungerbar.value = hunger
	$Control/HBoxContainer/warmthbar.value = warmth
	
	#print(hunger)
	cam_holder_ani(delta)
	gun_pos(delta)

func _physics_process(delta: float) -> void:
	
	get_item()
	#$head/cam_holder/Camera3D/arms/hand_to_gun_l.target_po
	#$head/cam_holdermagnet r2/Camera3D/arms/hand_to_gun_l.set_target_position(%gun_holder.global_position)
	#hand_to_gun_aim.target_position = %gun_holder.global_position
#	hand_to_gun_aim.target_position = hand_to_gun_aim.global_position + Vector3.FORWARD * 2.0

	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_vel

	%int_indicator.hide()
	if %interact_cast.is_colliding():
		if %interact_cast.get_collider() != null and %interact_cast.get_collider().has_method("interact"):
			%int_indicator.show()
			if Input.is_action_just_pressed("int"):
				%interact_cast.get_collider().interact()
	
	if Input.is_action_pressed("aim") and item.is_in_group("gun"):
		var gun_aim_pos = $head/cam_holder/Camera3D/sight_pos.position - item.sight_pos
		$head/cam_holder/Camera3D/root_gun_pos.position = gun_aim_pos
	else:
		$head/cam_holder/Camera3D/root_gun_pos.position = root_gun_pos
	
	if Input.is_action_just_pressed("leftclick"):
		if item != null:
			if item.has_method("item_action"):
				item.item_action()
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, acc * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acc * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, fric * delta)
		velocity.z = move_toward(velocity.z, 0, fric * delta)
	
	$Control/fps_counter.text = str(Engine.get_frames_per_second())

	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inv"):
		if $inv.visible:
			$inv.close()
			#$inv.hide()
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			#$inv.show()
			$inv.open()
			#Input.mouse_mode = Input.mouse_mode

func cam_holder_ani(delta):
	var pos_adjustment
	var move_speed = abs(velocity.x) + abs(velocity.z)
	if move_speed > 0.4:
		$head/cam_holder.position.y = sin(time * (8)) * (0.1 * (move_speed/4))
		#print(move_speed)
	else:
		$head/cam_holder.position.y = move_toward($head/cam_holder.position.y, 0.0, delta * 1)

func gun_pos(delta):
	$gun_follow.global_position = lerp($gun_follow.global_position, $head/cam_holder/Camera3D/root_gun_pos.global_position, 20 * delta)
	%gun_holder.global_position = $gun_follow.global_position

func get_item():
	item = null
	for i in %gun_holder.get_children():
		if i.visible == true:
			item = i
