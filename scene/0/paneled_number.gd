@tool
class_name PaneledNumber extends PanelContainer


@export var label: Label
@export_enum("stipulation", "guess", "solution") var type: = "stipulation":
	set(type_):
		type = type_
		
		match type:
			"stipulation":
				label_color = Color.PAPAYA_WHIP
			"guess":
				label_color = Color.DARK_ORANGE
			"solution":
				label_color = Color.SEA_GREEN
		
		label.set("theme_override_colors/font_color", label_color)
	get:
		return type
@export var value: int:
	set(value_):
		value = value_
		
		#if is_node_ready():
		label.text = str(value)
	get:
		return value
@export var zoom: int:
	set(zoom_):
		zoom = zoom_
		custom_minimum_size = base_size * zoom
		size = custom_minimum_size
		label.set("theme_override_font_sizes/font_size", base_font * zoom)
	get:
		return zoom

var label_color
var style: StyleBoxFlat

const base_size = Vector2(13, 13)
const base_font = 10


func _ready() -> void:
	init_style()
	
func init_style() -> void:
	style = StyleBoxFlat.new()
	set("theme_override_styles/panel", style)
