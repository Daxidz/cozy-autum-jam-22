extends Node2D


var nb_ingredients_selected: int = 0
const MAX_INGREDIENTS: int = 2

enum Ingredients {MIEL, FRAMBOISE, MIRTILLE}

onready var Champignon = preload("res://src/champis/Champi.tscn")
var list_ingredients = []

const BASE_TABLE = 1
var cur_table = BASE_TABLE
onready var max_tables = $YSort/Tables.get_child_count()


const RECETTES = { 
					"orange": ["Miel", "Framboises"],
					"violet": ["Mirtille", "Framboises"],
					"pink": ["Framboises", "Framboises"],
					"green": ["Mirtille", "Miel"] 
				}

func _ready():
	$Chauderon.connect("melanger", self, "_onChauderon_melanger")
	for ingredient in $Ingredients.get_children():
		ingredient.connect("clicked", self, "_onIngredient_clicked")

const champi_couleurs = [["c92e70", "9e2081"],["5d7668", "235a63"],["ffb366", "ff5b4f"],["ad82cf", "8455a9"],]

func spawn_champi():
	
	if cur_table > max_tables: return
	var champ = Champignon.instance()
	var colors = champi_couleurs[randi()%champi_couleurs.size()]
	print(colors)
	champ.set_colors(colors[0], colors[1])
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
#			$Chauderon.modulate = Color("yellow")
			return 0
	return 0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("SPAWN")
		for i in 8:
			spawn_champi()
			
func show_recette(recette):
	var rec = get_node("Livre/Recette/ColorRect/" + recette)
	rec.visible = visible
