extends Control

#var index = 0
#var lines

signal next
var line = ""

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"): #and Global.in_menu == false:
		emit_signal("next")


func display(text):
	%dialogue_text.text = text

func start_text(text):
	if Global.in_menu == false:
		%page_numbers.text = ""
		show()
		#Global.in_menu = true
		#index = 0
		#typeof()
		
		if text is Array:
			for i in text:
				%page_numbers.text = str(text.find(i) + 1) + "/" + str(text.size())
				display(i)
				await next
		else:
			display(text)
			await next
		
		%dialogue_text.text = ""
		#Global.in_menu = false
		hide()
#
#func next_line(lines = []):
	#pass
