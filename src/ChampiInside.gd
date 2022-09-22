extends Node2D


var nb_ingredients_selected: int = 0
const MAX_INGREDIENTS: int = 2

enum Ingredients {MIEL, FRAMBOISE, MIRTILLE}

onready var Champignon = preload("res://src/champis/Champi.tscn")
var list_ingredients = []

const BASE_TABLE = 1
onready var max_tables = $YSort/Tables.get_child_count()
var cur_table = BASE_TABLE

var cur_recette: String = ""
var cur_ingredient

var can_serve: bool = false
var has_ingredient: bool = false

onready var bouteille = get_node("YSort/Bouteille")


func get_random_color():
	return champi_couleurs[champi_couleurs.keys()[randi()%(champi_couleurs.size()-1)]]

const INGREDIENTS = ["miel", "framboises", "mirtilles"]

func get_random_recette():
	var recette = []
	recette.push_back(INGREDIENTS[randi() % INGREDIENTS.size()])
	recette.push_back(INGREDIENTS[randi() % INGREDIENTS.size()])
	print(recette)
	return recette

func randomize_recettes():
	var recettes = []

	while recettes.size() < 4:
		var recette = get_random_recette()
		recette.sort()
		print(recette)
		if !recettes.has(recette):
			recettes.push_back(recette)
		
	for r in RECETTES:
		RECETTES[r] = recettes.pop_back()
		
	print(RECETTES)

var RECETTES = { 
					"orange": ["Miel", "Framboises"],
					"purple": ["Mirtille", "Framboises"],
					"pink": ["Framboises", "Framboises"],
					"green": ["Mirtille", "Miel"] 
				}

func spawn_all():
	var colors = [[],[]]
	for i in 4:
		colors[0] = get_random_color()
		colors[1] = get_random_color()
		while colors[0] == colors[1]:
			colors[1] = get_random_color()
		spawn_champi(colors[0])
		spawn_champi(colors[1])

func set_camera_enabled(enabled):
	$CameraMouse.should_move = enabled

var is_started: bool = false
func start_game():
	$YSort/LevelNavigation.can_move = true
	randomize()
	
	$Chauderon.connect("reached", self, "_onChauderon_reached")
	$YSort/Bar/Porte/Area2D.connect("body_entered", self, "_on_PorteBarArea_entered")
	$YSort/Bar/Porte/Area2D.connect("body_exited", self, "_on_PorteBarArea_exited")
	for ingredient in $YSort/Ingredients.get_children():
		ingredient.connect("reached", self, "_onIngredient_reached")
	
	for table in $YSort/Tables.get_children():
		table.connect("champi_matched", self, "_on_Champis_matched")
	
	bouteille.connect("reached", self, "_onBouteille_reached")
		
	spawn_all()
	randomize_recettes()
	$Livre.prepare_recettes_sprites(RECETTES)
	
	

const champi_couleurs = {
						"pink":["c92e70", "9e2081"],
						"green":["5d7668", "235a63"],
						"orange":["ffb366", "ff5b4f"],
						"purple":["ad82cf", "8455a9"],
						"bad":["814d6e", "533a44"],
						}

func spawn_champi(colors):
	
	if cur_table > max_tables: return
	var champ = Champignon.instance()
	print(colors)
	champ.set_colors(colors[0], colors[1])
	champ.connect("reached", self, "_on_Champi_reached")
	var table
	while true:
		table = get_node("YSort/Tables/Table" + str(cur_table))
		if table.is_full():
			cur_table += 1
			if cur_table > max_tables: return
		else:
			break
	table.add_champi(champ)


func _onBouteille_reached():
	if bouteille.is_prepared:
		can_serve = true
		bouteille.hide_arrow()
		
		get_tree().call_group("champis", "make_selectable", true)
		get_tree().call_group("champis", "show_arrow")
		bouteille.target = $YSort/Barista
		$YSort/LevelNavigation/NavigationPolygonInstance.enabled = false
		$YSort/LevelNavigation/NavOpen.enabled = true




func _onIngredient_reached(ingredient_name):
	if bouteille.is_prepared or can_serve:
		return
	has_ingredient = true
	cur_ingredient = ingredient_name.to_lower()
	$Sounds/ClickIngr.play()
	$YSort/Barista.hide_ingredients()
	$YSort/Barista.show_ingredient(cur_ingredient)
	$Chauderon/Particles2D.emitting = true
	$Chauderon.show_arrow()
	


func _onChauderon_reached():
	if not has_ingredient:
		return

	if nb_ingredients_selected == MAX_INGREDIENTS: return
	
	list_ingredients.push_back(cur_ingredient)
	
	nb_ingredients_selected += 1
	
	has_ingredient = false
	cur_ingredient = ""
	$Chauderon/Particles2D.emitting = false
	$Chauderon.hide_arrow()
	$YSort/Barista.hide_ingredients()
	$Sounds/ChauderonSound.play()
	
	if nb_ingredients_selected == MAX_INGREDIENTS:
		$Sounds/ChauderonSound.play()
		$Sounds/Potion.play()
		$Sounds/Drops.play()
		check_recette(list_ingredients)
		nb_ingredients_selected = 0
		list_ingredients.clear()
		bouteille.show_arrow()
		
		
func _on_Champi_reached(champi):
	if not bouteille.is_prepared:
		return
		
	champi.get_node("AnimationPlayer").play("selected")
	
	if cur_recette == "bad":
		champi.set_colors(champi_couleurs[cur_recette][0], champi_couleurs[cur_recette][1])
		champi.get_shooked()
		$Sounds/BadPotion.play()
		$Sounds/No.play()
	elif cur_recette != "":
		var new_colors = champi_couleurs[cur_recette]
		champi.set_colors(new_colors[0], new_colors[1])
		$Sounds/Drink.play()
		$Sounds/Oh.play()
		
		cur_recette = ""
		var table = champi.table
		table.check_champis_color()
		
	get_tree().call_group("champis", "make_selectable", false)
	get_tree().call_group("champis", "hide_arrow")
	var finished = true
	for t in get_node("YSort/Tables").get_children():
		if !t.champis_same: 
			finished = false
			break
	
	if finished:
		get_tree().call_group("champis", "dance")
		$Sounds/Dance.play()
		$EndPopup/EndPopupTimer.start()
		
	bouteille.empty()
		

	
func check_recette(ingredients):
	
	print("ING" + str(ingredients))
	var is_ok: bool = false
	ingredients.invert()
	var ingredients_inv = ingredients.duplicate(true)
	ingredients.invert()
	
	cur_recette = "bad"
	
	for recette in RECETTES:
		
		var ing = RECETTES[recette]
		if ingredients == ing or ingredients_inv == ing:
			print(recette)
			show_recette(recette)
			cur_recette = recette
			break
			
	$YSort/Bouteille.prepare(champi_couleurs[cur_recette])
	
func _on_Champis_matched(champis):
	for c in champis:
		c.emit_hearts()
		c.in_love = true
		c.selectable = false

			
func show_recette(recette):
	var rec = get_node("Livre/Recette/Control/" + recette + "/Ingredients")
	rec.visible = visible
	get_node("Livre/Recette/Control/" + recette + "/PointInt").visible = false

func _on_PorteBarArea_exited(body):
	if can_serve:
		$YSort/Bar/Porte.play("open", true)
		
func _on_PorteBarArea_entered(body):
	if can_serve:
		$YSort/Bar/Porte.play("open")


func _on_BehindBarArea_area_entered(area):
	if not bouteille.is_prepared and can_serve:
		can_serve = false
		bouteille.target = $BouteilleDefaultPos
		
		$YSort/LevelNavigation/NavOpen.enabled = false
		$YSort/LevelNavigation/NavigationPolygonInstance.enabled = true
		


func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Continue_pressed():
	$EndPopup.visible = false


func _on_EndPopupTimer_timeout():
	$EndPopup.visible = true
