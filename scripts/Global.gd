extends Node

var words: Dictionary
var array_silabas: Array
var array_imagens: Array

# Dados para plataforma
var Score : int = 0
var erros : int = 0
var TempoDeJogo_Min : int = 0
var TempoDeJogo_Sec : int = 0
var JogoConcluido : bool = false

#variveis para o jogo
var arrastando: bool = false

#Permite que a intro toque só uma vez
var Intro_tocar : bool = true


func _ready() -> void:
	words = load_json()
	array_silabas = words.words
	embaralhar()


func embaralhar():
	array_silabas.shuffle()
	array_imagens = array_silabas[0].imagens
	array_imagens.shuffle()


func embaralhar_imagens(pos_array):
	array_imagens = array_silabas[pos_array].imagens
	array_imagens.shuffle()


func load_json():
	var file = "res://files/words.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict
