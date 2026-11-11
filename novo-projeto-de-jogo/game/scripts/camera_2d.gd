extends Camera2D


@export var player: Node2D
@export var limites_manuais := Rect2(0, 0, 640, 360)

var _limites := Rect2()
var _tela := Vector2(640, 360)


func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	position_smoothing_enabled = false

	var base := Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))
	_tela = base / zoom

	_limites = _ler_limites()
	_atualizar()


func _process(_delta: float) -> void:
	_atualizar()


func _ler_limites() -> Rect2:
	var pai := get_parent()
	if pai != null:
		for filho in pai.get_children():
			if filho is ColorRect and filho.name.to_lower() == "piso":
				return Rect2(filho.global_position, filho.size)
	return limites_manuais


func _atualizar() -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("jogador") as Node2D
		if player == null:
			return
	var p := player.global_position
	global_position = Vector2(
		_eixo(p.x, _limites.position.x, _limites.size.x, _tela.x),
		_eixo(p.y, _limites.position.y, _limites.size.y, _tela.y)
	).round()


func _eixo(jogador: float, inicio: float, tam_sala: float, tam_tela: float) -> float:
	if tam_sala <= tam_tela:
		return inicio + tam_sala / 2.0 - tam_tela / 2.0

	var paginas := ceilf(tam_sala / tam_tela)
	var pagina := clampf(floorf((jogador - inicio) / tam_tela), 0.0, paginas - 1.0)
	var pos := inicio + pagina * tam_tela
	return minf(pos, inicio + tam_sala - tam_tela)
