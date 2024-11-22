class_name UserInterface
extends CanvasLayer

@export var prop_datas: Array[BuildingData]

@onready var props: HBoxContainer = %Props


func _ready() -> void:
	for prop: BuildingData in prop_datas:
		var button: PropButton = PropButton.new()
		button.data = prop
		props.add_child(button)
		button.prop_buttom_pressed.connect(_on_prop_button_pressed)


func _on_prop_button_pressed(data: BuildingData) -> void:
	BuildState.build_object(data.scene)
