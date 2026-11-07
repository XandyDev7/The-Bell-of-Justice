extends Node2D

func _ready() -> void:
	Dialogos.conversa([
		["vendedor", "Bom dia, xerife. Em que posso ajudar?"],
		["xerife", "Preciso saber sobre uma bala especial."],
		["vendedor", "Poucos compram essa. Quase apenas visitantes."],
	])
