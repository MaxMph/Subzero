extends Node

@export var item_info: item_res
@export var use_rand = false
@export var count_range = Vector2(4, 12)
#@export var count: int

#@export var item_info = "res://items/apple.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_info.duplicate()
	if use_rand:
		item_info.count = randi_range(count_range.x, count_range.y)
		
	
	#count = item_info.count
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	#print("apple")
		
	#if use_rand == true:
		#for i in randi_range(count_range.x, count_range.y):
			#get_tree().get_first_node_in_group("player").inv.add_item(item_info)
		##print(item_info.item_name)
	#else:
		#get_tree().get_first_node_in_group("player").inv.add_item(item_info)
	#queue_free()
	
#if use_rand == true:
	for i in item_info.count:
		get_tree().get_first_node_in_group("player").inv.add_item(item_info)
	#print(item_info.item_name)
	get_tree().get_first_node_in_group("player").item_pickup_sound.play()
	queue_free()
