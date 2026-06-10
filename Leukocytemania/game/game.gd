extends Node2D

@onready var eaten_img = $GameUi/Control/VBoxContainer/eaten_img
@onready var eaten_info = $GameUi/Control/VBoxContainer/eaten_info
@onready var score_label = $GameUi/Control/VBoxContainer2/score

@onready var timer = $Timer

var score = 0

func change_info_box(info_flag: String):
	if info_flag == "bacteria":
		eaten_img.texture = load("res://game/infos/bacterias.jpg")
		eaten_info.text = "Una bacteria patógena es un microorganismo unicelular capaz de causar enfermedades en seres vivos. Puede provocar daño al invadir tejidos, multiplicarse dentro del organismo o producir toxinas que afectan el funcionamiento."
	elif info_flag == "virus":
		eaten_img.texture = load("res://game/infos/virus.jpeg")
		eaten_info.text = "Un virus es un agente infeccioso microscópico que no puede reproducirse por sí solo y necesita invadir células vivas para multiplicarse. Al infectar las células, puede dañarlas y causar enfermedades en humanos, animales o plantas."
	elif info_flag == "leukocyte":
		eaten_img.texture = load("res://game/infos/leukocyte.jpeg")
		eaten_info.text = "Un leucocito, también llamado glóbulo blanco, es una célula del sistema inmunitario encargada de defender al organismo contra infecciones y enfermedades. Los leucocitos identifican y eliminan microorganismos patogenos."

func _ready() -> void:
	score_label.text = "0"
	
func add_score(points):
	score += points

func _on_timer_timeout() -> void:
	score += 1
	score_label.text = str(score)
	
	
