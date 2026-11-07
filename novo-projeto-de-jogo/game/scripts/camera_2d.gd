extends Camera2D

@export var player: Node2D

var tamanho_tela := Vector2(640, 360)


func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	position_smoothing_enabled = false

	# lê o tamanho do viewport nas configurações e leva o zoom em conta
	var base := Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	tamanho_tela = base / zoom

	_atualizar()


func _process(_delta: float) -> void:
	_atualizar()


func _atualizar() -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("jogador")
		if player == null:
			return
	var celula := (player.global_position / tamanho_tela).floor()
	global_position = celula * tamanho_tela
