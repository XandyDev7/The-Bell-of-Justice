extends Area2D
class_name PortaInterativa


@export_file("*.tscn") var cena_destino := ""
@export var spawn_destino := ""

@export_group("Condições")
@export var flag_ativa := ""              
@export var requisito := ""                
@export var conversa_sem_requisito := ""  
@export var conversa_ao_abrir := ""        
@export var flag_ja_aberta := ""          

@export_group("Dica")
@export var posicao_dica := Vector2(-6, -44)

var _perto := false
var _dica: Label
var _dica_visivel := false
var _tween: Tween


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	monitorable = false
	body_entered.connect(_on_corpo_entrou)
	body_exited.connect(_on_corpo_saiu)

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


func _ativa() -> bool:
	return flag_ativa == "" or Estado.tem(flag_ativa)


func _process(_delta: float) -> void:
	var mostrar := _perto and _ativa() and not Dialogos.ativo
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
	if not _perto or Dialogos.ativo or not _ativa():
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_usar()


func _usar() -> void:
	if requisito != "" and not Estado.tem(requisito):
		if conversa_sem_requisito != "":
			Dialogos.falar(conversa_sem_requisito)
		return

	var ja_aberta := flag_ja_aberta != "" and Estado.tem(flag_ja_aberta)
	if conversa_ao_abrir != "" and not ja_aberta:
		# toca a conversa e, quando ela terminar, entra na cena de destino
		Dialogos.falar_e_ir(conversa_ao_abrir, cena_destino, spawn_destino)
	else:
		_entrar()


func _entrar() -> void:
	if cena_destino == "":
		push_warning("PortaInterativa sem Cena Destino: " + name)
		return
	Estado.spawn = spawn_destino
	get_tree().change_scene_to_file.call_deferred(cena_destino)
