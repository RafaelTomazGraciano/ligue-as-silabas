extends Sprite2D

@export var duracao_descarga: float = 2.7

@onready var material_bateria: ShaderMaterial = $ColorRect.material


func definir_total_fases(total: int) -> void:
	material_bateria.set_shader_parameter("total_fases", total)


func definir_nivel(fase: int) -> void:
	material_bateria.set_shader_parameter("nivel_atual", float(fase))


func descarregar() -> void:
	var nivel_inicial = material_bateria.get_shader_parameter("nivel_atual")
	var tween = create_tween()
	tween.tween_method(
		func(valor): material_bateria.set_shader_parameter("nivel_atual", valor),
		nivel_inicial, 0.0, duracao_descarga
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
