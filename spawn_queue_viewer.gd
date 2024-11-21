extends PanelContainer

@export var spawn_queue: SpawnQueue

@onready var piece_visualiser: Control = %PieceVisualiser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_queue.queue_changed.connect(on_spawn_queue_changed)
	# Above signal isn't triggering at game start as spawn queue initialises before this.
	set_piece_vis(spawn_queue.spawn_queue[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_spawn_queue_changed():
	var next_piece := spawn_queue.spawn_queue[0]
	set_piece_vis(next_piece)

func set_piece_vis(piece: PieceData):
	# remove previous display
	for c in piece_visualiser.get_children():
		c.queue_free()
	
	var cell_texture = piece.texture
	for c: Vector2i in piece.get_cells():
		var s = Sprite2D.new()
		piece_visualiser.add_child(s)
		s.texture = cell_texture
		s.position = c * Globals.cell_size + Globals.cell_size / 2
		#cell_positions.append(c)
		#cell_nodes.append(s)
	#self.position = grid_visualiser.grid_to_screen_pos(grid_position)


#cell_size * pos
