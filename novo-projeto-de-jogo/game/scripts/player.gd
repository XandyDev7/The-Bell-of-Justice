extends CharacterBody2D

@export var velocidade := 140.0   
const ANIMACOES := {
	"idle_down": "idle",
	"idle_up": "back",
	"idle_left": "left",
	"idle_right": "right",
	"walk_down": "front_walk",
	"walk_up": "back",
	"walk_left": "left_walk",
	"walk_right": "right_walk",
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var direcao_olhando := Vector2.DOWN
var _prioridade_horizontal := true


func _ready() -> void:
	add_to_group("jogador")
	for nome in ANIMACOES.values():
		if not sprite.sprite_frames.has_animation(nome):
			push_warning("Animação não encontrada no SpriteFrames: " + nome)
	_tocar("idle", _nome_direcao(direcao_olhando))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		_prioridade_horizontal = true
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		_prioridade_horizontal = false


func _physics_process(_delta: float) -> void:
	# durante um diálogo, o jogador fica parado
	if Dialogos.ativo:
		velocity = Vector2.ZERO
		_tocar("idle", _nome_direcao(direcao_olhando))
		return

	var dir := _ler_direcao()
	velocity = dir * velocidade

	if dir != Vector2.ZERO:
		direcao_olhando = dir

	move_and_slide()
	_tocar("walk" if dir != Vector2.ZERO else "idle", _nome_direcao(direcao_olhando))


func _ler_direcao() -> Vector2:
	var x := Input.get_axis("ui_left", "ui_right")
	var y := Input.get_axis("ui_up", "ui_down")

	# só 4 direções: se duas setas estiverem apertadas, vale a última
	if x != 0 and y != 0:
		if _prioridade_horizontal:
			y = 0
		else:
			x = 0

	return Vector2(x, y)


func _nome_direcao(v: Vector2) -> String:
	if v.x < 0:
		return "left"
	if v.x > 0:
		return "right"
	if v.y < 0:
		return "up"
	return "down"


func _tocar(estado: String, direcao: String) -> void:
	var nome: String = ANIMACOES.get(estado + "_" + direcao, "")
	if nome == "" or not sprite.sprite_frames.has_animation(nome):
		return

	sprite.flip_h = false

	var parado := estado == "idle"
	var igual_a_andar: bool = ANIMACOES.get("walk_" + direcao, "") == nome
	if parado and igual_a_andar:
		sprite.animation = nome
		sprite.stop()
		sprite.frame = 0
		return

	if sprite.animation != nome or not sprite.is_playing():
		sprite.play(nome)
