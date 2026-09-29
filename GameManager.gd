extends Node

var juego_activo: bool = false 

# --- INICIO AVANZADO (AÑO 2024) ---
var dinero: float = 150000.0      
var gastos_mensuales: float = 4500.0 
var xp: int = 45000               
var xp_total: int = 14000         
var nivel: int = 14               

var año_actual: int = 2024
var mes_actual: int = 1
var dia_actual: int = 1

var eficiencia_base: float = 2.0 
var trabajo_seleccionado = null 

# --- SISTEMA DE EMPLEADOS ---
var equipo = {
	"jugador": {
		"nombre": "Tú (CEO)",
		"eficiencia": 15.0,
		"habilidades": ["terminal", "git", "html", "sql", "framework"]
	},
	"empleado_1": {
		"nombre": "Dev Senior",
		"eficiencia": 10.0,
		"habilidades": ["terminal", "git", "backend"]
	},
	"empleado_2": {
		"nombre": "Especialista Datos",
		"eficiencia": 10.0,
		"habilidades": ["terminal", "sql", "ml"]
	}
}

var miembro_seleccionado_para_curso = "jugador"

signal xp_cambiada(nueva_xp)
signal tiempo_cambiado(dia, mes, año)
signal dinero_cambiado(nueva_cantidad)
signal nivel_cambiado(nuevo_nivel)

var lista_trabajos = [
	# ================= NIVEL 1 AL 5 =================
	{"id": "limpieza_pc", "nombre": "Mantenimiento Preventivo PC", "dificultad": "Fácil", "multiplicador_tiempo": 1.0, "pago": 45.0, "xp": 10, "año_req": 2018, "nivel_req": 1, "descripcion": "Limpieza física de hardware y renovación de pasta térmica."},
	{"id": "web_estatica", "nombre": "Landing Page Estática", "dificultad": "Fácil", "multiplicador_tiempo": 0.8, "pago": 40.0, "xp": 8, "año_req": 2018, "nivel_req": 1, "descripcion": "Diseño de una página web usando puro HTML5 y CSS3."},
	{"id": "form_html", "nombre": "Formulario de Contacto web", "dificultad": "Fácil", "multiplicador_tiempo": 0.6, "pago": 30.0, "xp": 5, "año_req": 2018, "nivel_req": 1, "descripcion": "Creación y validación frontend de un formulario HTML."},
	{"id": "config_router", "nombre": "Configuración de Red Local", "dificultad": "Fácil", "multiplicador_tiempo": 1.2, "pago": 60.0, "xp": 12, "año_req": 2018, "nivel_req": 1, "descripcion": "Configuración de un router y asignación de IPs estáticas."},
	{"id": "instalar_so", "nombre": "Instalación de Sistema Operativo", "dificultad": "Fácil", "multiplicador_tiempo": 1.5, "pago": 70.0, "xp": 15, "año_req": 2018, "nivel_req": 1, "descripcion": "Formateo seguro de discos e instalación en limpio de Windows/Linux."},
	{"id": "script_backup", "nombre": "Script de Respaldos Bash", "dificultad": "Fácil", "multiplicador_tiempo": 0.9, "pago": 50.0, "xp": 12, "año_req": 2018, "nivel_req": 2, "descripcion": "Escribir un script ejecutable en la terminal de Linux para comprimir carpetas."},
	{"id": "plantilla_email", "nombre": "Maquetar Plantilla de Email", "dificultad": "Fácil", "multiplicador_tiempo": 1.1, "pago": 55.0, "xp": 14, "año_req": 2018, "nivel_req": 2, "descripcion": "Diseño de correo electrónico HTML usando tablas de compatibilidad."},
	{"id": "qa_manual", "nombre": "Pruebas QA Manuales", "dificultad": "Fácil", "multiplicador_tiempo": 1.4, "pago": 65.0, "xp": 18, "año_req": 2018, "nivel_req": 2, "descripcion": "Navegación exhaustiva por una aplicación web buscando errores visuales."},
	{"id": "update_firmware", "nombre": "Actualización de Firmware", "dificultad": "Fácil", "multiplicador_tiempo": 0.7, "pago": 35.0, "xp": 8, "año_req": 2018, "nivel_req": 2, "descripcion": "Flasheo de BIOS/UEFI en placas base para habilitar soporte."},
	{"id": "css_animations", "nombre": "Animaciones CSS3", "dificultad": "Fácil", "multiplicador_tiempo": 1.0, "pago": 60.0, "xp": 15, "año_req": 2018, "nivel_req": 2, "descripcion": "Implementar keyframes y transiciones suaves para mejorar la experiencia de usuario (UX)."},

	# ================= NIVEL 6 AL 13 =================
	{"id": "api_clima", "nombre": "Integrar API RESTful", "dificultad": "Media", "multiplicador_tiempo": 1.5, "pago": 120.0, "xp": 25, "año_req": 2019, "nivel_req": 3, "descripcion": "Conectar el Frontend con una API externa mediante solicitudes HTTP."},
	{"id": "query_sql", "nombre": "Optimizar Consultas SQL", "dificultad": "Media", "multiplicador_tiempo": 1.2, "pago": 90.0, "xp": 20, "año_req": 2019, "nivel_req": 3, "descripcion": "Reescritura de queries lentas implementando JOINs eficientes e índices."},
	{"id": "config_dns", "nombre": "Configuración Dominio y DNS", "dificultad": "Media", "multiplicador_tiempo": 0.8, "pago": 75.0, "xp": 18, "año_req": 2019, "nivel_req": 3, "descripcion": "Apuntar registros A, CNAME y TXT en un panel de control."},
	{"id": "migracion_db", "nombre": "Normalización de Base de Datos", "dificultad": "Media", "multiplicador_tiempo": 2.2, "pago": 210.0, "xp": 40, "año_req": 2019, "nivel_req": 4, "descripcion": "Reestructurar tablas SQL para cumplir con las Formas Normales."},
	{"id": "crud_php", "nombre": "Sistema CRUD PHP/MySQL", "dificultad": "Media", "multiplicador_tiempo": 2.5, "pago": 250.0, "xp": 45, "año_req": 2019, "nivel_req": 4, "descripcion": "Desarrollar un panel administrativo básico protegiendo contra inyecciones SQL."},
	{"id": "docker_simple", "nombre": "Dockerizar App Simple", "dificultad": "Media", "multiplicador_tiempo": 1.6, "pago": 150.0, "xp": 30, "año_req": 2019, "nivel_req": 4, "descripcion": "Escribir un Dockerfile básico para empaquetar una aplicación web estática."},
	{"id": "react_components", "nombre": "Componentes en React", "dificultad": "Media", "multiplicador_tiempo": 2.0, "pago": 200.0, "xp": 38, "año_req": 2020, "nivel_req": 5, "descripcion": "Migrar interfaz HTML tradicional a una arquitectura basada en componentes."},
	{"id": "api_nodejs", "nombre": "Backend API Node.js", "dificultad": "Media", "multiplicador_tiempo": 2.8, "pago": 300.0, "xp": 55, "año_req": 2020, "nivel_req": 5, "descripcion": "Construir rutas, controladores y middleware en Express.js."},
	{"id": "juego_godot", "nombre": "Prototipo de Juego (Godot)", "dificultad": "Media", "multiplicador_tiempo": 3.0, "pago": 350.0, "xp": 65, "año_req": 2021, "nivel_req": 6, "descripcion": "Desarrollar un bucle de juego basado en gestión de recursos utilizando el sistema de nodos."},
	{"id": "chat_websockets", "nombre": "Chat en Tiempo Real", "dificultad": "Media", "multiplicador_tiempo": 2.4, "pago": 260.0, "xp": 48, "año_req": 2021, "nivel_req": 6, "descripcion": "Implementar protocolo WebSockets para comunicación bidireccional."},

	# ================= AVANZADOS (AÑO 2024+) =================
	{"id": "cluster_kubernetes", "nombre": "Clusterización Kubernetes", "dificultad": "Difícil", "multiplicador_tiempo": 4.2, "pago": 900.0, "xp": 180, "año_req": 2024, "nivel_req": 13, "descripcion": "Despliegue de microservicios con alta disponibilidad y gestión de Ingress Controllers."},
	{"id": "bigdata_pipeline", "nombre": "Pipeline Big Data (Kafka)", "dificultad": "Difícil", "multiplicador_tiempo": 4.8, "pago": 1100.0, "xp": 210, "año_req": 2024, "nivel_req": 14, "descripcion": "Manejo de streaming masivo de eventos en tiempo real y configuración de brokers."},
	{"id": "ia_nlp_chat", "nombre": "Fine-tuning de un LLM", "dificultad": "Difícil", "multiplicador_tiempo": 5.0, "pago": 1500.0, "xp": 280, "año_req": 2025, "nivel_req": 15, "descripcion": "Ajustar los pesos de un Modelo de Lenguaje Grande usando datasets locales."},
	{"id": "smart_contract", "nombre": "Auditoría Smart Contract", "dificultad": "Difícil", "multiplicador_tiempo": 4.0, "pago": 1200.0, "xp": 230, "año_req": 2025, "nivel_req": 15, "descripcion": "Análisis de código Solidity buscando vulnerabilidades de reentrancia."},
	{"id": "motor_fisi_custom", "nombre": "Motor Físicas Cuántico (Prototipo)", "dificultad": "Extrema", "multiplicador_tiempo": 6.0, "pago": 3500.0, "xp": 600, "año_req": 2026, "nivel_req": 20, "descripcion": "Aplicar algoritmos de computación cuántica básicos para resolver problemas de optimización matemática."}
]


func _ready():
	var timer = Timer.new()
	timer.wait_time = 1.0 
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout) 
	add_child(timer)

func comenzar_partida():
	juego_activo = true

func _on_timer_timeout():
	if not juego_activo:
		return 
	avanzar_dia()

func avanzar_dia():
	dia_actual += 1
	if dia_actual > 30: 
		dia_actual = 1
		mes_actual += 1
		restar_dinero(gastos_mensuales)
		
		if mes_actual > 12: 
			mes_actual = 1
			año_actual += 1
			
	tiempo_cambiado.emit(dia_actual, mes_actual, año_actual)

func agregar_dinero(cantidad: float):
	dinero += cantidad
	dinero_cambiado.emit(dinero)

func restar_dinero(cantidad: float):
	dinero -= cantidad
	dinero_cambiado.emit(dinero)

func agregar_xp(cantidad: int):
	xp += cantidad 
	xp_total += cantidad 
	xp_cambiada.emit(xp)

func restar_xp(cantidad: int):
	xp -= cantidad
	xp_cambiada.emit(xp) # Esto avisa al HUD que debe actualizar los números en pantalla
	
	var nivel_calculado = 1 + int(xp_total / 100.0) 
	if nivel_calculado > nivel:
		nivel = nivel_calculado
		nivel_cambiado.emit(nivel) 

func obtener_progreso_por_tic() -> float:
	var maximo_bono = 23.0 
	var atenuacion = 100.0
	var bono_total = 0.0
	
	# Suma el esfuerzo de los 3 trabajadores
	for miembro in equipo.values():
		var efi = miembro["eficiencia"]
		bono_total += (maximo_bono * efi) / (efi + atenuacion)
		
	return eficiencia_base + bono_total

func obtener_perfil_ideal(nombre_trabajo: String) -> Array:
	var n = nombre_trabajo.to_lower()
	if "web" in n or "landing" in n or "html" in n or "react" in n or "dashboard" in n: return [3, 5, 1, 3, 2]
	elif "pc" in n or "router" in n or "backup" in n or "so" in n or "docker" in n or "kubernetes" in n: return [2, 1, 5, 3, 4]
	elif "api" in n or "db" in n or "sql" in n or "php" in n or "crud" in n or "node" in n or "backend" in n: return [5, 1, 3, 4, 3]
	elif "qa" in n or "seguridad" in n or "jwt" in n or "testing" in n or "firmware" in n: return [4, 1, 3, 5, 3]
	elif "ia" in n or "ml" in n or "datos" in n or "juego" in n or "motor" in n or "cuántico" in n: return [5, 3, 2, 3, 5]
	return [3, 3, 3, 3, 3]

func guardar_partida(slot: int):
	var datos_guardado = {
		"dinero": dinero,
		"xp": xp,
		"xp_total": xp_total,
		"nivel": nivel,
		"año_actual": año_actual,
		"mes_actual": mes_actual,
		"dia_actual": dia_actual,
		"equipo": equipo
	}
	var ruta = "user://partida_slot_" + str(slot) + ".save"
	var archivo = FileAccess.open(ruta, FileAccess.WRITE)
	archivo.store_var(datos_guardado)

func cargar_partida(slot: int) -> bool:
	var ruta = "user://partida_slot_" + str(slot) + ".save"
	if FileAccess.file_exists(ruta):
		var archivo = FileAccess.open(ruta, FileAccess.READ)
		var datos = archivo.get_var()
		dinero = datos["dinero"]
		xp = datos["xp"]
		xp_total = datos["xp_total"]
		nivel = datos["nivel"]
		año_actual = datos["año_actual"]
		mes_actual = datos["mes_actual"]
		dia_actual = datos["dia_actual"]
		equipo = datos["equipo"]
		return true
	return false
