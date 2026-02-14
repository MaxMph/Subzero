extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$hand.position = get_global_mouse_position()
	#if $hand.position.x < ($hand.offset.x + $hand.size.x):
		##$hand.position = 
#
	if $hand/Node2D.global_position.y < get_viewport().size.y:
		#print("blaaaaaaa")
		#print($hand/Node2D.global_position.y)
		#$hand.position.y = (get_viewport().size.y / 2) + $hand/Node2D.position.y
		#$hand.position.y = get_viewport().size.y - $hand/Node2D.position.y
		$hand/AnimationPlayer.play("shake")
	else:
		$hand/AnimationPlayer.stop()
	#elif $hand/Node2D.global_position.x < get_viewport().size.x:
		#$hand.position.x = get_viewport().size.y - $hand/Node2D.position.x
	
	if $hand/Node2D.global_position.y < $hand_limit/Node2D.global_position.y:
		#$hand.position.y = get_viewport().size.y - $hand/Node2D.position.y
		$hand.global_position.y = $hand_limit/Node2D.global_position.y + ($hand.global_position.y - $hand/Node2D.global_position.y)
		$hand/AnimationPlayer.play("shake")
	else:
		$hand/AnimationPlayer.stop()


func _on_startbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quitbutton_pressed() -> void:
	get_tree().quit()


func _on_optionsbutton_pressed() -> void:
	pass
