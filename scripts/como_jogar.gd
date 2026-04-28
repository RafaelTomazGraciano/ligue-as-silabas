extends Node2D

var array_posicoes_botoes_silabas = [Vector2(190,170), Vector2(190,340)]
var array_posicoes_botoes_imagens = [Vector2(825,165), Vector2(825,340)]

var cena_botao_silaba = preload("res://scenes/botao_silaba.tscn")
var cena_botao_imagem = preload("res://scenes/botao_imagem.tscn")

var array_botoes_silabas:Array
var array_botoes_imagens:Array

var id_botao_silaba: int
var mouse_dentro = false

signal ir_para_main

func _ready() -> void:
	Menu.telaInicial = false
	
	Global.embaralhar()
	
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


func como_jogar():
	Audios.tocar_instrucao("res://assets/audios/como_jogar/vamos_aprender_a_jogar.ogg")
	#arraste a tomada ligue a sílaba com a imagem
	
	#erra
	#audio tente outra vez
	#acerta
	
	#acerta
	
	#audio voce acertou
	#vai para main


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
	var botao_tomada = array_botoes_silabas[id_botao_silaba].get_node("botao_tomada")
	var marker_pos = array_botoes_imagens[id].get_node("Marker").global_position
	botao_tomada.global_position = (marker_pos - botao_tomada.size * 0.35) + Vector2(0,14)
	array_botoes_imagens[id]._acertou()
	array_botoes_silabas[id_botao_silaba].desabilitar_botao()


func errou(id):
	array_botoes_silabas[id_botao_silaba].tocar_audio()
	Global.Score -= 2
	Global.erros += 1
	var botao_tomada = array_botoes_silabas[id_botao_silaba].get_node("botao_tomada")
	var marker_pos = array_botoes_imagens[id].get_node("Marker").global_position
	botao_tomada.global_position = (marker_pos - botao_tomada.size * 0.35) + Vector2(0,14)
	array_botoes_imagens[id]._errou()
	await get_tree().create_timer(1.0).timeout
	# explosao
	treme_robo(0.5, 15.0)
	$explosao.restart()
	$explosao.emitting = true 
	Audios.som_eletricidade("res://assets/audios/choque.mp3")


func treme_robo(duracao: float, intensidade: float = 5.0):
	var origem = $robo.position
	var tween = create_tween()
	var passos = int(duracao / 0.05)

	for i in passos:
		var offset = Vector2(
			randf_range(-intensidade, intensidade),
			randf_range(-intensidade, intensidade)
		)
		tween.tween_property($robo, "position", origem + offset, 0.05)

	# Volta à posição original no final
	tween.tween_property($robo, "position", origem, 0.05)


func _on_pular_tutorial_pressed() -> void:
	ir_para_main.emit()


func _on_pular_tutorial_mouse_entered() -> void:
	mouse_dentro = true
	$TimerBotao.start()


func _on_pular_tutorial_mouse_exited() -> void:
	mouse_dentro = false
	$TimerBotao.stop()


func _on_timer_botao_timeout() -> void:
	Audios.tocar_audio("res://assets/audios/como_jogar/pular_tutorial.ogg", self)
	$TimerBotao.stop()


func _on_timer_instrucao_timeout() -> void:
	pass # Replace with function body.


func is_mouse_inside() -> bool:
	return mouse_dentro
