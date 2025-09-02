class_name Tile
extends Sprite2D

enum TileColor {
	LIGHT,
	DARK,
	MID,
}

const PIECE_SCENE: PackedScene = preload("res://game/board/piece/piece.tscn")

var color: TileColor = TileColor.LIGHT:
	set = set_color

var pos: Vector2i


func set_color(new_color: TileColor) -> void:
	color = new_color
	var atlas_region: Rect2 = texture.region
	atlas_region.position.x = atlas_region.size.x * color
	texture.region = atlas_region


func add_piece(piece_color: Piece.PieceColor) -> void:
	var piece: Piece = PIECE_SCENE.instantiate()
	add_child(piece)
	
	var atlas_region: Rect2 = texture.region
	piece.position = (atlas_region.size as Vector2i - Vector2i(24, 24)) / 2
	
	piece.pos = pos
	piece.color = piece_color
