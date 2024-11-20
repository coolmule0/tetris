class_name SpawnQueue
extends Node

var spawn_queue: Array[PieceData]

const QUEUE_LENGTH := 5

const I = preload("res://tetronimos/I.tres")
const J = preload("res://tetronimos/J.tres")
const L = preload("res://tetronimos/L.tres")
const O = preload("res://tetronimos/O.tres")
const S = preload("res://tetronimos/S.tres")
const T = preload("res://tetronimos/T.tres")
const Z = preload("res://tetronimos/Z.tres")

var piece_types: Array[PieceData] = [I, J, L, O, S, T, Z]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(QUEUE_LENGTH):
		var p_type = piece_types.pick_random() as PieceData
		spawn_queue.append(p_type)
	pass # Replace with function body.


## return the front of the queue and remove it
func serve() -> PieceData:
	var to_give = spawn_queue.pop_front()
	
	# add a new piece to the queue
	var p_type = piece_types.pick_random() as PieceData
	spawn_queue.append(p_type)
	
	return to_give
