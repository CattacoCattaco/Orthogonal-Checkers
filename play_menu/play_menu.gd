class_name PlayMenu
extends Control

@export var board_scene: PackedScene
@export var board_type_options: OptionButton
@export var board_size_box: SpinBox
@export var checker_diagonals_box: SpinBox
@export var start_button: TextureButton


func _ready() -> void:
	board_type_options.item_selected.connect(update_max_checker_diagonals)
	board_size_box.value_changed.connect(update_max_checker_diagonals)
	start_button.pressed.connect(_start_game)


func update_max_checker_diagonals(value: float) -> void:
	match board_type_options.selected:
		0:
			checker_diagonals_box.max_value = board_size_box.value - 1
		1:
			checker_diagonals_box.max_value = board_size_box.value * 2


func _start_game() -> void:
	var game: Node2D = board_scene.instantiate()
	
	var board: Board = game.get_child(0)
	
	match board_type_options.selected:
		0:
			board.shape = Board.BoardShape.SQUARE_OFFSET
			board.tile_scene = preload("res://game/board/tile/square/square_tile.tscn")
		1:
			board.shape = Board.BoardShape.HEXES_2_PLAYER
			board.tile_scene = preload("res://game/board/tile/hex/hex_tile.tscn")
	
	board.board_size = board_size_box.value as int
	board.checker_diagonals = checker_diagonals_box.value as int
	
	board.play_menu = self
	
	get_tree().root.add_child(game)
	get_tree().root.remove_child(self)
