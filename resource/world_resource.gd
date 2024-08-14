class_name WorldResource extends Resource


@export var heaven: HeavenResource
@export var battlefields: Array[BattlefieldResource]


func _init() -> void:
	heaven = HeavenResource.new()
	
	var reserve_count = 9
	add_battlefield(reserve_count)
	
func add_battlefield(reserve_count_: int) -> void:
	var battlefield = BattlefieldResource.new()
	battlefield.set_reserve_count(reserve_count_).set_world(self)
