class_name Board
extends Node2D

## The scene of the tiles
@export var tile_scene: PackedScene
## The number of tiles in each diagonal
@export var board_size: int = 4
## The number of diagonals with checkers on them that each side gets
@export var checker_diagonals: int = 3

var tiles: Dictionary[Vector2i, Tile]

var move_dots: Array[MoveIndicatorDot]

var selected_piece: Piece

var turn: Piece.PieceColor = Piece.PieceColor.LIGHT


func _ready() -> void:
	_place_tiles()


func _place_tiles() -> void:
	for dark_diagonal in range(board_size):
		var is_king_diagonal: bool = dark_diagonal == 0
		var tile_type: Tile.TileType = (Tile.TileType.KING if is_king_diagonal
				else Tile.TileType.NORMAL)
		
		var has_dark_pieces: bool = dark_diagonal < ceili(checker_diagonals / 2.0)
		var has_light_pieces: bool = dark_diagonal >= board_size - floori(checker_diagonals / 2.0)
		var has_pieces: bool = has_dark_pieces or has_light_pieces
		var piece_color: Piece.PieceColor = (Piece.PieceColor.LIGHT if has_light_pieces
				else Piece.PieceColor.DARK)
		
		var diagonal_start := Vector2i(0, board_size - 1) + Vector2i(1, 1) * dark_diagonal
		
		for column in range(board_size):
			var board_pos := diagonal_start + Vector2i(1, -1) * column
			_place_tile(board_pos, Tile.TileColor.DARK, tile_type, has_pieces, piece_color)
	
	for light_diagonal in range(board_size):
		var is_king_diagonal: bool = light_diagonal == board_size - 1
		var tile_type: Tile.TileType = (Tile.TileType.KING if is_king_diagonal
				else Tile.TileType.NORMAL)
		
		var has_dark_pieces: bool = light_diagonal < floori(checker_diagonals / 2.0)
		var has_light_pieces: bool = light_diagonal >= board_size - ceili(checker_diagonals / 2.0)
		var has_pieces: bool = has_dark_pieces or has_light_pieces
		var piece_color: Piece.PieceColor = (Piece.PieceColor.LIGHT if has_light_pieces
				else Piece.PieceColor.DARK)
		
		var diagonal_start := Vector2i(0, board_size) + Vector2i(1, 1) * light_diagonal
		
		for column in range(board_size):
			var board_pos := diagonal_start + Vector2i(1, -1) * column
			_place_tile(board_pos, Tile.TileColor.LIGHT, tile_type, has_pieces, piece_color)


func _place_tile(board_pos: Vector2i, color: Tile.TileColor, type: Tile.TileType, place_piece: bool,
		piece_color: Piece.PieceColor) -> void:
	var tile: Tile = tile_scene.instantiate()
	add_child(tile)
	tiles[board_pos] = tile
	
	tile.pos = board_pos
	tile.position = tile.pos * 32 + get_bounds().position
	tile.color = color
	tile.type = type
	tile.board = self
	
	if place_piece:
		tile.add_piece(piece_color, Piece.PieceType.CHECKER)


func get_bounds() -> Rect2i:
	var rect_pos := Vector2i(-board_size * 32 + 16, -board_size * 32)
	var rect_size := Vector2i(board_size * 2 - 1, board_size * 2) * 32
	return Rect2i(rect_pos, rect_size)


func next_turn() -> void:
	match turn:
		Piece.PieceColor.LIGHT:
			turn = Piece.PieceColor.DARK
		Piece.PieceColor.DARK:
			turn = Piece.PieceColor.LIGHT
