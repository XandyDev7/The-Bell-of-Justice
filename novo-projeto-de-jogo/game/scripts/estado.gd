extends Node

var spawn := ""

var flags := {}
var inventario := {}


func marcar(flag: String) -> void:
	flags[flag] = true

func tem(flag: String) -> bool:
	return flags.get(flag, false)

func pegar_item(item: String) -> void:
	inventario[item] = true

func tem_item(item: String) -> bool:
	return inventario.get(item, false)
