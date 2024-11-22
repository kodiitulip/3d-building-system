class_name UserInterface
extends CanvasLayer

@export var prop_database: ObjectsDatabase

@onready var props: HBoxContainer = %Props


func _ready() -> void:
	if not prop_database:
		return
	for prop: ObjectData in prop_database.objects_data:
		var button: PropButton = PropButton.new()
		button.data = prop
		props.add_child(button)
		button.prop_buttom_pressed.connect(_on_prop_button_pressed)


func _on_prop_button_pressed(data: ObjectData) -> void:
	BuildState.build_state.build_object(data)
