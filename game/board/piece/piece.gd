class_name Piece
extends Sprite2D

enum PieceColor {
	LIGHT,
	DARK,
	MID,
}

var color: PieceColor = PieceColor.LIGHT:
	set = set_color

var pos: Vector2i


func set_color(new_color: PieceColor) -> void:
	color = new_color
	var atlas_region: Rect2 = texture.region
	atlas_region.position.x = atlas_region.size.x * color
	texture.region = atlas_region
