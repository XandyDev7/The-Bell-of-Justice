extends StaticBody2D


@export var conversa_id := "vendedor_1"
@export var mostrar_dica := true

@export_group("Animação")
@export var animacao := "idle"
@export var frames: SpriteFrames   

@export_group("Nós (opcional - o script acha sozinho)")
@export var zona: Area2D
@export var dica: Label
@export var sprite: AnimatedSprite2D

var _jogador_perto := false
var _dica_visivel := false
var _tween: Tween


func _ready() -> void:
	_achar_nos()
	_preparar_animacao()
	_preparar_zona()
	_preparar_dica()


func _achar(tipo: String) -> Node:
	var lista := find_children("*", tipo, true, false)
	if lista.is_empty():
		return null
	return lista[0]


func _achar_nos() -> void:
	if sprite == null:
		sprite = _achar("AnimatedSprite2D") as AnimatedSprite2D
	if zona == null:
		zona = _achar("Area2D") as Area2D
	if dica == null:
		dica = _achar("Label") as Label

	if zona == null:
		push_warning("NPC '" + name + "' sem Area2D: criei uma zona provisória.")
		zona = Area2D.new()
		var forma := CollisionShape2D.new()
		var circulo := CircleShape2D.new()
		circulo.radius = 56.0
		forma.shape = circulo
		zona.add_child(forma)
		add_child(zona)

	if dica == null:
		dica = Label.new()
		dica.text = "Z"
		dica.position = Vector2(-6, -44)
		dica.z_index = 20
		dica.add_theme_font_size_override("font_size", 16)
		dica.add_theme_color_override("font_outline_color", Color.BLACK)
		dica.add_theme_constant_override("outline_size", 4)
		add_child(dica)


func _preparar_animacao() -> void:
	if sprite == null:
		return
	if frames != null:
		sprite.sprite_frames = frames
	if sprite.sprite_frames == null:
		return

	if sprite.sprite_frames.has_animation(animacao):
		sprite.play(animacao)
	else:
		var nomes := sprite.sprite_frames.get_animation_names()
		if nomes.size() > 0:
			sprite.play(nomes[0])


func _preparar_zona() -> void:
	zona.collision_layer = 0
	zona.collision_mask = 1
	zona.monitorable = false
	zona.body_entered.connect(_on_corpo_entrou)
	zona.body_exited.connect(_on_corpo_saiu)


func _preparar_dica() -> void:
	dica.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dica.modulate.a = 0.0


func _process(_delta: float) -> void:
	var deve_mostrar := mostrar_dica and _jogador_perto and not Dialogos.ativo
	if deve_mostrar == _dica_visivel:
		return
	_dica_visivel = deve_mostrar

	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(dica, "modulate:a", 1.0 if deve_mostrar else 0.0, 0.15)


func _on_corpo_entrou(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		_jogador_perto = true


func _on_corpo_saiu(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		_jogador_perto = false


func _unhandled_input(event: InputEvent) -> void:
	if not _jogador_perto or Dialogos.ativo:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		Dialogos.falar(conversa_id)
