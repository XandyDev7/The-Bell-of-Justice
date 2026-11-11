extends StaticBody2D
class_name EstanteMovel


@export var conversa_id := "estante_estacao"
@export var flag_aberta := "estante_aberta"
@export var depurar := true

@export_group("Movimento")
@export var deslocamento := Vector2(-96, 0)   
@export var duracao := 1.4

@export_group("Dica")
@export var posicao_dica := Vector2(-6, -44)

var _perto := false
var _aberta := false
var _zona: Area2D
var _dica: Label
var _dica_visivel := false
var _tween: Tween


func _log(texto: String) -> void:
	if depurar:
		print("[Estante] ", texto)


func _ready() -> void:
	_zona = _achar_zona()
	_zona.collision_layer = 0
	_zona.collision_mask = 1
	_zona.monitorable = false
	_zona.body_entered.connect(_on_corpo_entrou)
	_zona.body_exited.connect(_on_corpo_saiu)

	_dica = Label.new()
	_dica.text = "Z"
	_dica.position = posicao_dica
	_dica.z_index = 20
	_dica.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dica.add_theme_font_size_override("font_size", 16)
	_dica.add_theme_color_override("font_outline_color", Color.BLACK)
	_dica.add_theme_constant_override("outline_size", 4)
	_dica.modulate.a = 0.0
	add_child(_dica)

	if deslocamento == Vector2.ZERO:
		push_warning("Estante: o Deslocamento está em (0, 0), ela não vai sair do lugar.")

	if Estado.tem(flag_aberta):
		_aberta = true
		position += deslocamento
		_log("a flag já existia: a estante nasce na posição final")

	_log("pronta | posição %s | deslocamento %s | flag '%s' | zona '%s'" % [position, deslocamento, flag_aberta, _zona.name])


func _achar_zona() -> Area2D:
	var lista := find_children("*", "Area2D", true, false)
	if not lista.is_empty():
		return lista[0] as Area2D
	push_warning("Estante sem Area2D: criei uma zona provisória.")
	var zona := Area2D.new()
	var forma := CollisionShape2D.new()
	var circulo := CircleShape2D.new()
	circulo.radius = 64.0
	forma.shape = circulo
	zona.add_child(forma)
	add_child(zona)
	return zona


func _process(_delta: float) -> void:
	if not _aberta and Estado.tem(flag_aberta):
		_abrir()

	var mostrar := _perto and not _aberta and not Dialogos.ativo
	if mostrar == _dica_visivel:
		return
	_dica_visivel = mostrar
	_animar_dica(1.0 if mostrar else 0.0)


func _abrir() -> void:
	_aberta = true
	_animar_dica(0.0)
	var destino := position + deslocamento
	_log("deslizando de %s para %s em %s s" % [position, destino, duracao])
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(self, "position", destino, duracao)


func _animar_dica(alvo: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_dica, "modulate:a", alvo, 0.15)


func _on_corpo_entrou(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		_perto = true
		_log("jogador ENTROU na zona")


func _on_corpo_saiu(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		_perto = false
		_log("jogador SAIU da zona")


func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F8:
		_log("F8: marcando a flag '%s' à força" % flag_aberta)
		Estado.marcar(flag_aberta)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept"):
		return
	_log("Z/Enter apertado | perto=%s | diálogo aberto=%s | já aberta=%s | tem arquivos=%s" % [_perto, Dialogos.ativo, _aberta, Estado.tem("arquivos_gangue")])
	if _aberta or not _perto or Dialogos.ativo:
		return
	get_viewport().set_input_as_handled()
	Dialogos.falar(conversa_id)
