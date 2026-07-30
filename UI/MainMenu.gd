extends Control

var lobby = preload("res://Scenes/Lobby.tscn").instantiate()
@onready var main_menu = $VBoxContainer
@onready var tutorial = $Tutorial



@onready var remaining_label = $RemainingLabel
@onready var confirm_button = $ConfirmButton
@onready var player_life = 500

@onready var health_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc]

@onready var strength_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute2, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human2, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf2, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll2, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc2]

@onready var endurance_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute3, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human3, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf3, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll3, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc3]

@onready var criticality_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute4, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human4, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf4, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll4, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc4]

@onready var avoidance_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute5, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human5, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf5, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll5, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc5]

@onready var quickness_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute6, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human6, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf6, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll6, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc6]

@onready var resilience_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute7, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human7, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf7, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll7, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc7]

@onready var stabbing_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute10, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human10, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf10, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll10, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc10]

@onready var sword_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute11, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human11, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf11, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll11, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc11]

@onready var axe_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute12, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human12, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf12, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll12, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc12]

@onready var mace_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute13, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human13, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf13, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll13, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc13]

@onready var flagellation_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute14, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human14, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf14, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll14, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc14]

@onready var shield_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Attribute15, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human15, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf15, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll15, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc15]

@onready var human_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human2, 
	$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human3, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human7, 
	$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human4, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human5, 
	$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human6, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human10,
	 $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human11, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human12, 
	$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human13, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human14,
	 $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Human15, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/HumanTitle]
	
@onready var elf_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf2, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf3, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf7, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf4, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf5, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf6, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf10, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf11, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf12, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf13, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf14,
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Elf15, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/ElfTitle]

@onready var orc_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc2, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc3, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc7,
 $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc4, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc5, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc6, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc10,
 $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc11, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc12, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc13, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc14, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Orc15, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/OrcTitle]

@onready var troll_mods = [$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll2, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll3, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll7, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll4, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll5, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll6, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll10, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll11, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll12, 
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll13, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll14,
$Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/Troll15, $Tutorial/Pages/Page4/AttributePanelHelp2/GridContainer/TrollTitle]

var enter_color = "b3a555bb"
var exit_color = "b3a55500"


func _ready():
	$VBoxContainer/StartButton.pressed.connect(on_start_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(on_options_pressed)
	$VBoxContainer/ExitButton.pressed.connect(on_exit_pressed)
	


func on_start_pressed():

	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")





func on_options_pressed():
	print("Options clicked - not implemented yet")

func on_exit_pressed():
	get_tree().quit()


func _on_tutorial_button_pressed() -> void:
	main_menu.visible = false
	tutorial.visible = true


func _on_go_back_pressed() -> void:
	main_menu.visible = true
	tutorial.visible = false



func apply_stylebox(mods, color):
	for mod in mods:
		var old_sb = mod.get_theme_stylebox("normal")

		if old_sb:
			var new_sb = old_sb.duplicate()
			new_sb.bg_color = color
			mod.add_theme_stylebox_override("normal", new_sb)

func _on_human_mouse_entered() -> void:
	apply_stylebox(human_mods, enter_color)

func _on_human_mouse_exited() -> void:
	apply_stylebox(human_mods, exit_color)

func _on_elf_mouse_entered() -> void:
	apply_stylebox(elf_mods, enter_color)


func _on_elf_mouse_exited() -> void:
	apply_stylebox(elf_mods, exit_color)


func _on_orc_mouse_entered() -> void:
	apply_stylebox(orc_mods, enter_color)


func _on_orc_mouse_exited() -> void:
	apply_stylebox(orc_mods, exit_color)


func _on_troll_mouse_entered() -> void:
	apply_stylebox(troll_mods, enter_color)


func _on_troll_mouse_exited() -> void:
	apply_stylebox(troll_mods, exit_color)


func _on_health_icon_mouse_entered() -> void:
	apply_stylebox(health_mods, enter_color)


func _on_health_icon_mouse_exited() -> void:
	apply_stylebox(health_mods, exit_color)


func _on_endurance_icon_mouse_entered() -> void:
	apply_stylebox(endurance_mods, enter_color)


func _on_endurance_icon_mouse_exited() -> void:
	apply_stylebox(endurance_mods, exit_color)


func _on_avoidance_icon_mouse_entered() -> void:
	apply_stylebox(avoidance_mods, enter_color)


func _on_avoidance_icon_mouse_exited() -> void:
	apply_stylebox(avoidance_mods, exit_color)


func _on_resilience_icon_mouse_entered() -> void:
	apply_stylebox(resilience_mods, enter_color)


func _on_resilience_icon_mouse_exited() -> void:
	apply_stylebox(resilience_mods, exit_color)


func _on_strength_icon_mouse_entered() -> void:
	apply_stylebox(strength_mods, enter_color)


func _on_strength_icon_mouse_exited() -> void:
	apply_stylebox(strength_mods, exit_color)


func _on_criticality_icon_mouse_entered() -> void:
	apply_stylebox(criticality_mods, enter_color)


func _on_criticality_icon_mouse_exited() -> void:
	apply_stylebox(criticality_mods, exit_color)


func _on_quickness_icon_mouse_entered() -> void:
	apply_stylebox(quickness_mods, enter_color)


func _on_quickness_icon_mouse_exited() -> void:
	apply_stylebox(quickness_mods, exit_color)


func _on_sword_icon_mouse_entered() -> void:
	apply_stylebox(sword_mods, enter_color)


func _on_sword_icon_mouse_exited() -> void:
	apply_stylebox(sword_mods, exit_color)


func _on_axe_icon_mouse_entered() -> void:
	apply_stylebox(axe_mods, enter_color)


func _on_axe_icon_mouse_exited() -> void:
	apply_stylebox(axe_mods, exit_color)


func _on_stabbing_icon_mouse_entered() -> void:
	apply_stylebox(stabbing_mods, enter_color)


func _on_stabbing_icon_mouse_exited() -> void:
	apply_stylebox(stabbing_mods, exit_color)


func _on_mace_icon_mouse_entered() -> void:
	apply_stylebox(mace_mods, enter_color)


func _on_mace_icon_mouse_exited() -> void:
	apply_stylebox(mace_mods, exit_color)


func _on_flagellation_icon_mouse_entered() -> void:
	apply_stylebox(flagellation_mods, enter_color)


func _on_flagellation_icon_mouse_exited() -> void:
	apply_stylebox(flagellation_mods, exit_color)


func _on_shield_icon_mouse_entered() -> void:
	apply_stylebox(shield_mods, enter_color)


func _on_shield_icon_mouse_exited() -> void:
	apply_stylebox(shield_mods, exit_color)
