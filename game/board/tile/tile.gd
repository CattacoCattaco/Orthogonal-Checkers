class_name Tile
extends Sprite2D

enum TileShape {
	SQUARE,
	HEX_2_WAY,
	HEX_3_WAY,
}

enum TileColor {
	LIGHT,
	DARK,
	MID,
}

enum TileType {
	NORMAL,
	KING,
}

const PIECE_SCENE: PackedScene = preload("res://game/board/piece/piece.tscn")
const MOVE_DOT_SCENE: PackedScene = preload(
		"res://game/board/move_indicator_dot/move_indicator_dot.tscn")

var piece: Piece
var move_dot: MoveIndicatorDot

var color: TileColor = TileColor.LIGHT:
	set = _set_color

var type: TileType = TileType.NORMAL:
	set = _set_type

var shape: TileShape = TileShape.SQUARE

var pos: Vector2i

var board: Board


func _set_color(new_color: TileColor) -> void:
	color = new_color
	var atlas_region: Rect2 = texture.region
	atlas_region.position.x = atlas_region.size.x * color
	texture.region = atlas_region


func _set_type(new_type: TileType) -> void:
	type = new_type
	var atlas_region: Rect2 = texture.region
	atlas_region.position.y = atlas_region.size.y * type
	texture.region = atlas_region


func add_piece(piece_color: Piece.PieceColor, piece_type: Piece.PieceType) -> void:
	piece = PIECE_SCENE.instantiate()
	add_child(piece)
	
	var atlas_region: Rect2 = texture.region
	piece.position = (atlas_region.size as Vector2i - Vector2i(24, 24)) / 2
	
	piece.pos = pos
	piece.board = board
	piece.color = piece_color
	piece.type = piece_type


func remove_piece() -> void:
	piece.queue_free()
	piece = null


func add_move_dot(origin_piece: Piece, captured_piece: Piece = null) -> void:
	move_dot = MOVE_DOT_SCENE.instantiate()
	add_child(move_dot)
	board.move_dots.append(move_dot)
	
	var atlas_region: Rect2 = texture.region
	move_dot.position = (atlas_region.size as Vector2i - Vector2i(12, 12)) / 2
	
	move_dot.pos = pos
	move_dot.board = board
	move_dot.origin_piece = origin_piece
	move_dot.captured_piece = captured_piece


func remove_move_dot() -> void:
	board.move_dots.erase(move_dot)
	move_dot.queue_free()
	move_dot = null
