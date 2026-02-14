extends Node3D

@export var daylight = 0.4
var light = 0.2
var day_length = 12
var cur_time = 12
var light_dark = -1

var sunlight_range = Vector2(0, 0.2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$"../DirectionalLight3D".energy
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	#cur_time += delta * light_dark
	#if cur_time > day_length or cur_time < 0:
		###cur_time = 0
		#light_dark *= -1
	#
	#var day_progress = (cur_time / day_length * light_dark + 1) * 0.5
	#
	#$"../DirectionalLight3D".light_energy =  day_progress
	##if day_progress * 360 - 90 >= 360
	##$"../DirectionalLight3D".rotation.x = day_progress * 360
	#$"../DirectionalLight3D".rotation_degrees.x = (cur_time / day_length) * 360 - 90
	#
	#
	#$"../WorldEnvironment".environment.background_energy_multiplier = day_progress
	#
	#if light_dark > 0:
		#pass
	#else:
		#pass
	#
	##if cur_time > day_length/2:
		##light_dark = -1
		##$"../DirectionalLight3D".light_energy = cur_time/ daylight
	##else:
		##light_dark = 1
	
	
	#cur_time += delta * light_dark
	#if cur_time > day_length or cur_time < 0:
		#light_dark *= -1
#
	#var t = cur_time / day_length
#
	#$"../DirectionalLight3D".rotation_degrees.x = t * 360.0 - 90.0
	#$"../DirectionalLight3D".light_energy = t
	#$"../WorldEnvironment".environment.background_energy_multiplier = t
	
