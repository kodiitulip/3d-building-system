class_name PropButton
extends Button

signal prop_buttom_pressed(data: BuildingData)

@export var data: BuildingData


func _ready() -> void:
	icon = data.preview
	tooltip_text = data.prop_name
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	prop_buttom_pressed.emit(data)
