extends Area2D

@export_file("*.tscn") var cena_destino := ""
@export var spawn_destino := ""
@export var flags_necessarias: Array[String] = []
@export var mensagem_trancada := "A porta está trancada."
@export var sempre_trancada := false

var _armada := false


func _ready() -> void:
	body_entered.connect(_on_corpo_entrou)
	await get_tree().create_timer(0.6).timeout
	_armada = true


func _on_corpo_entrou(corpo: Node2D) -> void:
	if not _armada or not corpo.is_in_group("jogador"):
		return
	if sempre_trancada or not _liberada():
		Dialogos.aviso(mensagem_trancada)
		return
	if cena_destino == "":
		push_warning("Porta sem Cena Destino: " + name)
		return
	Estado.spawn = spawn_destino
	get_tree().change_scene_to_file.call_deferred(cena_destino)


func _liberada() -> bool:
	for f in flags_necessarias:
		if not Estado.tem(f):
			return false
	return true
