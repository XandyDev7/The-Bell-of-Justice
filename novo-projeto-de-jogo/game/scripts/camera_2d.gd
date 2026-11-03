
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
extends Camera2D  

@export var player: Node2D
@export var tamanho_tela := Vector2(480, 270)  # tamanho da tela do jogo

func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT #a camra vai vir da esquerda
	position_smoothing_enabled = false
	_atualizar()

func _process(_delta: float) -> void:
	_atualizar()

func _atualizar() -> void:
	if player == null:
		return
	var celula := (player.global_position / tamanho_tela).floor()
	global_position = celula * tamanho_tela
