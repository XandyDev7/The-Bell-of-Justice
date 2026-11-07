extends Control

# proximaa do jogo 
const PROXIMA_CENA := "res://game/casa_sala.tscn"

const CARACTERES_POR_SEGUNDO := 30.0

const PAGINAS := [
	"Muito tempo atrás, existiam apenas duas raças nesse Continente - os elfos verdes e roxos. As raças viviam em eterno conflito, e possuíam um grande ódio entre si.",

	"Até que um dia, chegaram os humanos. Ao longo de centenas de anos, eles massacraram, escravizaram e deslocaram os elfos.",

	"No entanto, os humanos da atualidade tentam reparar o dano que seus antepassados causaram à raça elfa. Terras, casas e até cidades são atribuídas ao povo elfo.",

	"Porém, o ódio que existe entre os diferentes elfos ainda é profundo. Isso é extremamente aparente na cidade de Javelina, onde violência entre elfos é a norma.",

	"Você é o xerife humano dessa cidade. Um ativista elfo roxo acabou de ser assassinado, algo que pode ser presumido como um crime motivado por questões raciais.\n\nO seu trabalho agora é investigar. Boa sorte.",
]

@export var texto: RichTextLabel
@export var dica: Label

var _pagina := 0
var _progresso := 0.0
var _digitando := false
var _saindo := false


func _ready() -> void:
	texto.bbcode_enabled = true
	_mostrar_pagina()


func _mostrar_pagina() -> void:
	texto.text = PAGINAS[_pagina]
	texto.visible_characters = 0
	_progresso = 0.0
	_digitando = true
	dica.hide()                      # a dica só aparece quando o texto termina


func _process(delta: float) -> void:
	if not _digitando:
		return
	_progresso += CARACTERES_POR_SEGUNDO * delta
	texto.visible_characters = int(_progresso)
	if _progresso >= texto.get_total_character_count():
		_terminar_digitacao()


func _terminar_digitacao() -> void:
	texto.visible_characters = -1    # mostra todo o texto
	_digitando = false
	dica.show()


func _input(event: InputEvent) -> void:
	if _saindo:
		return
	if not event.is_action_pressed("ui_accept") or event.is_echo():
		return
	get_viewport().set_input_as_handled()

	if _digitando:
		_terminar_digitacao()        # 1º aperto: completa a página
	else:
		_pagina += 1                 # 2º aperto: próxima página
		if _pagina >= PAGINAS.size():
			_ir_para_o_jogo()
		else:
			_mostrar_pagina()


	if event is InputEventKey and event.pressed:
		print("tecla: ", event.as_text(), " | ui_accept: ", event.is_action_pressed("ui_accept"))

func _ir_para_o_jogo() -> void:
	_saindo = true
	get_tree().change_scene_to_file(PROXIMA_CENA)
