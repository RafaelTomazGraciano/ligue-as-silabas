extends Node

var array_posicoes_botoes_silabas = [Vector2(190,125), Vector2(190,275), Vector2(190,425)]
var array_posicoes_botoes_imagens = [Vector2(825,120), Vector2(825,270), Vector2(825,420)]

var cena_botao_silaba = preload("res://scenes/botao_silaba.tscn")
var cena_botao_imagem = preload("res://scenes/botao_imagem.tscn")

var array_botoes_silabas:Array
var array_botoes_imagens:Array

var id_botao_silaba: int
var botoes_certos = 0
var fase = 0
var mouse_dentro = false

signal _instancia_como_jogar

func _ready() -> void:
	Menu.telaInicial = false
	
	botoes_certos = 0
	fase += 1
	Global.embaralhar()
	
	if fase > 1:
		remover_botao(array_botoes_imagens)
		remover_botao(array_botoes_silabas)
	
	array_posicoes_botoes_silabas.shuffle()
	array_posicoes_botoes_imagens.shuffle()
	
	for i in array_posicoes_botoes_silabas.size():
		var botao_silaba = cena_botao_silaba.instantiate()
		botao_silaba.position = array_posicoes_botoes_silabas[i]
		botao_silaba.id = i
		botao_silaba.get_node("silaba").text = Global.array_silabas[i].silaba
		botao_silaba.caminho_som = Global.array_silabas[i].som
		botao_silaba.connect("enviar_id", Callable(self, "_on_botao_silaba_enviar_id"))
		array_botoes_silabas.append(botao_silaba)
		add_child(botao_silaba)
	
	for i in array_posicoes_botoes_imagens.size():
		var botao_imagem = cena_botao_imagem.instantiate()
		botao_imagem.position = array_posicoes_botoes_imagens[i]
		botao_imagem.id = i
		Global.embaralhar_imagens(i)
		botao_imagem.get_node("imagem").texture = Global.array_imagens[i]
		botao_imagem.connect("soltou_area", Callable(self, "_on_botao_imagem_soltou_area"))
		botao_imagem.connect("removeu_area", Callable(self, "_on_botao_imagem_removeu_area"))
		array_botoes_imagens.append(botao_imagem)
		add_child(botao_imagem)


func _on_botao_silaba_enviar_id(id) -> void:
	id_botao_silaba = id


func _on_botao_imagem_soltou_area(id) -> void:
	array_botoes_silabas[id_botao_silaba].z_index = 0
	if id == id_botao_silaba:
		acertou(id)
	else:
		errou(id)


func _on_botao_imagem_removeu_area(id) -> void:
	if id != id_botao_silaba:
		array_botoes_silabas[id_botao_silaba].z_index = 10


func acertou(id):
	$TimerInstrucao.start()
	Global.Score += 34
	botoes_certos += 1
	var botao_tomada = array_botoes_silabas[id_botao_silaba].get_node("botao_tomada")
	var marker_pos = array_botoes_imagens[id].get_node("Marker").global_position
	botao_tomada.global_position = (marker_pos - botao_tomada.size * 0.35) + Vector2(0,14)
	array_botoes_imagens[id]._acertou()
	array_botoes_silabas[id_botao_silaba].desabilitar_botao()
	if botoes_certos == 3:
		Audios.tocar_acertou()
		
		if fase < 3:
			$robo.texture = load("res://assets/robo/robo_%s_bateria.png" %[fase])
		else:
			$robo.hide()
			$robo_pulando.show()
			$robo_pulando.play("pulando_feliz")
		await get_tree().create_timer(5.0).timeout
		
		if fase == 3:
			get_tree().change_scene_to_file("res://scenes/fim.tscn")
		_ready()


func errou(id):
	array_botoes_silabas[id_botao_silaba].tocar_audio()
	Global.Score -= 2
	Global.erros += 1
	var botao_tomada = array_botoes_silabas[id_botao_silaba].get_node("botao_tomada")
	var marker_pos = array_botoes_imagens[id].get_node("Marker").global_position
	botao_tomada.global_position = (marker_pos - botao_tomada.size * 0.35) + Vector2(0,14)
	array_botoes_imagens[id]._errou()


func remover_botao(array):
	for botao in array:
		botao.queue_free()
	array.clear()
