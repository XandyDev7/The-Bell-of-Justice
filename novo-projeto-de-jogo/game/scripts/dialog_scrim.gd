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

var _painel: PanelContainer = null
var _opcoes_ativas := false
var _retornos: Array = []      
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

	_dialog.visible_characters = 0
	_progresso = 0.0
	_digitando = true
	if instantaneo:
		_terminar_digitacao()


func _process(delta: float) -> void:
	if not _digitando:
		return
	_progresso += CARACTERES_POR_SEGUNDO * delta
	_dialog.visible_characters = int(_progresso)
	if _progresso >= _dialog.get_total_character_count():
		_terminar_digitacao()


func _terminar_digitacao() -> void:
	_dialog.visible_characters = -1
	_digitando = false
	if data[_id].has("opcoes"):
		_mostrar_opcoes(data[_id]["opcoes"])


func _input(event: InputEvent) -> void:
	if _opcoes_ativas:
		return    
	if not event.is_action_pressed("ui_accept") or event.is_echo():
		return
	get_viewport().set_input_as_handled()
	if _digitando:
		_terminar_digitacao()
	else:
		_proxima_fala()


func _proxima_fala() -> void:
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


func _mostrar_opcoes(lista: Array) -> void:
	_fechar_opcoes()

	var caixa := VBoxContainer.new()
	caixa.add_theme_constant_override("separation", 4)
	var primeiro: Button = null

	for op in lista:
		var exigida: String = op.get("requer", "")
		if exigida != "" and not Estado.tem(exigida):
			continue
		if op.get("uma_vez", false) and _usadas.has(op.get("texto", "")):
			continue
		var b := Button.new()
		b.text = op.get("texto", "...")
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
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

	var flag: String = op.get("flag", "")
	if flag != "":
		Estado.marcar(flag)

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


func _encerrar() -> void:
	dialogo_terminado.emit()
	queue_free()
