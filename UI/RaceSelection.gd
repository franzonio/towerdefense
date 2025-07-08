extends Control

func _ready():
	get_node("VBoxContainer/Human").pressed.connect(func(): on_race_selected("Human"))
	get_node("VBoxContainer/Elf").pressed.connect(func(): on_race_selected("Elf"))
	get_node("VBoxContainer/Orc").pressed.connect(func(): on_race_selected("Orc"))
	get_node("VBoxContainer/Troll").pressed.connect(func(): on_race_selected("Troll"))
	get_node("GoBack").pressed.connect(func(): go_back())

func on_race_selected(race: String):
	print("Selected race:", race)

	# Store the selected race in a global script or singleton if needed
	# e.g., GameState.selected_race = race

	# Now load the game scene
	GameState_.selected_race = race
	get_tree().change_scene_to_file("res://UI/AttributeAllocation.tscn")
	#get_tree().change_scene_to_file("res://Main.tscn")  # Replace with your actual game scene

func go_back():
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
