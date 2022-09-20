extends TextureButton

onready var recette = $Recette


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Livre_pressed():
	recette.visible = !recette.visible


func _on_Button_pressed():
	recette.visible = !recette.visible

func prepare_recettes_sprites(recettes):
	for r in recettes:
		var recette_node = get_node("Recette/ColorRect/" + r)
		recette_node.get_child(0).texture = load("res://assets/img/" + recettes[r][0] + ".png")
		recette_node.get_child(1).texture = load("res://assets/img/" + recettes[r][1] + ".png")
		
	
