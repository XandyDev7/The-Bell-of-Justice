extends Node2D

func _ready() -> void:
	if Estado.spawn == "":
		return
	var jogador := get_tree().get_first_node_in_group("jogador")
	var ponto := get_node_or_null("Spawns/" + Estado.spawn)
	if jogador != null and ponto != null:
		jogador.global_position = ponto.global_position
	elif ponto == null:
		push_warning("Spawn não encontrado: " + Estado.spawn)
	Estado.spawn = ""
