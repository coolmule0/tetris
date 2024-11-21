@tool
extends SubViewportContainer

@export var grid: Grid

@onready var sub_viewport: SubViewport = $SubViewport
var cell_size := Vector2i(192, 192)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var grid_pixels := grid.grid_size * cell_size
	sub_viewport.size_2d_override = Vector2i(grid_pixels)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
