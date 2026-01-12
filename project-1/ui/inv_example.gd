extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$StaticBody2D.position = get_global_mouse_position()
	#for i in get_tree().get_nodes_in_group("bounding_box"):
		#print(is_partially_outside(i, $StaticBody2D))
	#$CharacterBody2D.position = get_global_mouse_position()
	$Area2D.position = get_global_mouse_position()
	print($Area2D.get_overlapping_areas())
	for i in $Area2D.get_overlapping_areas():
		if i.is_in_group(""):
			pass

#func is_partially_outside(area: Area2D, body: CollisionObject2D) -> bool:
	#var area_shape = area.get_node("CollisionShape2D")
	#var body_shape = body.get_node("CollisionShape2D")
#
	#var area_xform = area_shape.global_transform
	#var body_xform = body_shape.global_transform
#
	#return not area_shape.shape.collide(
		#area_xform,
		#body_shape.shape,
		#body_xform
	#)
#
#func is_fully_inside(area: Area2D, body: CollisionObject2D) -> bool:
	#var points := get_body_sample_points(body)
#
	#for p in points:
		#if not area.get_overlapping_point(p):
			#return false
	#return true
