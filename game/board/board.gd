class_name Board
extends Node2D

## The scene of the tiles
@export var tile_scene: PackedScene
## Directions that light pieces can move in
@export var light_directions: Array[Vector2i]
## Directions that dark pieces can move in
@export var dark_directions: Array[Vector2i]
## Directions that mid-colored pieces can move in
@export var mid_directions: Array[Vector2i]
## The number of tiles in each diagonal
@export var board_size: int = 4
## The number of diagonals with checkers on them that each side gets
@export var checker_diagonals: int = 3

var tiles: Dictionary[Vector2i, Tile]


func _ready() -> void:
	_place_tiles()


func _place_tiles() -> void:
	for dark_diagonal in range(board_size):
		var has_dark_pieces: bool = dark_diagonal < ceili(checker_diagonals / 2.0)
		var has_light_pieces: bool = dark_diagonal >= board_size - floori(checker_diagonals / 2.0)
		var diagonal_start := Vector2i(0, board_size - 1) + Vector2i(1, 1) * dark_diagonal
		
		for column in range(board_size):
			var board_pos := diagonal_start + Vector2i(1, -1) * column
			_place_tile(board_pos, Tile.TileColor.DARK, has_dark_pieces, has_light_pieces, false)
	
	for light_diagonal in range(board_size):
		var has_dark_pieces: bool = light_diagonal < floori(checker_diagonals / 2.0)
		var has_light_pieces: bool = light_diagonal >= board_size - ceili(checker_diagonals / 2.0)
		var diagonal_start := Vector2i(0, board_size) + Vector2i(1, 1) * light_diagonal
		
		for column in range(board_size):
			var board_pos := diagonal_start + Vector2i(1, -1) * column
			_place_tile(board_pos, Tile.TileColor.LIGHT, has_dark_pieces, has_light_pieces, false)


func _place_tile(board_pos: Vector2i, color: Tile.TileColor, place_dark: bool, place_light: bool,
		place_mid: bool) -> void:
	var tile: Tile = tile_scene.instantiate()
	add_child(tile)
	tiles[board_pos] = tile
	
	tile.pos = board_pos
	tile.position = tile.pos * 32 + Vector2i(-board_size * 32 + 16, -board_size * 32)
	tile.color = color
	
	if place_dark or place_light or place_mid:
		var piece_color: Piece.PieceColor = (
				Piece.PieceColor.DARK if place_dark
				else Piece.PieceColor.LIGHT if place_light
				else Piece.PieceColor.MID
		)
		
		print(piece_color)
		
		tile.add_piece(piece_color)
