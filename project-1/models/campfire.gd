extends Node3D

var player = null
var heat = 5.0
var heat_range
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		if player.warmth < 100:
			var heat_amount = ($warm_area/CollisionShape3D.shape.radius - global_position.distance_to(player.global_position)) / $warm_area/CollisionShape3D.shape.radius
			heat_amount *= heat
			#player.warmth += heat * delta
			player.warmth += heat_amount * delta


func _on_warm_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_warm_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
