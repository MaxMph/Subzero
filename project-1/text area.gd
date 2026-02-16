extends Area3D

@export var text: String
@export var texts: Array[String] = []

func _ready() -> void:
	if texts.size() == 0:
		texts.append(text)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.dialogue.start_text(texts)
