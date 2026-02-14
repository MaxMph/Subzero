extends Node3D

var sight_pos

@export var mag_scene: PackedScene
@export var sight_scene: PackedScene
@export var muzzle_scene: PackedScene
@export var flash = preload("res://guns/muzzleflash.tscn")
@export var base_flash_size = 0.5

@export var caliber = "9mm"
@export var bullet_reload_time = 0.3

var mag
var sight
var muzzle

@export var vrecoil = 0.2
@export var hrecoil = 0.04
@export var recoil_reset_speed = 0.4

@onready var bullet = preload("res://guns/9_mm.tscn")
@onready var main = get_tree().get_first_node_in_group("world")
var sender
var local_can_shoot = true

@export var col_shape: CollisionShape3D

func _ready() -> void:
	$gun_muzzle.add_child(muzzle_scene.instantiate())
	$gun_sights.add_child(sight_scene.instantiate())
	$gun_mag.add_child(mag_scene.instantiate())

	muzzle = $gun_muzzle.get_child(0)
	sight = $gun_sights.get_child(0)
	mag = $gun_mag.get_child(0)
	
	
	
	sight_pos = $gun_sights.position
	if $gun_sights.get_child(0) != null:
		sight_pos = $gun_sights.position + $gun_sights.get_child(0).aim_pos


func item_action():
	if mag.ammo > 0 and Global.can_shoot == true and local_can_shoot == true:
		shoot()
		mag.ammo -= 1

func shoot():
	var new_bullet = bullet.instantiate()
	new_bullet.sender = sender
	new_bullet.spawn_transform = $gun_muzzle.global_transform
	#$bullet_marker/Sprite3D.rotation.z = randi_range(-20, 20)
	main.add_child.call_deferred(new_bullet)
	muzzleflash()
	get_parent().recoil(randf_range(vrecoil * 0.8, vrecoil * 1.2), randf_range(-hrecoil, hrecoil), recoil_reset_speed)
	$gunshot.play()

func muzzleflash():
	var newflash = flash.instantiate()
	#var newflash = flash.instantiate()
	newflash.max_size = base_flash_size
	if muzzle_scene == null:
		$gun_muzzle.add_child(newflash)
	else:
		#newflash.max_size * $gun_muzzle.get_child(0).gun_muzzle.flash_mult
		$gun_muzzle.get_child(0).gun_muzzle.add_child(newflash)
		#print("blaaaaa")

func check_ammo():
	$"reload/mag out".play()
	local_can_shoot = false
	$Control/Label.text = str(mag.ammo) + "/" + str(mag.mag_size)
	$Control.show()
	#Global.can_shoot = false
	await get_tree().create_timer(1.0).timeout
	$Control.hide()
	$reload/mag_in.play()
	local_can_shoot = true
	#Global.can_shoot = true

func reload():
	print("reloading")
	local_can_shoot = false
	$"reload/mag out".play()
	
	var space_left = mag.mag_size - mag.ammo
	var added = 0
	var inv = get_tree().get_first_node_in_group("player").inv
	#if inv.items.find():
	
	await get_tree().create_timer(0.2).timeout #for mag out sound
	
	for i in inv.items:
		if i.item_name == caliber and space_left - added > 0:
			$reload/fill_mag.play()
			await get_tree().create_timer(bullet_reload_time).timeout
			#space_left -= 1
			added += 1 
			mag.ammo += 1
			#inv.items.erase(i)
			print("ammo + 1")
	
	
	for bullet in added:
		#inv.items.erase()
		for i in inv.items:
			if i.item_name == caliber:
				inv.items.erase(i)
				print("-1 ammo from inv")
				break
	
	await get_tree().create_timer(0.2).timeout #for mag in sound
	
	print(str(added) + " added!")
	local_can_shoot = true
	$reload/mag_in.play()
	
	#mag.ammo = mag.mag_size - space_left
