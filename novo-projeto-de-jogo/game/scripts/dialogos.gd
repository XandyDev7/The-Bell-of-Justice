extends CanvasLayer

const CENA := preload("res://game/dialogScrim.tscn")   # ajuste

const PERSONAGENS := {
	"xerife":   {"nome": "Xerife",            "retrato": "res://game/Wizard.png"},
	"vendedor": {"nome": "Vendedor de Armas", "retrato": "res://game/faceset-b.png"},
	"lojista":  {"nome": "Lojista",           "retrato": "res://game/arte/retratos/lojista.png"},
	"doutor":   {"nome": "Doutor",            "retrato": "res://game/arte/retratos/doutor.png"},
	"sra_bell": {"nome": "Sra. Bell",         "retrato": "res://game/arte/retratos/sra_bell.png"},
}

var ativo := false


func _ready() -> void:
	layer = 10


func fala(id: String, texto: String) -> Dictionary:
	if not PERSONAGENS.has(id):
		push_warning("Personagem não cadastrado: " + id)
	var p: Dictionary = PERSONAGENS.get(id, {"nome": id, "retrato": ""})
	return {"title": p["nome"], "dialog": texto, "faceset": p["retrato"]}


# Atalho: lista de [personagem, texto]
func conversa(linhas: Array) -> void:
	var falas: Array = []
	for l in linhas:
		falas.append(fala(l[0], l[1]))
	iniciar(falas)


func iniciar(falas: Array) -> void:
	if ativo:
		return
	ativo = true
	var d: dialogScrim = CENA.instantiate()
	d.data = falas
	d.dialogo_terminado.connect(func(): ativo = false)
	add_child(d)
