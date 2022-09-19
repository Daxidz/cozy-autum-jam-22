extends Node2D


var nb_ingredients_selected: int = 0
const MAX_INGREDIENTS: int = 2

enum Ingredients {MIEL, FRAMBOISE, MIRTILLE}

onready var Champignon = preload("res://src/champis/Champi.tscn")
var list_ingredients = []

const BASE_TABLE = 1
var cur_table = BASE_TABLE
onready var max_tables = $YSort/Tables.get_child_count()

var cur_recette: String = ""

const RECETTES = { 
					"orange": ["Miel", "Framboises"],
					"purple": ["Mirtille", "Framboises"],
					"pink": ["Framboises", "Framboises"],
					"green": ["Mirtille", "Miel"] 
				}

func _ready():
	randomize()
	$Chauderon.connect("melanger", self, "_onChauderon_melanger")
	for ingredient in $Ingredients.get_children():
		ingredient.connect("clicked", self, "_onIngredient_clicked")
	
	for table in $YSort/Tables.get_children():
		table.connect("champi_matched", self, "_on_Champis_matched")
		
	for i in 8:
			spawn_champi()

const champi_couleurs = {
						"pink":["c92e70", "9e2081"],
						"green":["5d7668", "235a63"],
						"orange":["ffb366", "ff5b4f"],
						"purple":["ad82cf", "8455a9"]
						}

func spawn_champi():
	
	if cur_table > max_tables: return
	var champ = Champignon.instance()
	var colors = champi_couleurs[champi_couleurs.keys()[randi()%champi_couleurs.size()]]
	print(colors)
	champ.set_colors(colors[0], colors[1])
	champ.connect("clicked", self, "_on_Champi_clicked")
	var table
	while true:
		table = get_node("YSort/Tables/Table" + str(cur_table))
		if table.is_full():
			cur_table += 1
			if cur_table > max_tables: return
		else:
			break
	table.add_champi(champ)

func _onIngredient_clicked(name: String):
	
	if nb_ingredients_selected == MAX_INGREDIENTS: return
	
	nb_ingredients_selected += 1
	print(name)
	list_ingredients.push_back(name)
	if nb_ingredients_selected == MAX_INGREDIENTS:
		$Chauderon.modulate = Color.red
		

func _onChauderon_melanger():
	if nb_ingredients_selected == MAX_INGREDIENTS:
		check_recette(list_ingredients)		
		nb_ingredients_selected = 0
		list_ingredients.clear()
		
func _on_Champi_clicked(champi):
	if cur_recette != "":
		var new_colors = champi_couleurs[cur_recette]
		champi.set_colors(new_colors[0], new_colors[1])
		
		get_tree().call_group("champis", "make_selectable", false)
		cur_recette = ""
		var table = champi.table
		table.check_champis_color()
	
		
func check_recette(ingredients) -> int:
	
	var is_ok: bool = false
	ingredients.invert()
	var ingredients_inv = ingredients.duplicate(true)
	ingredients.invert()
	
	for recette in RECETTES:
		
		var ing = RECETTES[recette]
		if ingredients == ing or ingredients_inv == ing:
			print(recette)
			show_recette(recette)
			cur_recette = recette
			get_tree().call_group("champis", "make_selectable", true)
			return 1
	return 0
	
func _on_Champis_matched(champis):
	for c in champis:
		c.emit_hearts()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		for i in 8:
			spawn_champi()
			
func show_recette(recette):
	var rec = get_node("Livre/Recette/ColorRect/" + recette)
	rec.visible = visible
