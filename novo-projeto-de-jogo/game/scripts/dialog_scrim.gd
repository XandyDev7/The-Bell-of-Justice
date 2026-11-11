extends Control
class_name dialogScrim

signal dialogo_terminado

const CARACTERES_POR_SEGUNDO := 35.0

@export_category("Objetos")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

@export_category("Opções")
@export var folga_acima_da_caixa := 56.0   # distância entre os botões e a caixa de texto

var data: Array = []
var _id := 0
var _progresso := 0.0
var _digitando := false
var _tempo_auto := -1.0        # contagem para a fala passar sozinha
var _encerrando := false

var _painel: PanelContainer = null
var _opcoes_ativas := false
var _retornos: Array = []      # para voltar ao menu depois de uma resposta
var _usadas := {}              


func _ready() -> void:
	_dialog.bbcode_enabled = true
	if data.is_empty():
		push_warning("dialogScrim iniciado sem falas.")
		_encerrar()
		return
	_mostrar_fala()


func _mostrar_fala(instantaneo := false) -> void:
	_fechar_opcoes()
	_tempo_auto = -1.0
	var fala: Dictionary = data[_id]
	_name.text = fala.get("title", "")
	_dialog.text = fala.get("dialog", "")

	var caminho: String = fala.get("faceset", "")
	if caminho != "" and ResourceLoader.exists(caminho):
		_faceset.texture = load(caminho)
	else:
		_faceset.texture = null
		if caminho != "":
			push_warning("Retrato não encontrado: '" + caminho + "'")

	if not instantaneo:
		_aplicar_efeitos(fala)

	_dialog.visible_characters = 0
	_progresso = 0.0
	_digitando = true
	if instantaneo:
		_terminar_digitacao()


func _aplicar_efeitos(fala: Dictionary) -> void:
	if fala.has("som"):
		Audio.tocar(str(fala["som"]))
	if fala.has("flag"):
		for f in _como_lista(fala["flag"]):
			Estado.marcar(str(f))
	if fala.has("item"):
		for i in _como_lista(fala["item"]):
			Estado.pegar_item(str(i))


func _como_lista(valor: Variant) -> Array:
	if valor is Array:
		return valor
	return [valor]


func _process(delta: float) -> void:
	if _digitando:
		_progresso += CARACTERES_POR_SEGUNDO * delta
		_dialog.visible_characters = int(_progresso)
		if _progresso >= _dialog.get_total_character_count():
			_terminar_digitacao()
	elif _tempo_auto >= 0.0:
		_tempo_auto -= delta
		if _tempo_auto < 0.0:
			_tempo_auto = -1.0
			_proxima_fala()


func _terminar_digitacao() -> void:
	_dialog.visible_characters = -1
	_digitando = false
	var fala: Dictionary = data[_id]
	if fala.has("opcoes"):
		_mostrar_opcoes(fala["opcoes"])
	elif fala.has("auto"):
		_tempo_auto = float(fala["auto"])


func _input(event: InputEvent) -> void:
	if _opcoes_ativas or _encerrando:
		return   
	if not event.is_action_pressed("ui_accept") or event.is_echo():
		return
	get_viewport().set_input_as_handled()
	if _digitando:
		_terminar_digitacao()
	else:
		_proxima_fala()


func _proxima_fala() -> void:
	if _encerrando:
		return
	_tempo_auto = -1.0
	_id += 1
	if _id >= data.size():
		if _retornos.is_empty():
			_encerrar()
		else:
			var r: Dictionary = _retornos.pop_back()
			data = r["data"]
			_id = r["id"]
			_mostrar_fala(true)
	else:
		_mostrar_fala()



func _opcao_disponivel(op: Dictionary) -> bool:
	var requer: String = op.get("requer", "")
	if requer != "" and not Estado.tem(requer):
		return false
	var oculta: String = op.get("oculta_se", "")
	if oculta != "" and Estado.tem(oculta):
		return false
	if op.get("uma_vez", false) and _usadas.has(op.get("texto", "")):
		return false
	return true


func _mostrar_opcoes(lista: Array) -> void:
	_fechar_opcoes()

	var caixa := VBoxContainer.new()
	caixa.add_theme_constant_override("separation", 4)
	var primeiro: Button = null

	for op in lista:
		if not _opcao_disponivel(op):
			continue
		var b := Button.new()
		b.text = op.get("texto", "...")
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_estilizar(b)
		b.pressed.connect(_escolher.bind(op))
		caixa.add_child(b)
		if primeiro == null:
			primeiro = b

	if primeiro == null:
		caixa.free()
		_proxima_fala()
		return

	_painel = PanelContainer.new()
	_painel.custom_minimum_size.x = 240.0
	_painel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	_painel.add_child(caixa)
	add_child(_painel)
	_opcoes_ativas = true

	await get_tree().process_frame
	if not is_instance_valid(_painel):
		return
	var tela := get_viewport_rect().size
	var topo := _dialog.get_global_rect().position.y
	_painel.global_position = Vector2(
		tela.x - _painel.size.x - 16.0,
		topo - _painel.size.y - folga_acima_da_caixa)
	primeiro.grab_focus()


func _escolher(op: Dictionary) -> void:
	_fechar_opcoes()
	_usadas[op.get("texto", "")] = true

	if op.has("flag"):
		for f in _como_lista(op["flag"]):
			Estado.marcar(str(f))
	if op.has("item"):
		for i in _como_lista(op["item"]):
			Estado.pegar_item(str(i))

	var destino: String = op.get("conversa", "")
	if destino == "":
		_encerrar()
		return

	var novas: Array = Dialogos.montar(destino)
	if novas.is_empty():
		_encerrar()
		return

	if op.get("volta", false):
		_retornos.append({"data": data, "id": _id})
	data = novas
	_id = 0
	_mostrar_fala()


func _fechar_opcoes() -> void:
	_opcoes_ativas = false
	if _painel != null:
		_painel.queue_free()
		_painel = null



func _estilo(fundo: Color, borda: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = fundo
	s.border_color = borda
	s.set_border_width_all(3)
	s.set_corner_radius_all(10)
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	return s


func _estilizar(b: Button) -> void:
	var normal := _estilo(Color.WHITE, Color.BLACK)
	var destaque := _estilo(Color(0.86, 0.83, 0.95), Color(0.36, 0.25, 0.65))

	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", destaque)
	b.add_theme_stylebox_override("focus", destaque)
	b.add_theme_stylebox_override("pressed", destaque)

	b.add_theme_color_override("font_color", Color.BLACK)
	b.add_theme_color_override("font_hover_color", Color(0.36, 0.25, 0.65))
	b.add_theme_color_override("font_focus_color", Color(0.36, 0.25, 0.65))
	b.add_theme_color_override("font_pressed_color", Color(0.36, 0.25, 0.65))

	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _encerrar() -> void:
	if _encerrando:
		return
	_encerrando = true
	dialogo_terminado.emit()
	queue_free()
