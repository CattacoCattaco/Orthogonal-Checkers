class_name MoveIndicatorDot
extends Sprite2D

@export var button: TextureButton

var pos: Vector2i

var board: Board

var origin_piece: Piece
var captured_piece: Piece


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	origin_piece.deselect()
	
	board.tiles[pos].add_piece(origin_piece.color, origin_piece.type)
	board.tiles[origin_piece.pos].remove_piece()
	
	var is_jump: bool = false
	
	if captured_piece:
		board.tiles[captured_piece.pos].remove_piece()
		is_jump = true
	
	if board.tiles[pos].type == Tile.TileType.KING:
		if board.tiles[pos].piece.can_promote():
			board.tiles[pos].piece.promote()
			board.next_turn()
			return
	
	if not (is_jump and board.tiles[pos].piece.can_chain_jump()):
		board.next_turn()
