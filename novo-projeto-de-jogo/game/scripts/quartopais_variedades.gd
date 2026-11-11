extends Node2D


@export_group("Acesso (trava de segurança)")
@export var requisitos: Array[String] = []         
@export_file("*.tscn") var cena_de_volta := ""     
@export var spawn_de_volta := ""                   

@export_group("Ao entrar na sala")
@export var som_ao_entrar := ""
@export var conversa_ao_entrar := ""
@export var flag_ao_entrar := ""    
@export var atraso := 0.6            # segundos entre o som e a fala

@export_group("Só para teste (F6)")
@export var liberar_para_teste: Array[String] = []


func _ready() -> void:
	if not Estado.jogo_iniciou:
		for x in liberar_para_teste:
			Estado.pegar_item(x)

	if not _acesso_liberado():
		push_warning("Acesso negado a '%s'. Faltando: %s" % [name, str(_faltando())])
		if cena_de_volta != "":
			Estado.spawn = spawn_de_volta
			get_tree().change_scene_to_file.call_deferred(cena_de_volta)
			return
		push_warning("A sala '%s' não tem 'Cena De Volta': deixei o jogador entrar." % name)

	_posicionar_jogador()
	_evento_de_entrada()


func _faltando() -> Array:
	var falta := []
	for r in requisitos:
		if not Estado.tem(r):
			falta.append(r)
	return falta


func _acesso_liberado() -> bool:
	if not Estado.jogo_iniciou:
		return true     # testando com F6: não trava
	return _faltando().is_empty()


func _posicionar_jogador() -> void:
	if Estado.spawn == "":
		return
	
	await get_tree().process_frame
	
	var jogador := get_tree().get_first_node_in_group("jogador")
	var ponto := get_node_or_null("Spawns/" + Estado.spawn)
	
	if jogador != null and ponto != null:
		jogador.global_position = ponto.global_position
	elif ponto == null:
		push_warning("Spawn não encontrado: " + Estado.spawn)
	
	Estado.spawn = ""


func _evento_de_entrada() -> void:
	if som_ao_entrar == "" and conversa_ao_entrar == "":
		return
	if flag_ao_entrar != "":
		if Estado.tem(flag_ao_entrar):
			return
		Estado.marcar(flag_ao_entrar)

	if som_ao_entrar != "":
		Audio.tocar(som_ao_entrar)
	if conversa_ao_entrar != "":
		get_tree().create_timer(atraso).timeout.connect(_abrir_conversa)


func _abrir_conversa() -> void:
	Dialogos.falar(conversa_ao_entrar)
