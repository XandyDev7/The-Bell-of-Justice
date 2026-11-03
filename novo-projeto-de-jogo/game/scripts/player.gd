extends CharacterBody2D

const VELOCIDADE := 80.0    # pixels por segundo

var direcao_olhando := Vector2.DOWN   # para onde o jogador está virado
var _prioridade_horizontal := true    # quem manda se duas setas estiverem apertadas


func _unhandled_input(event: InputEvent) -> void:
	# guarda qual eixo foi apertado por último
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		_prioridade_horizontal = true
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		_prioridade_horizontal = false

#_physics_process roda em intervalos fixos (60 vezes por segundo) e é o lugar certo para mover corpos com física.
func _physics_process(_delta: float) -> void:
	# durante um diálogo, o jogador fica parado
	if Dialogos.ativo:
		velocity = Vector2.ZERO
		return

	var dir := _ler_direcao()
	velocity = dir * VELOCIDADE

	if dir != Vector2.ZERO:
		direcao_olhando = dir

	move_and_slide()


func _ler_direcao() -> Vector2:
	var x := Input.get_axis("ui_left", "ui_right")   # -1, 0 ou 1
	var y := Input.get_axis("ui_up", "ui_down")      # -1, 0 ou 1

	# só 4 direções: se duas setas estiverem apertadas, vale a última
	if x != 0 and y != 0:
		if _prioridade_horizontal:
			y = 0
		else:
			x = 0

	return Vector2(x, y)
	
	
	
	
	
	
