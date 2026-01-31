extends Control

@export var max_items = 10

var items: Array[item_res]
#var input_waiting = false
var focused_item = -1

var item_res_options = [preload("res://items/stick.tres"), preload("res://items/apple.tres")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#open()
	#%cmd_line.grab_focus()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter"):
		print_line("user@FieldPDA:~$ " + %cmd_line.text)
		send_command(%cmd_line.text)
		%cmd_line.text = ""
		#%cmd_line.clear()
		#%cmd_line.release_focus()
		%cmd_line.grab_focus()
		%cmd_line.edit(true)
		#%cmd_line.keep_editing_on_text_submit
		#%cmd_line.select_all()
		#%cmd_line.grab_click_focus()
		#%cmd_line

func _on_remove_item_pressed() -> void:
	if items.size() > 0:
		items.remove_at(items.size() - 1)

func _on_add_item_pressed() -> void:
	items.append(item_res_options[randi_range(0, item_res_options.size() - 1)])
	var cur_item = items[items.size() - 1]
	print(cur_item.item_name)

func _on_print_inv_pressed() -> void:
	print(items)
	for i in items:
		%terminal_text.text += i.item_name + ": " + str(i.weight) + " " + str(i.value) + "\n\n"

func print_items():
	print_line("<---------------------------->")
	print_line("Items |" + str(items.size()) + "/" + str(max_items) + " :")
	var index = 1
	for i in items:
		print_line("(" + str(index) + ")" + i.item_name + ": " + str(i.weight) + " | " + str(i.value))
		index += 1
		#%terminal_text.text += i.item_name + ": " + str(i.weight) + " " + str(i.value) + "\n\n"
	print_line("<---------------------------->")

func print_line(text):
	%terminal_text.text += text + "\n\n"

func send_command(text: String):
	
	#if text.strip_edges().is_valid_int():
		
	if focused_item >= 0 and focused_item != null:
		match text.to_lower().strip_edges():
			"remove":
				remove_item(focused_item - 1)
				focused_item = null
	
	match text.to_lower().strip_edges():
		"inv":
			print_items()
		"exit", "close", "leave", "esc":
			get_tree().quit()
		"quit":
			get_tree().quit()
		"add item", "add_item":
			_on_add_item_pressed()
		"remove":
			pass
		_:
			print_line("--invalid command--")
	
	#if text == "inv":
		#print_items()
	#
	#if text == "exit" or text == "close" or text == "leave" or text == "esc":
		#pass
	#
	#if text == "add item":
		#_on_add_item_pressed()
	#
	#if text = 

func open():
	show()
	%cmd_line.grab_focus()
	%cmd_line.edit(true)
 
func close():
	hide()

func add_item(item: item_res):
	if item == null:
		print("item null")
	items.append(item)
	print("picked up " + item.item_name)
	print_line("Picked up " + item.item_name)

func remove_item(item_index: int):
	items.remove_at(item_index)
	print("dropped " + items[item_index].item_name)
	print_line("dropped " + items[item_index].item_name)
