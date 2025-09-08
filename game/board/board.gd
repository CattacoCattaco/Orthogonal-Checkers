class_name Board
extends Node2D

enum BoardShape {
	SQUARE_OFFSET,
	SQUARE_SQUARE,
	HEXES_2_PLAYER,
	HEXES_3_PLAYER,
}

## The scene of the tiles
@export var tile_scene: PackedScene
## The shape of the board
@export var shape: BoardShape
## The number of tiles in each diagonal/row
@export var board_size: int = 4
## The number of diagonals with checkers on them that each side gets
@export var checker_diagonals: int = 3

var tiles: Dictionary[Vector2i, Tile]

var move_dots: Array[MoveIndicatorDot]

var selected_piece: Piece

var turn: Piece.PieceColor = Piece.PieceColor.LIGHT

var is_in_chain_jump: bool = false


func _ready() -> void:
	_place_tiles()


func _place_tiles() -> void:
	match shape:
		BoardShape.SQUARE_OFFSET:
			_place_square_offset_tiles()
		BoardShape.HEXES_2_PLAYER:
			_place_hex_2_player_tiles()


func _place_square_offset_tiles() -> void:
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


func _place_hex_2_player_tiles() -> void:
	for dark_diagonal in range(board_size):
		var is_king_diagonal: bool = dark_diagonal == 0
		var tile_type: Tile.TileType = (Tile.TileType.KING if is_king_diagonal
				else Tile.TileType.NORMAL)
		
		var has_dark_pieces: bool = dark_diagonal < ceili(checker_diagonals / 3.0)
		var has_light_pieces: bool = dark_diagonal >= board_size - floori(checker_diagonals / 3.0)
		var has_pieces: bool = has_dark_pieces or has_light_pieces
		var piece_color: Piece.PieceColor = (Piece.PieceColor.LIGHT if has_light_pieces
				else Piece.PieceColor.DARK)
		
		var diagonal_start := Vector2i(1, -1) * dark_diagonal
		
		for column in range(board_size):
			var board_pos := diagonal_start + Vector2i(1, 2) * column
			_place_tile(board_pos, Tile.TileColor.DARK, tile_type, has_pieces, piece_color)
	
	for light_diagonal in range(board_size):
		var is_king_diagonal: bool = light_diagonal == board_size - 1
		var tile_type: Tile.TileType = (Tile.TileType.KING if is_king_diagonal
				else Tile.TileType.NORMAL)
		
		var has_dark_pieces: bool = light_diagonal < floori(checker_diagonals / 3.0)
		var has_light_pieces: bool = light_diagonal >= board_size - ceili(checker_diagonals / 3.0)
		var has_pieces: bool = has_dark_pieces or has_light_pieces
		var piece_color: Piece.PieceColor = (Piece.PieceColor.LIGHT if has_light_pieces
				else Piece.PieceColor.DARK)
		
		var diagonal_start := Vector2i(1, 0) + Vector2i(1, -1) * light_diagonal
		
		for column in range(board_size):
			var board_pos := diagonal_start + Vector2i(1, 2) * column
			_place_tile(board_pos, Tile.TileColor.LIGHT, tile_type, has_pieces, piece_color)
	
	for mid_diagonal in range(board_size):
		var tile_type: Tile.TileType = Tile.TileType.NORMAL
		
		var has_dark_pieces: bool = mid_diagonal < roundi(checker_diagonals / 3.0)
		var has_light_pieces: bool = mid_diagonal >= board_size - roundi(checker_diagonals / 3.0)
		var has_pieces: bool = has_dark_pieces or has_light_pieces
		var piece_color: Piece.PieceColor = (Piece.PieceColor.LIGHT if has_light_pieces
				else Piece.PieceColor.DARK)
		
		var diagonal_start := Vector2i(0, -1) + Vector2i(1, -1) * mid_diagonal
		
		for column in range(board_size):
			var board_pos := diagonal_start + Vector2i(1, 2) * column
			_place_tile(board_pos, Tile.TileColor.MID, tile_type, has_pieces, piece_color)


func _place_tile(board_pos: Vector2i, color: Tile.TileColor, type: Tile.TileType, place_piece: bool,
		piece_color: Piece.PieceColor) -> void:
	var tile: Tile = tile_scene.instantiate()
	add_child(tile)
	tiles[board_pos] = tile
	
	tile.pos = board_pos
	tile.color = color
	tile.type = type
	tile.board = self
	
	match shape:
		BoardShape.SQUARE_OFFSET, BoardShape.SQUARE_SQUARE:
			tile.shape = Tile.TileShape.SQUARE
		BoardShape.HEXES_2_PLAYER:
			tile.shape = Tile.TileShape.HEX_2_WAY
		BoardShape.HEXES_3_PLAYER:
			tile.shape = Tile.TileShape.HEX_3_WAY
	
	match tile.shape:
		Tile.TileShape.SQUARE:
			tile.position = get_bounds().position + tile.pos * 32
		Tile.TileShape.HEX_2_WAY, Tile.TileShape.HEX_3_WAY:
			var x_offset: int = 13
			var y_offset: int = 23 * (board_size - 1)
			
			tile.position = get_bounds().position + Vector2i(x_offset, y_offset) + (
					tile.pos.x * Vector2i(13, 23)
					+ tile.pos.y * Vector2i(13, -23)
			)
	
	if place_piece:
		tile.add_piece(piece_color, Piece.PieceType.CHECKER)


func get_bounds() -> Rect2i:
	match shape:
		BoardShape.SQUARE_OFFSET:
			var width: int = board_size * 64 - 32
			var height: int = board_size * 64
			
			@warning_ignore("integer_division")
			var rect_pos := Vector2i(-width / 2, -height / 2)
			var rect_size := Vector2i(width, height)
			
			return Rect2i(rect_pos, rect_size)
		BoardShape.HEXES_2_PLAYER:
			var width: int = 26 * (board_size + ((board_size + 1) >> 1)) + (
					13 if board_size % 2 == 0 else 0)
			var height: int = 53 + 69 * (board_size - 1)
			
			@warning_ignore("integer_division")
			var rect_pos := Vector2i(-width / 2, -height / 2)
			var rect_size := Vector2i(width, height)
			
			return Rect2i(rect_pos, rect_size)
	
	return Rect2i(0, 0, 0, 0)


func next_turn() -> void:
	is_in_chain_jump = false
	
	match turn:
		Piece.PieceColor.LIGHT:
			turn = Piece.PieceColor.DARK
		Piece.PieceColor.DARK:
			turn = Piece.PieceColor.LIGHT
