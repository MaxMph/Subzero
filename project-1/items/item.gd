extends Node

@export var item_info: item_res
#@export var item_info = "res://items/apple.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_info.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	#print("apple")
	get_tree().get_first_node_in_group("player").inv.add_item(item_info)
	#print(item_info.item_name)
	queue_free()
