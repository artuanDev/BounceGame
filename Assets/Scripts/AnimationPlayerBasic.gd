extends AnimationPlayer

class_name AnimationPlayerBasic

@export var list: PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list = get_animation_list()
