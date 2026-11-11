extends Node

var spawn := ""        
var flags := {}        
var itens := {}       

var jogo_iniciou := false


func reiniciar() -> void:
	flags.clear()
	itens.clear()
	spawn = ""
	jogo_iniciou = true


func marcar(flag: String) -> void:
	flags[flag] = true


func pegar_item(item: String) -> void:
	itens[item] = true


func tem(nome: String) -> bool:
	return flags.get(nome, false) or itens.get(nome, false)


func tem_item(item: String) -> bool:
	return itens.get(item, false)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F9:
		print("Flags: ", flags.keys())
		print("Itens: ", itens.keys())
		print("Jogo iniciado pelo Start: ", jogo_iniciou)
