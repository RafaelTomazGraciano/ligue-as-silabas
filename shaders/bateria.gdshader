shader_type canvas_item;

uniform int total_fases;
uniform float nivel_atual = 0.0;
uniform vec4 cor_preenchida : source_color = vec4(0.2, 0.85, 0.3, 1.0);
uniform vec4 cor_vazia : source_color = vec4(0.85, 0.85, 0.85, 0.0);
uniform vec4 cor_linha : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float espessura_linha : hint_range(0.0, 0.05) = 0.025;

void fragment() {
	float x = UV.x;
	float total = float(total_fases);

	float preenchido = step(x, nivel_atual / total);

	float linha = 0.0;
	float suavizacao = fwidth(x) * 1.5;
	for (int i = 1; i < 20; i++) {
		if (i >= total_fases) {
			break;
		}
		float pos_linha = float(i) / total;
		float dist = abs(x - pos_linha);
		linha += 1.0 - smoothstep(espessura_linha * 0.5, espessura_linha * 0.5 + suavizacao, dist);
	}
	linha = clamp(linha, 0.0, 1.0);

	vec4 cor = mix(cor_vazia, cor_preenchida, preenchido);
	cor = mix(cor, cor_linha, linha);
	COLOR = cor;
}