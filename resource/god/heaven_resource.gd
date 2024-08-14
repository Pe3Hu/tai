class_name HeavenResource extends Resource


var gods: Array[GodResource]


func _init() -> void:
	init_gods(3)
	
func init_gods(count_: int) -> void:
	for _i in count_:
		var god = GodResource.new()
		god.set_heaven(self)
