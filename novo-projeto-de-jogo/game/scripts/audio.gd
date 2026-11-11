extends Node

const SONS := {
	"porta_abrindo": "res://song/porta abrindo.mp3",         
	"armario_trancado": "res://song/porta fechando.mp3",    
	"porta_trancada": "res://song/porta fechando.mp3",        
	"porta_destrancando": "res://song/porta destrancando.mp3",
	"estante_deslizando": "",
}

var player_musica: AudioStreamPlayer = null


func _ready() -> void:
	tocar_musica("res://song/Projeto_novo.mp3", -5.0)

# ----------------------------------

func tocar(nome: String, volume_db := 0.0) -> void:
	if not SONS.has(nome):
		push_warning("Som não cadastrado: " + nome)
		return
	var caminho: String = SONS[nome]
	if not ResourceLoader.exists(caminho):
		push_warning("Arquivo de som não encontrado: " + caminho)
		return

	var p := AudioStreamPlayer.new()
	p.stream = load(caminho)
	p.volume_db = volume_db
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()

func tocar_musica(caminho_musica: String, volume_db := 0.0) -> void:
	if player_musica != null and player_musica.playing:
		player_musica.stop()
		player_musica.queue_free()
	
	if not ResourceLoader.exists(caminho_musica):
		push_warning("Música não encontrada: " + caminho_musica)
		return

	player_musica = AudioStreamPlayer.new()
	player_musica.stream = load(caminho_musica)
	player_musica.volume_db = volume_db
	
	# Faz com que a música recomece automaticamente mal termine
	player_musica.finished.connect(player_musica.play)
	
	add_child(player_musica)
	player_musica.play()
