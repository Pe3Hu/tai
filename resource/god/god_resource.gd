class_name GodResource extends Resource


var heaven: HeavenResource:
	set = set_heaven
var temple: TempleResource

var camps: Array[CampResource]


func set_heaven(heaven_: HeavenResource) -> GodResource:
	heaven = heaven_
	heaven.gods.append(self)
	
	temple = TempleResource.new()
	temple.set_god(self)
	return self
	
func add_camp(battlefield_: BattlefieldResource) -> void:
	var camp = CampResource.new()
	camp.set_battlefield(battlefield_).set_god(self)
