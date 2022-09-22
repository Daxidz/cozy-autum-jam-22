extends TextureButton

onready var recette = $Recette
onready var page = $pageSound


# Called when the node enters the scene tree for the first time.
func _ready():
	recette.visible = false
	connect("mouse_entered", self, "_onMouse_entered")
	connect("mouse_exited", self, "_onMouse_exited")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _onMouse_entered():
	material.set_shader_param("cornered", true)
func _onMouse_exited():
	material.set_shader_param("cornered", false)


func _on_Livre_pressed():
	for b in $Recette/Control/Bouteilles.get_children():
		b.get_node("AnimationPlayer").play("prepared")
	recette.visible = !recette.visible
	if !page.playing:
		page.play()


func _on_Button_pressed():
	for b in $Recette/Control/Bouteilles.get_children():
		b.get_node("AnimationPlayer").stop()
	recette.visible = !recette.visible
	if !page.playing:
		page.play()

func prepare_recettes_sprites(recettes):
	for r in recettes:
		var recette_node = get_node("Recette/Control/" + r + "/Ingredients")
		recette_node.visible = false
		var interogation_node = get_node("Recette/Control/" + r + "/PointInt")
		interogation_node.visible = true
		recette_node.get_child(0).texture = load("res://assets/img/" + recettes[r][0] + ".png")
		recette_node.get_child(1).texture = load("res://assets/img/" + recettes[r][1] + ".png")
		
	
