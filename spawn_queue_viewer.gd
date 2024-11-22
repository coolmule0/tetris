extends PanelContainer

@export var spawn_queue: SpawnQueue

@onready var piece_visualiser: CanvasItem = %PieceVisualiser
@onready var piece_sub_viewport: SubViewport = %PieceSubViewport

var shown_piece: PieceData:
	set(piece):
		shown_piece = piece
		_set_piece_vis(piece)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_queue.queue_changed.connect(on_spawn_queue_changed)
	# Above signal isn't triggering at game start as spawn queue initialises before this.
	shown_piece = spawn_queue.spawn_queue[0]
	
	# set the subviewport size


## Grab the next piece in the spawn queue and set it
func on_spawn_queue_changed():
	var next_piece := spawn_queue.spawn_queue[0]
	shown_piece = next_piece

func _set_piece_vis(piece: PieceData):
	#next_piece = piece
	# remove previous display
	for c in piece_visualiser.get_children():
		c.queue_free()
	
	var cell_texture = piece.texture
	for c: Vector2i in piece.get_cells():
		var s = Sprite2D.new()
		piece_visualiser.add_child(s)
		s.texture = cell_texture
		s.position = c * Globals.cell_size + Globals.cell_size / 2
