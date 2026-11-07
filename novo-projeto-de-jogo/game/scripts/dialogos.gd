extends CanvasLayer

const CENA := preload("res://game/dialogScrim.tscn")

const PERSONAGENS := {
	"xerife": {"nome": "Xerife", "retrato": "res://sprite_00.png"},
	"vendedor": {"nome": "Vendedor de Armas", "retrato": "res://sprite_15.png"},
	"lojista": {"nome": "Lojista", "retrato": "res://lojista.png"},
	"doutor": {"nome": "Doutor", "retrato": "res://doutor.png"},
	"sra_bell": {"nome": "Sra. Bell", "retrato": "res://sprite.png"},
}

const CONVERSAS := {
	"vendedor_1": [
		["vendedor", "Boa noite, xerife. O que deseja saber?"],
		{"opcoes": [
			{
				"texto": "Sobre a bala especial",
				"conversa": "vendedor_bala",
				"volta": true,
				"flag": "perguntou_bala",
			},
			{
				"texto": "Quem comprou essas balas?",
				"conversa": "vendedor_compradores",
				"volta": true,
				"requer": "perguntou_bala",
				"flag": "falou_vendedor_armas",
			},
			{
				"texto": "Era isso vlw.",
				"conversa": "",
			},
		]},
	],
	"vendedor_bala": [
		["xerife", "O doutor disse que a bala que matou o Sr. Bell é especial?"],
		["vendedor", " vdd vendo esse tipo aqui. É cara e quase ninguém pede."],
	],
	"vendedor_compradores": [
		["xerife", "Quem costuma comprar?"],
		["vendedor", "tatata."],
		
	
	],
}

var ativo: bool = false


func _ready() -> void:
	layer = 10


func falar(id_conversa: String) -> void:
	if not CONVERSAS.has(id_conversa):
		push_warning("Conversa não cadastrada: " + id_conversa)
		return

	iniciar(montar(id_conversa))


func fala(id: String, texto: String) -> Dictionary:
	if not PERSONAGENS.has(id):
		push_warning("Personagem não cadastrado: " + id)

	var personagem: Dictionary = PERSONAGENS.get(
		id,
		{"nome": id, "retrato": ""}
	)

	return {
		"title": personagem["nome"],
		"dialog": texto,
		"faceset": personagem["retrato"],
	}


func conversa(linhas: Array) -> void:
	var falas: Array = []

	for linha in linhas:
		if linha is Array and linha.size() >= 2:
			falas.append(fala(str(linha[0]), str(linha[1])))
		else:
			push_warning("Linha de conversa inválida; esperado [personagem, texto].")

	iniciar(falas)


func aviso(texto: String) -> void:
	iniciar([{"title": "", "dialog": texto, "faceset": ""}])


func montar(id_conversa: String) -> Array:
	if not CONVERSAS.has(id_conversa):
		push_warning("Conversa não cadastrada: " + id_conversa)
		return []

	var falas: Array = []

	for item in CONVERSAS[id_conversa]:
		if item is Dictionary and item.has("opcoes"):
			if falas.is_empty():
				push_warning("As opções da conversa precisam vir depois de uma fala.")
			else:
				falas[falas.size() - 1]["opcoes"] = item["opcoes"]
		elif item is Array and item.size() >= 2:
			falas.append(fala(str(item[0]), str(item[1])))
		else:
			push_warning("Entrada inválida na conversa: " + id_conversa)

	return falas


func iniciar(falas: Array) -> void:
	if ativo or falas.is_empty():
		return

	ativo = true
	var dialogo: dialogScrim = CENA.instantiate()
	dialogo.data = falas
	dialogo.dialogo_terminado.connect(_ao_terminar)
	add_child(dialogo)


func _ao_terminar() -> void:
	await get_tree().process_frame
	ativo = false
