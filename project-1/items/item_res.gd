extends Resource
class_name item_res

@export var item_name: String = "item_name"
#@export var item_scene: PackedScene
@export var item_scene: String
@export var weight: float = 1.0
@export var value: int = 20.0

@export var count: int = 1

@export var consumable = false
@export var consume_effects: Dictionary = {
	"hunger": 0,
	"blood": 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func use():
	#if consumable:
		#
		## += consume_effects["hunger"]
