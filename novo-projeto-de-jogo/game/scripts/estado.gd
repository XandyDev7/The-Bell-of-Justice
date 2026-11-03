extends Node

# Nome do Marker2D onde o jogador deve aparecer na próxima sala
var spawn := ""

var flags := {}
var inventario := {}

# Flags previstas pelo GDD (seção 4.2):
#  analisou_quarto, corpo_levado, falou_doutor,
#  falou_vendedor_armas, falou_lojista,
#  falou_barista, falou_recepcionista, falou_dono_banco,
#  falou_sra_bell, leu_arquivos
# Itens: chave_dourada, item_quebra_janela


func marcar(flag: String) -> void:
	flags[flag] = true

func tem(flag: String) -> bool:
	return flags.get(flag, false)

func pegar_item(item: String) -> void:
	inventario[item] = true

func tem_item(item: String) -> bool:
	return inventario.get(item, false)
