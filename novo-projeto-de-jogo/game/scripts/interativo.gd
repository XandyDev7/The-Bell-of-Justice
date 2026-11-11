extends Area2D
class_name Interativo


@export var conversa_id := ""
@export var texto_dica := "Z"
@export var posicao_dica := Vector2(-6, -44)

@export_group("Aparecer / sumir")
@export var flag_oculto := ""      
@export var flag_visivel := ""     

var _perto := false
var _dica: Label
var _dica_visivel := false
var _tween: Tween


func _ready() -> void:
	if flag_visivel != "" and not Estado.tem(flag_visivel):
		queue_free()
		return
	if flag_oculto != "" and Estado.tem(flag_oculto):
		queue_free()
		return
	if conversa_id == "":
		push_warning("Interativo sem Conversa Id: " + name)

	collision_layer = 0
	collision_mask = 1
	monitorable = false
	body_entered.connect(_on_corpo_entrou)
	body_exited.connect(_on_corpo_saiu)

	_dica = Label.new()
	_dica.text = texto_dica
	_dica.position = posicao_dica
	_dica.z_index = 20
	_dica.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dica.add_theme_font_size_override("font_size", 16)
	_dica.add_theme_color_override("font_outline_color", Color.BLACK)
	_dica.add_theme_constant_override("outline_size", 4)
	_dica.modulate.a = 0.0          # começa invisível
	add_child(_dica)


func _process(_delta: float) -> void:
	if _dica == null:
		return
	var mostrar := _perto and not Dialogos.ativo
	if mostrar == _dica_visivel:
		return
	_dica_visivel = mostrar
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_dica, "modulate:a", 1.0 if mostrar else 0.0, 0.15)


func _on_corpo_entrou(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		_perto = true


func _on_corpo_saiu(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		_perto = false


func _unhandled_input(event: InputEvent) -> void:
	if conversa_id == "" or not _perto or Dialogos.ativo:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		Dialogos.falar(conversa_id)
