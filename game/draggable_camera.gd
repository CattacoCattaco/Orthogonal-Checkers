class_name DraggableCamera
extends Camera2D

@export var board: Board


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("Drag"):
			position -= event.relative
			
			force_in_bound()


func force_in_bound() -> void:
	var board_area: Rect2i = board.get_bounds()
	
	if board_area.size.y < 340:
		position = Vector2(0, 0)
		return
	
	if position.y + 180 > board_area.end.y + 10:
		position.y = board_area.end.y - 170
	elif position.y - 180 < board_area.position.y - 10:
		position.y = board_area.position.y + 170
	
	if board_area.size.x < 620:
		position.x = 0
		return
	
	if position.x + 320 > board_area.end.x + 10:
		position.x = board_area.end.x - 310
	elif position.x - 320 < board_area.position.x - 10:
		position.x = board_area.position.x + 310
