extends Node2D

@export var amplitude: float = 4.0
@export var velocidade: float = 1.5

var posicoes_originais: Array[Vector2] = []
var deslocamentos: Array[float] = []


func _ready() -> void:
	for luz in get_children():
		posicoes_originais.append(luz.position)
		deslocamentos.append(randf_range(0.0, TAU))


func _process(_delta: float) -> void:
	var tempo = Time.get_ticks_msec() / 1000.0
	for i in get_child_count():
		var luz = get_child(i)
		var offset = sin(tempo * velocidade + deslocamentos[i]) * amplitude
		luz.position = posicoes_originais[i] + Vector2(0, offset)
