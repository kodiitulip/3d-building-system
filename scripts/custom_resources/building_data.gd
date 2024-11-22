class_name ObjectData
extends Resource

@export_placeholder("Prop Name") var prop_name: String
@export var id: StringName
@export var scene: PackedScene
@export var preview: Texture2D
@export var footprint: Vector3i = Vector3i.ONE
@export var placement_offset: Vector3 = Vector3(0.5, 0.0, 0.5)
