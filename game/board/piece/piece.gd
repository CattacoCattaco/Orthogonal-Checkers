class_name Piece
extends Sprite2D

enum PieceColor {
	LIGHT,
	DARK,
	MID,
}

enum PieceType {
	CHECKER,
	CHECKER_KING,
}

@export var button: TextureButton

var color: PieceColor = PieceColor.LIGHT:
	set = _set_color

var type: PieceType = PieceType.CHECKER:
	set = _set_type

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
	
	if board.turn == color:
		board.selected_piece = self
		
		find_moves()


func find_moves(jumps_only: bool = false) -> bool:
	var move_found: bool = false
	
	for direction in get_move_directions():
		if not board.tiles.has(pos + direction):
			continue
		
		var tile: Tile = board.tiles[pos + direction]
		
		if not tile.piece:
			if not jumps_only:
				tile.add_move_dot(self)
				
				move_found = true
		elif tile.piece.color != color and board.tiles.has(pos + direction * 2):
			var jumpable_piece: Piece = tile.piece
			tile = board.tiles[pos + direction * 2]
			
			if not tile.piece:
				tile.add_move_dot(self, jumpable_piece)
				
				move_found = true
	
	return move_found


func get_move_directions() -> Array[Vector2i]:
	match type:
		PieceType.CHECKER:
			if color == PieceColor.LIGHT:
				return [Vector2i(-1, 0), Vector2i(0, -1)]
			elif color == PieceColor.DARK:
				return [Vector2i(1, 0), Vector2i(0, 1)]
		PieceType.CHECKER_KING:
			return [Vector2i(-1, 0), Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1)]
	
	return []


func can_chain_jump() -> bool:
	match type:
		PieceType.CHECKER:
			return find_moves(true)
		PieceType.CHECKER_KING:
			return find_moves(true)
		_:
			return false


func can_promote() -> bool:
	match type:
		PieceType.CHECKER:
			return true
		_:
			return false


func promote() -> void:
	type = PieceType.CHECKER_KING


func _set_color(new_color: PieceColor) -> void:
	color = new_color
	var atlas_region: Rect2 = texture.region
	atlas_region.position.x = atlas_region.size.x * color
	texture.region = atlas_region


func _set_type(new_type: PieceType) -> void:
	type = new_type
	var atlas_region: Rect2 = texture.region
	atlas_region.position.y = atlas_region.size.y * type
	texture.region = atlas_region
