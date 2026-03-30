extends Node


func _ready() -> void:
	Menu.telaInicial = true
	
	if Global.Intro_tocar == true:
		Global.Intro_tocar = false
		await get_tree().create_timer(3.3).timeout
	$Intro.visible = false
	
	#Audios.tocar_instrucao("res://assets/Audios/tela_inicial.ogg")


func _on_jogar_pressed() -> void:
	reset_dados()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func reset_dados():
	Global.Score = 0
	Global.erros = 0
	Global.TempoDeJogo_Min = 0
	Global.TempoDeJogo_Sec = 0
	Global.JogoConcluido = false
