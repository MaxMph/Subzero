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
	
	if Input.is_action_just_pressed("inv"):
		if visible:
			close()
			#$inv.hide()
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Global.in_menu == false:
			#$inv.show()
			open()
			#Input.mouse_mode = Input.mouse_mode

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
	text = text.strip_edges().to_lower()
	
	#if text.strip_edges().is_valid_int():
	
	var selected = -1
	if text.split(" ").size() >= 2:
		if text.split(" ").get(1).is_valid_int():
			selected = text.split(" ").get(1).to_int()
		text = text.split(" ").get(0)
	
		
	#if focused_item >= 0 and focused_item != null:
		#match text.to_lower().strip_edges():
			#"remove":
				#remove_item(focused_item - 1)
				#focused_item = null
	
	match text.to_lower().strip_edges():
		"inv":
			print_items()
		"exit", "close", "leave", "esc":
			get_tree().quit()
		"quit":
			get_tree().quit()
		"additem", "add_item":
			_on_add_item_pressed()
		"remove":
			remove_item(selected - 1)
		"use":
			use_item(selected - 1)
		"help":
			help()
		_:
			print_line("--invalid command--")
		
	
	#for i in text.split(" "):
		#if i
	
		
		
	
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

#func check_commands():
	#

func open():
	show()
	%cmd_line.grab_focus()
	%cmd_line.edit(true)
	Global.in_menu = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
 
func close():
	hide()
	Global.in_menu = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func add_item(item: item_res):
	if item == null:
		print("item null")
	items.append(item)
	print("picked up " + item.item_name)
	print_line("Picked up " + item.item_name)

func remove_item(index: int):
	if selected_check(index) == true:
		print("dropped " + items[index].item_name)
		create_scene_item(index)
		print_line("dropped " + items[index].item_name)
		items.remove_at(index)

func create_scene_item(index):
	if FileAccess.file_exists(items[index].item_scene):
		var itm = load(items[index].item_scene).instantiate()
		#itm.global_position = (%interact_cast.global_transform.origin + %interact_cast.get_collision_point())
		#itm.global_position = %interact_cast.get_collision_point()
		itm.global_position = %gun_holder.global_position
		get_tree().root.add_child(itm)

func use_item(index):
	if selected_check(index) == true:
		
		if items[index].consumable == true:
			print_line(items[index].item_name + " consumed")
			if items[index].consume_effects["hunger"] != 0:
				get_parent().hunger += items[index].consume_effects["hunger"]
				print_line("Hunger = " + str(clampi(get_parent().hunger, 0, 100)))
			if items[index].consume_effects["blood"] != 0:
				get_parent().blood += items[index].consume_effects["blood"]
				print_line("Blood = " + str(get_parent().hunger))
			#for i in 
				#if items[index].consume_effects
			
			#if items[index].consumable == true:
				#get_parent().blood += items[index].consume_effects["blood"]
				#get_parent().hunger += items[index].consume_effects["hunger"]

func selected_check(index):
	if index == -1:
		print_line("no item selected")
		return false
	elif index >= items.size() or index < -1:
		print_line("invaled item index")
		return false
	else:
		return true

func help():
	print_line("")
	print_line("keybinds:")
	print_line("wasd -> move")
	print_line("tab -> open terminal")
	#print_line("")
	
	print_line("")
	print_line("Commands:")
	print_line("[inv] -> shows items in inventory")
	print_line("[blabla] -> does nothing")
	
