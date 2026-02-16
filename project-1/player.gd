extends CharacterBody3D


var base_speed
var speed = 5.6
var sprint_mult = 1.4
var acc = 20
var fric = 20

var hunger = 100
var matabolism = 0.8
var warmth = 100
var chill = 0.55
var blood = 100

var jump_vel = 6.8

@export var head: Node3D
@export var cam: Camera3D

var root_gun_pos

var time: float

var item = null

var base_fov
var fov_scopespeed = 38

@onready var inv = $inv

@export var rg_holder: PackedScene


var step_vol
var step_pitch

@export var dialogue: Node

@onready var item_pickup_sound = $item_pickup

#@onready var hand_to_gun_aim: AimModifier3D = $head/cam_holder/Camera3D/arms/hand_to_gun_l

func _ready() -> void:
	base_speed = speed
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	root_gun_pos = $head/cam_holder/Camera3D/gun_holder.position
	$head/cam_holder/Camera3D/root_gun_pos.global_position = $head/cam_holder/Camera3D/gun_holder.global_position
	$gun_follow.global_position = $head/cam_holder/Camera3D/gun_holder.global_position
	base_fov = $head/cam_holder/Camera3D.fov
	
	step_vol = $walking.volume_db
	step_pitch = $walking.pitch_scale
	
	head.rotation.y = rotation.y
	rotation = Vector3.ZERO
	#print(rotation.y)
	#head.global_rotation.y = deg_to_rad(90)
	
	
	#rotation.y = 0
	#cam.global_rotation = global_rotation
	
	$dialogue.start_text([
	"February 26, 2012",
	"I camped at some old cabins tonight, the chill has gotten near unberable...", "still better than being in the city. I just need to get food and stay warm, buy myself time make a plan...",
	"[after you press enter to finish this dialogue, press tab to open your PDA terminal and type [help] to see some helpfull information]"
	])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * Global.sense)
		cam.rotate_x(-event.relative.y * Global.sense)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(delta: float) -> void:
	breathing_sound()
	
	
	if hunger > 100:
		hunger = 100
	if blood > 100:
		blood = 100
	if warmth > 100:
		warmth = 100
	
	time += delta
	#hunger -= time * matabolism
	#warmth -= time * (0.001 + ((100 - blood) / 1000))
	
	hunger -= delta * matabolism
	warmth -= delta * (chill + (100 - blood) / 40 + (100 - hunger) / 20) #100) #delta * (0.001 + ((100 - blood) / 1000))
	
	$Control/ColorRect.material.set_shader_parameter("blur_amount", (1 - warmth / 100) * 2)
	$Control/HBoxContainer/VBoxContainer/hungerbar.value = hunger
	$Control/HBoxContainer/VBoxContainer2/warmthbar.value = warmth
	$Control/HBoxContainer/VBoxContainer3/bloodbar.value = blood
	
	if warmth <= 0:
		die()
	if hunger <= 0:
		die()
	if blood <= 0:
		die()
	
	
	#print(hunger)
	cam_holder_ani(delta)
	gun_pos(delta)
	
	
	
	if item != null:
		
		if item.is_in_group("gun"):
			if Input.is_action_pressed("aim"):
				$head/cam_holder/Camera3D.fov = move_toward($head/cam_holder/Camera3D.fov, base_fov - item.sight.fov_change, delta * (fov_scopespeed + item.sight.fov_change * 2) )
				var gun_aim_pos = $head/cam_holder/Camera3D/sight_pos.position - item.sight_pos
				$head/cam_holder/Camera3D/root_gun_pos.position = gun_aim_pos
			else:
				$head/cam_holder/Camera3D/root_gun_pos.position = root_gun_pos
				$head/cam_holder/Camera3D.fov = move_toward($head/cam_holder/Camera3D.fov, base_fov, delta * (fov_scopespeed + item.sight.fov_change * 2))
	
	if Input.is_action_just_pressed("ammo_check"):
		if Global.in_menu == false and item != null:
			if item.has_method("check_ammo"):
				item.check_ammo()
	
	if Input.is_action_just_pressed("reload"):
		if Global.in_menu == false and item != null:
			if item.has_method("reload"):
				item.reload()
	
	#if Input.is_action_just_pressed("drop") and item.col_shape != null:
	if false == true:
		var itm = item
		var rg = rg_holder.instantiate()
		#get collisionshape shape and pass it to rg
		rg.get_child(0).shape = itm.col_shape.shape
		#rg. itm.col_shape
		
		rg.add_child(itm)
		#item.queue_free()
		#rg.add_child(rg.get_child(itm).col_shape)
		get_tree().root.add_child(rg)
		rg.global_position = item.global_position
		
		item.queue_free()
		
		#var rg = rg_holder.instantiate()
		#var itm = item.duplicate()
		#itm.global_position = Vector3.ZERO
		#get_tree().root.add_child(rg)
		#rg.add_child(itm)
		#rg.add_child(itm.col_shape)
		#itm.remove_child(itm.col_shape)
		#rg.global_position = item.global_position
		#item.queue_free()
		
		
	
func _physics_process(delta: float) -> void:
	
	get_item()
	#$head/cam_holder/Camera3D/arms/hand_to_gun_l.target_po
	#$head/cam_holdermagnet r2/Camera3D/arms/hand_to_gun_l.set_target_position(%gun_holder.global_position)
	#hand_to_gun_aim.target_position = %gun_holder.global_position
#	hand_to_gun_aim.target_position = hand_to_gun_aim.global_position + Vector3.FORWARD * 2.0

	
	if not is_on_floor():
		velocity += Vector3(0, -14, 0) * delta
	
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_vel

	if Input.is_action_pressed("sprint"):
		speed = base_speed * sprint_mult
	else:
		speed = base_speed

	%int_indicator.hide()
	if %interact_cast.is_colliding():
		if %interact_cast.get_collider() != null and %interact_cast.get_collider().has_method("interact"):
			%int_indicator.show()
			if Input.is_action_just_pressed("int"):
				%interact_cast.get_collider().interact()
				#print("inted")
	
	
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
	pass

func cam_holder_ani(delta):
	var pos_adjustment
	var move_speed = abs(velocity.x) + abs(velocity.z)
	if move_speed > 0.4:
		$head/cam_holder.position.y = sin(time * (8)) * (0.1 * (move_speed/4))
		if !$walking.playing:
			#var vol_mod = randi_range(-10, 10)
			#var pitch_mod = randf_range($walking.pitch_scale * 0.5, $walking.pitch_scale * 2)
			#$walking.volume_db += vol_mod
			#$walking.pitch_scale += pitch_mod
			#$walking.play()
			#$walking.volume_db -= vol_mod
			#$walking.pitch_scale -= pitch_mod
			$walking.volume_db = step_vol
			$walking.pitch_scale = step_pitch
			$walking.volume_db += randi_range(-2, 2) + velocity.length() - speed / 2
			$walking.pitch_scale += randf_range(-0.1, 0.1) #randf_range($walking.pitch_scale * 0.5, $walking.pitch_scale * 2)
			$walking.play()
			
			
		if is_on_floor() == false:
			$walking.stop()
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

func die():
	#get_tree().change_scene_to_file("res://ui/main_menu.tscn")
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func hit(dmg):
	blood -= dmg

func breathing_sound():
	#var danger = 300
	#danger -= hunger + blood + warmth
	#danger /= 3000
	#
	##danger / 3000
	#$breathing.volume_db = danger * 20
	
	#var danger = 200
	#if hunger < warmth
	
	$breathing.volume_db = (100 - warmth) / 5 #/ 50
