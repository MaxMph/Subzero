extends Node3D

@export var lit = false

var player = null
var heat = 5.0
var heat_range
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lit == true:
		$CPUParticles3D2.emitting = true
		$CPUParticles3D3.emitting = true
		$AudioStreamPlayer3D.playing = true
		$OmniLight3D.show()
		if player != null:
			if player.warmth < 100:
				var heat_amount = ($warm_area/CollisionShape3D.shape.radius - global_position.distance_to(player.global_position)) / $warm_area/CollisionShape3D.shape.radius
				heat_amount *= heat
				#player.warmth += heat * delta
				player.warmth += heat_amount * delta
	else:
		$CPUParticles3D2.emitting = false
		$CPUParticles3D3.emitting = false
		$AudioStreamPlayer3D.playing = false
		$OmniLight3D.hide()


func _on_warm_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_warm_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null


func interact():
	if lit == false:
		for i in get_tree().get_first_node_in_group("player").inv.items:
			if i.item_name == "match":
				lit = true
				get_tree().get_first_node_in_group("player").inv.items.erase(i)
				break
		if lit == false:
			get_tree().get_first_node_in_group("player").dialogue.start_text("I need something to light the fire with...")
