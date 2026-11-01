extends Area2D

@export_file("*.tscn") var cena_destino := ""
@export var spawn_destino := ""

func _ready() -> void:
	body_entered.connect(_on_corpo_entrou)

func _on_corpo_entrou(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		Estado.spawn = spawn_destino
		get_tree().change_scene_to_file.call_deferred(cena_destino)
