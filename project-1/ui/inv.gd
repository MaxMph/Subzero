extends Control

@export var max_items = 10

var items: Array[item_res]

var item_res_options = [preload("res://items/stick.tres"), preload("res://items/apple.tres")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_remove_item_pressed() -> void:
	if items.size() > 0:
		items.remove_at(items.size() - 1)


func _on_add_item_pressed() -> void:
	items.append(item_res_options[randi_range(0, item_res_options.size() - 1)])
	var cur_item = items[items.size() - 1]
	print(cur_item.item_name)


func _on_print_inv_pressed() -> void:
	print(items)
