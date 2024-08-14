class_name World extends Node


@export var battlefield: Battlefield
@export var resource: WorldResource

@export var blabla: int = 0:
	set(blabla_):
		blabla = blabla_
	get:
		return blabla


func _ready() -> void:
	#datas.filter(func (a): return true)
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	#Global.rng.randomize()
	#var random = Global.rng.randi_range(0, 1)
	#await get_tree().physics_frame
	
	resource = WorldResource.new()
	battlefield.fill_as_last()
	pass


#func set_blob(blob_: int) -> Resource:
	#blob = blob
	#return self
