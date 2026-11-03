extends StaticBody2D

@export var conversa_id := "vendedor_1"
@export var mostrar_dica := true     # desligue para NPCs sem dica de "Z"
@export var zona: Area2D
@export var dica: Label
@export var sprite: AnimatedSprite2D
@export var frames: SpriteFrames
@export var animacao := "idle"

var _jogador_perto := false
var _dica_visivel := false
var _tween: Tween


func _ready() -> void:
	if sprite:
		if frames:
			sprite.sprite_frames = frames
			_tocar_animacao()
	# a zona só DETECTA o jogador: não é um objeto físico e não bloqueia nada
	zona.collision_layer = 0      # ninguém "enxerga" a zona
	zona.collision_mask = 1       # ela enxerga a camada 1 (o jogador)
	zona.monitorable = false
	zona.body_entered.connect(_on_corpo_entrou)
	zona.body_exited.connect(_on_corpo_saiu)

	# o "Z" é só um desenho: sem mouse e começa invisível
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
		
		
		
		
		
func _tocar_animacao() -> void:
	if sprite.sprite_frames == null:
		return
	if sprite.sprite_frames.has_animation(animacao):
		sprite.play(animacao)
	else:
		# se o nome não existe, toca a primeira animação que achar
		var nomes := sprite.sprite_frames.get_animation_names()
		if nomes.size() > 0:
			sprite.play(nomes[0])
