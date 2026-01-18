extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$hand.position = get_global_mouse_position()
	#if $hand.position.x < ($hand.offset.x + $hand.size.x):
		##$hand.position = 

	if $hand/Node2D.global_position.y < get_viewport().size.y:
		#print("blaaaaaaa")
		#print($hand/Node2D.global_position.y)
		#$hand.position.y = (get_viewport().size.y / 2) + $hand/Node2D.position.y
		$hand.position.y = get_viewport().size.y - $hand/Node2D.position.y
		$hand/AnimationPlayer.play("shake")
	else:
		$hand/AnimationPlayer.stop()
	#elif $hand/Node2D.global_position.x < get_viewport().size.x:
		#$hand.position.x = get_viewport().size.y - $hand/Node2D.position.x
