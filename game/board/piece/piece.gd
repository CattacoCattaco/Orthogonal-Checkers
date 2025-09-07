class_name Piece
extends Sprite2D

enum PieceColor {
	LIGHT,
	DARK,
	MID,
}

@export var button: TextureButton

var color: PieceColor = PieceColor.LIGHT:
	set = set_color

var pos: Vector2i

var board: Board


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	if board.selected_piece != self:
		select()
	else:
		deselect()


func deselect() -> void:
	var old_move_dots: Array[MoveIndicatorDot] = board.move_dots.duplicate()
	
	for move_dot in old_move_dots:
		board.tiles[move_dot.pos].remove_move_dot()
	
	if board.selected_piece == self:
		board.selected_piece = null


func select() -> void:
	if board.selected_piece:
		board.selected_piece.deselect()
	
	board.selected_piece = self
	
	for direction in get_move_directions():
		var tile: Tile = board.tiles[pos + direction]
		
		if not tile.piece:
			tile.add_move_dot()


func get_move_directions() -> Array[Vector2i]:
	if color == PieceColor.LIGHT:
		return [Vector2i(-1, 0), Vector2i(0, -1)]
	elif color == PieceColor.DARK:
		return [Vector2i(1, 0), Vector2i(0, 1)]
	
	return []


func set_color(new_color: PieceColor) -> void:
	color = new_color
	var atlas_region: Rect2 = texture.region
	atlas_region.position.x = atlas_region.size.x * color
	texture.region = atlas_region
