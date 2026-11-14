shader_type canvas_item;

// --- CONTROLOS PASTÉIS ---
uniform float saturation : hint_range(0.0, 1.5) = 0.6;   // Reduz a vivacidade
uniform float lift_shadows : hint_range(0.0, 0.4) = 0.15; // Clareia os tons escuros
uniform float brightness : hint_range(0.5, 1.5) = 1.05;   // Luminosidade geral
uniform vec3 pastel_tint : source_color = vec3(1.0, 0.95, 0.92); // Tom pastel

// --- CONTROLOS DE BALANÇO (VENTO / ONDULAÇÃO) ---
uniform bool enable_sway = true;                          // Ativa ou desativa o balanço
uniform float sway_speed : hint_range(0.1, 10.0) = 2.0;   // Velocidade do balanço
uniform float sway_intensity : hint_range(0.0, 0.05) = 0.01; // Intensidade/força do movimento

void vertex() {
    // Se o balanço estiver ativado, deforma os vértices com base no tempo (TIME) e na altura (VERTEX.y)
    if (enable_sway) {
        // Balança mais a parte de cima e mantém a base fixa (se VERTEX.y for negativo ou dependendo da orientação)
        VERTEX.x += sin(TIME * sway_speed + VERTEX.y * 0.05) * (sway_intensity * 100.0);
    }
}

void fragment() {
    // Pega a cor original da textura do fundo
    vec4 tex = texture(TEXTURE, UV);

    // Converte para escala de cinza para calcular a saturação
    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 color = mix(vec3(gray), tex.rgb, saturation);

    // Suaviza as sombras elevando o tom mínimo (estilo pastel)
    color = color * (1.0 - lift_shadows) + lift_shadows;

    // Aplica o brilho e a cor pastel
    color *= brightness;
    color *= pastel_tint;

    // Mantém a transparência (alpha) original
    COLOR = vec4(color, tex.a);
}