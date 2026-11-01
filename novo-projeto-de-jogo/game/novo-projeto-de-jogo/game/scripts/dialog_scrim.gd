extends Control
class_name dialogScrim

signal dialogo_terminado


const CARACTERES_POR_SEGUNDO := 35.0

@export_category("Objetos")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

var data: Array = []          # lista de falas
var _id := 0
var _progresso := 0.0         # quantos caracteres já foram mostrados
var _digitando := false


func _ready() -> void:
	_dialog.bbcode_enabled = true
	if data.is_empty():
		push_warning("dialogScrim iniciado sem falas.")
		_encerrar()
		return
	_mostrar_fala()


func _mostrar_fala() -> void:
	var fala: Dictionary = data[_id]
	_name.text = fala.get("title", "")
	_dialog.text = fala.get("dialog", "")

	var caminho: String = fala.get("faceset", "")
	if caminho != "" and ResourceLoader.exists(caminho):
		_faceset.texture = load(caminho)
	else:
		_faceset.texture = null
		push_warning("Retrato não encontrado: '" + caminho + "'")

	_dialog.visible_characters = 0
	_progresso = 0.0
	_digitando = true


func _process(delta: float) -> void:
	if not _digitando:
		return
	_progresso += CARACTERES_POR_SEGUNDO * delta
	_dialog.visible_characters = int(_progresso)
	if _progresso >= _dialog.get_total_character_count():
		_terminar_digitacao()


func _terminar_digitacao() -> void:
	_dialog.visible_characters = -1   # mostra tudo
	_digitando = false


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept") or event.is_echo():
		return
	get_viewport().set_input_as_handled()

	if _digitando:
		_terminar_digitacao()          # 1º aperto: completa o texto
	else:
		_id += 1                       # 2º aperto: próxima fala
		if _id >= data.size():
			_encerrar()
		else:
			_mostrar_fala()


func _encerrar() -> void:
	dialogo_terminado.emit()
	queue_free()
