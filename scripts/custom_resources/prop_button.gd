class_name PropButton
extends Button

signal prop_buttom_pressed(data: ObjectData)

@export var data: ObjectData


func _ready() -> void:
	icon = data.preview
	tooltip_text = data.prop_name
	pressed.connect(_on_pressed)
	mouse_default_cursor_shape = CURSOR_POINTING_HAND


func _on_pressed() -> void:
	prop_buttom_pressed.emit(data)
