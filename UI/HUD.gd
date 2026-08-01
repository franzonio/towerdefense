extends CanvasLayer

var prev_life_dict = {}
var life_dict = {}
var new_endurance_sec = 9999
var endurance_sec = 9999

@onready var vfx_pngs = {

	"sword1": preload("res://Assets/Equipment/vfx/sword_t1_vfx.png"), 
	"sword2": preload("res://Assets/Equipment/vfx/sword_t2_vfx.png"), 
	"sword3": preload("res://Assets/Equipment/vfx/sword_t3_vfx.png"), 
	"sword4": preload("res://Assets/Equipment/vfx/sword_t4_vfx.png"), 

	"stabbing1": preload("res://Assets/Equipment/vfx/stabbing_t1_vfx.png"), 
	"stabbing2": preload("res://Assets/Equipment/vfx/stabbing_t2_vfx.png"), 
	"stabbing3": preload("res://Assets/Equipment/vfx/stabbing_t3_vfx.png"), 
	"stabbing4": preload("res://Assets/Equipment/vfx/stabbing_t4_vfx.png"), 

	"mace1": preload("res://Assets/Equipment/vfx/mace_t1_vfx.png"), 
	"mace2": preload("res://Assets/Equipment/vfx/mace_t2_vfx.png"), 
	"mace3": preload("res://Assets/Equipment/vfx/mace_t3_vfx.png"), 
	"mace4": preload("res://Assets/Equipment/vfx/mace_t4_vfx.png"), 

	"axe1": preload("res://Assets/Equipment/vfx/axe_t1_vfx.png"), 
	"axe2": preload("res://Assets/Equipment/vfx/axe_t2_vfx.png"), 
	"axe3": preload("res://Assets/Equipment/vfx/axe_t3_vfx.png"), 
	"axe4": preload("res://Assets/Equipment/vfx/axe_t4_vfx.png"), 

	"flagellation1": preload("res://Assets/Equipment/vfx/flagellation_t1_vfx.png"), 
	"flagellation2": preload("res://Assets/Equipment/vfx/flagellation_t2_vfx.png"), 
	"flagellation3": preload("res://Assets/Equipment/vfx/flagellation_t3_vfx.png"), 
	"flagellation4": preload("res://Assets/Equipment/vfx/flagellation_t4_vfx.png"), 


	"shield1": null, 
	"shield2": null, 
	"shield3": null, 
	"shield4": null, 

	"unarmed": preload("res://Assets/Equipment/vfx/unarmed_vfx.png")
}

@onready var wep_pngs = {
	# Mace
	"wooden_hammer": preload("res://Assets/Equipment/Mace/mace_t1_light_128x128.png"), 
	"steel_hammer": preload("res://Assets/Equipment/Mace/mace_t2_light_128x128.png"), 
	"verdant_mallet": preload("res://Assets/Equipment/Mace/mace_t3_light_128x128.png"), 
	"diamond_mallet": preload("res://Assets/Equipment/Mace/mace_t4_light_128x128.png"), 
	"battleworn_mace": preload("res://Assets/Equipment/Mace/mace_t1_heavy_128x128.png"), 
	"iron_mace": preload("res://Assets/Equipment/Mace/mace_t2_heavy_128x128.png"), 
	"emberized_crusher": preload("res://Assets/Equipment/Mace/mace_t3_heavy_128x128.png"), 
	"crimson_crusher": preload("res://Assets/Equipment/Mace/mace_t4_heavy_128x128.png"), 
	"barbaric_warhammer": preload("res://Assets/Equipment/Mace/mace_t1_2h_128x128.png"), 
	"knightly_warhammer": preload("res://Assets/Equipment/Mace/mace_t2_2h_128x128.png"), 
	"draconic_skullbasher": preload("res://Assets/Equipment/Mace/mace_t3_2h_128x128.png"), 
	"demonic_skullbasher": preload("res://Assets/Equipment/Mace/mace_t4_2h_128x128.png"), 

	# Axe
	"wooden_hatchet": preload("res://Assets/Equipment/Axe/axe_t1_light_128x128.png"), 
	"steel_hatchet": preload("res://Assets/Equipment/Axe/axe_t2_light_128x128.png"), 
	"verdant_splitter": preload("res://Assets/Equipment/Axe/axe_t3_light_128x128.png"), 
	"diamond_splitter": preload("res://Assets/Equipment/Axe/axe_t4_light_128x128.png"), 
	"battleworn_axe": preload("res://Assets/Equipment/Axe/axe_t1_heavy_128x128.png"), 
	"iron_axe": preload("res://Assets/Equipment/Axe/axe_t2_heavy_128x128.png"), 
	"emberized_cleaver": preload("res://Assets/Equipment/Axe/axe_t3_heavy_128x128.png"), 
	"crimson_cleaver": preload("res://Assets/Equipment/Axe/axe_t4_heavy_128x128.png"), 
	"barbaric_decapitator": preload("res://Assets/Equipment/Axe/axe_2h_t1_heavy_128x128.png"), 
	"knightly_decapitator": preload("res://Assets/Equipment/Axe/axe_2h_t2_heavy_128x128.png"), 
	"draconic_executioner": preload("res://Assets/Equipment/Axe/axe_2h_t3_heavy_128x128.png"), 
	"demonic_executioner": preload("res://Assets/Equipment/Axe/axe_2h_t4_heavy_128x128.png"), 

	# Stabbing
	"wooden_dagger": preload("res://Assets/Equipment/Stabbing/stabbing_t1_light_128x128.png"), 
	"steel_dagger": preload("res://Assets/Equipment/Stabbing/stabbing_t2_light_128x128.png"), 
	"verdant_shard": preload("res://Assets/Equipment/Stabbing/stabbing_t3_light_128x128.png"), 
	"diamond_shard": preload("res://Assets/Equipment/Stabbing/stabbing_t4_light_128x128.png"), 
	"battleworn_carver": preload("res://Assets/Equipment/Stabbing/stabbing_t1_heavy_128x128.png"), 
	"iron_carver": preload("res://Assets/Equipment/Stabbing/stabbing_t2_heavy_128x128.png"), 
	"emberized_stiletto": preload("res://Assets/Equipment/Stabbing/stabbing_t3_heavy_128x128.png"), 
	"crimson_stiletto": preload("res://Assets/Equipment/Stabbing/stabbing_t4_heavy_128x128.png"), 
	"barbaric_pike": preload("res://Assets/Equipment/Stabbing/stabbing_t1_2h_128x128.png"), 
	"knightly_pike": preload("res://Assets/Equipment/Stabbing/stabbing_t2_2h_128x128.png"), 
	"draconic_trident": preload("res://Assets/Equipment/Stabbing/stabbing_t3_2h_128x128.png"), 
	"demonic_trident": preload("res://Assets/Equipment/Stabbing/stabbing_t4_2h_128x128.png"), 

	# Flagellation
	"wooden_whip": preload("res://Assets/Equipment/Flagellation/flagellation_t1_light_128x128.png"), 
	"steel_whip": preload("res://Assets/Equipment/Flagellation/flagellation_t2_light_128x128.png"), 
	"verdant_knout": preload("res://Assets/Equipment/Flagellation/flagellation_t3_light_128x128.png"), 
	"diamond_knout": preload("res://Assets/Equipment/Flagellation/flagellation_t4_light_128x128.png"), 
	"battleworn_flail": preload("res://Assets/Equipment/Flagellation/flagellation_t1_heavy_128x128.png"), 
	"iron_flail": preload("res://Assets/Equipment/Flagellation/flagellation_t2_heavy_128x128.png"), 
	"emberized_scourge": preload("res://Assets/Equipment/Flagellation/flagellation_t3_heavy_128x128.png"), 
	"crimson_scourge": preload("res://Assets/Equipment/Flagellation/flagellation_t4_heavy_128x128.png"), 
	"barbaric_chainflogger": preload("res://Assets/Equipment/Flagellation/flagellation_t1_2h_128x128.png"), 
	"knightly_spikes": preload("res://Assets/Equipment/Flagellation/flagellation_t2_2h_128x128.png"), 
	"draconic_disemboweler": preload("res://Assets/Equipment/Flagellation/flagellation_t3_2h_128x128.png"), 
	"demonic_torturer": preload("res://Assets/Equipment/Flagellation/flagellation_t4_2h_128x128.png"), 

	# Sword
	"wooden_sword": preload("res://Assets/Equipment/Sword/sword_t1_light_128x128.png"), 
	"steel_sword": preload("res://Assets/Equipment/Sword/sword_t2_light_128x128.png"), 
	"verdant_slicer": preload("res://Assets/Equipment/Sword/sword_t3_light_128x128.png"), 
	"diamond_slicer": preload("res://Assets/Equipment/Sword/sword_t4_light_128x128.png"), 
	"battleworn_blade": preload("res://Assets/Equipment/Sword/sword_t1_heavy_128x128.png"), 
	"iron_blade": preload("res://Assets/Equipment/Sword/sword_t2_heavy_128x128.png"), 
	"emberized_slasher": preload("res://Assets/Equipment/Sword/sword_t3_heavy_128x128.png"), 
	"crimson_slasher": preload("res://Assets/Equipment/Sword/sword_t4_heavy_128x128.png"), 
	"barbaric_claymore": preload("res://Assets/Equipment/Sword/sword_t1_2h_128x128.png"), 
	"knightly_claymore": preload("res://Assets/Equipment/Sword/sword_t2_2h_128x128.png"), 
	"draconic_edge": preload("res://Assets/Equipment/Sword/sword_t3_2h_128x128.png"), 
	"demonic_edge": preload("res://Assets/Equipment/Sword/sword_t4_2h_128x128.png"), 

	# Shield
	"wooden_guard": preload("res://Assets/Equipment/Shield/shield_light_t1_128x128.png"), 
	"steel_guard": preload("res://Assets/Equipment/Shield/shield_light_t2_128x128.png"), 
	"verdant_aegis": preload("res://Assets/Equipment/Shield/shield_light_t3_128x128.png"), 
	"diamond_aegis": preload("res://Assets/Equipment/Shield/shield_light_t4_128x128.png"), 
	"battleworn_wall": preload("res://Assets/Equipment/Shield/shield_heavy_t1_128x128.png"), 
	"iron_wall": preload("res://Assets/Equipment/Shield/shield_heavy_t2_128x128.png"), 
	"emberized_bulwark": preload("res://Assets/Equipment/Shield/shield_heavy_t3_128x128.png"), 
	"crimson_bulwark": preload("res://Assets/Equipment/Shield/shield_heavy_t4_128x128.png"), 
}

@onready var esc_menu = $EscMenu
@onready var resume_button = $EscMenu/Resume
@onready var options_button = $EscMenu/Options
@onready var disconnect_button = $EscMenu/Disconnect
@onready var confirm_disconnect = $EscMenu/ConfirmDisconnect

@onready var inventory_popup: = $InventoryPopup
@onready var equipment_popup: = $EquipmentPopup
@onready var craft_bench_popup: = $CraftbenchPopup
@onready var label_round = $Label_Round
@onready var label_gold = $Label_Gold
@onready var label_xp = $Label_Experience
@onready var label_buy_roll = $LabelBuyRoll
@onready var label_buy_exp = $LabelBuyExp

var label_gold_position


const MAX_MESSAGES = 50
const MAX_LENGTH = 255

@onready var chat_log = $Panel/ChatScroll/ChatLog
@onready var chat_input = $HBoxContainer/ChatInput
@onready var send_button = $HBoxContainer/SendButton
@onready var chat_scroll = $Panel/ChatScroll

@export var round_now = 0
@export var time_passed: float = 0.0
@export var gold: int = 0
@export var experience: int = 0

@export var name_label: Node
@export var race_label: Node
@export var life_label: Node
@export var inspect_label: Node

var player_gladiator_data
var all_gladiators


var intermission: = true
var shop_pressed: = false
var equipment_pressed: = false
var chat_input_pressed: = false
var msg_just_sent: = false




@export var all_cards: Array

var reroll_start_of_intermission
var is_refreshing: = false
@export var card_stock: Dictionary

var selected_item_name: = ""
var selected_slot: = ""
var equipment_button_parent_name
var name_and_chat_outline_thickness = 6

var is_shop_locked: = false

@onready var shop_grid = $ShopGridContainer
@onready var inventory_grid = $Inventory/InventoryGridContainer
@onready var countdown_label = $IntermissionTimerLabel
@onready var shop = $Shop
@onready var concede_threshold_menu = $ConcedePanel/ConcedeThresholdMenu
@onready var stance_menu = $StancePanel/StanceMenu
@onready var attack_menu = $AttackPanel/AttackMenu
@onready var exp_button = $ExpButton
@onready var refresh_button = $RefreshButton
@onready var lock_button = $LockShop

var my_endurance_bar
var endurance_bar
var equipment_panel_inspect
var equipment_panel
var equipment_panel_picture
var equipment_panel_name
var head_slot
var chest_slot
var shoulders_slot
var weapon1_slot
var weapon2_slot
var ring1_slot
var ring2_slot

var prev_gold = 0






@onready var stat_hit = $Stats/GridContainer/HitValue
@onready var stat_attack_speed = $Stats/GridContainer/AttackSpeedValue
@onready var stat_crit = $Stats/GridContainer/CritValue
@onready var stat_multi = $Stats/GridContainer/MultiValue
@onready var stat_absorb = $Stats/GridContainer/AbsorbValue
@onready var stat_dodge = $Stats/GridContainer/DodgeValue
@onready var stat_parry = $Stats/GridContainer/ParryValue
@onready var stat_block = $Stats/GridContainer/BlockValue
@onready var stat_weight = $Stats/GridContainer/WeightValue


@onready var elf_picture = preload("res://Assets/EquipmentPanel/elf2.png")
@onready var human_picture = preload("res://Assets/EquipmentPanel/human2.png")
@onready var orc_picture = preload("res://Assets/EquipmentPanel/orc.png")
@onready var troll_picture = preload("res://Assets/EquipmentPanel/troll.png")

@onready var attribute_panel = $AttributePanel
@onready var health_panel = $AttributePanel/VBoxContainer/Health
@onready var strength_panel = $AttributePanel/VBoxContainer/Strength
@onready var endurance_panel = $AttributePanel/VBoxContainer/Endurance
@onready var criticality_panel = $AttributePanel/VBoxContainer/Criticality
@onready var avoidance_panel = $AttributePanel/VBoxContainer/Avoidance
@onready var quickness_panel = $AttributePanel/VBoxContainer/Quickness
@onready var resilience_panel = $AttributePanel/VBoxContainer/Resilience
@onready var sword_mastery_panel = $AttributePanel/VBoxContainer/SwordMastery
@onready var axe_mastery_panel = $AttributePanel/VBoxContainer/AxeMastery
@onready var stabbing_mastery_panel = $AttributePanel/VBoxContainer/StabbingMastery
@onready var mace_mastery_panel = $AttributePanel/VBoxContainer/MaceMastery
@onready var flagellation_mastery_panel = $AttributePanel/VBoxContainer/FlagellationMastery
@onready var shield_mastery_panel = $AttributePanel/VBoxContainer/ShieldMastery
@onready var unarmed_mastery_panel = $AttributePanel/VBoxContainer/UnarmedMastery

@onready var health_icon_panel = $AttributePanel/VBoxContainer/HealthIcon
@onready var strength_icon_panel = $AttributePanel/VBoxContainer/StrengthIcon
@onready var endurance_icon_panel = $AttributePanel/VBoxContainer/EnduranceIcon
@onready var criticality_icon_panel = $AttributePanel/VBoxContainer/CriticalityIcon
@onready var avoidance_icon_panel = $AttributePanel/VBoxContainer/AvoidanceIcon
@onready var quickness_icon_panel = $AttributePanel/VBoxContainer/QuicknessIcon
@onready var resilience_icon_panel = $AttributePanel/VBoxContainer/ResilienceIcon
@onready var sword_mastery_icon_panel = $AttributePanel/VBoxContainer/SwordIcon
@onready var axe_mastery_icon_panel = $AttributePanel/VBoxContainer/AxeIcon
@onready var stabbing_mastery_icon_panel = $AttributePanel/VBoxContainer/StabbingIcon
@onready var mace_mastery_icon_panel = $AttributePanel/VBoxContainer/MaceIcon
@onready var flagellation_mastery_icon_panel = $AttributePanel/VBoxContainer/FlagellationIcon
@onready var shield_mastery_icon_panel = $AttributePanel/VBoxContainer/ShieldIcon

@onready var points_left_label = $AttributePanel/PointsLeft
@onready var regret_points_label = $AttributePanel/RegretPointsLeft
@onready var points_info = $AttributePanel/Info

@onready var attribute_icons = [health_icon_panel, strength_icon_panel, endurance_icon_panel, criticality_icon_panel, 
	avoidance_icon_panel, quickness_icon_panel, resilience_icon_panel, sword_mastery_icon_panel, axe_mastery_icon_panel, 
	stabbing_mastery_icon_panel, mace_mastery_icon_panel, flagellation_mastery_icon_panel, shield_mastery_icon_panel]

@onready var scroll_of_luck = $CraftingContainer/CraftingMats/ScrollOfLuck
@onready var scroll_of_injection = $CraftingContainer/CraftingMats/ScrollOfInjection

@onready var crafting_container = $CraftingContainer
@onready var shop_button = $ShopButton

var physique_limits = {"Low": 70, "Good": 140, "Excellent": 220, "Outstanding": 310, "Legendary": 410}
var agility_limits = {"Low": 60, "Good": 120, "Excellent": 190, "Outstanding": 270, "Legendary": 360}
var weight_limits = {"Weightless": 20, "Lightweight": 28, "Midweight": 38, "Heavyweight": 50, "Massive": 64}

var exp_for_level = {"1": 0, "2": 10, "3": 12, "4": 14, "5": 18, "6": 22, "7": 26, "8": 30, "9": 34, "10": 36}
var max_lvl

var equipment_script
var equipment_instance
var equipment_data

signal concede_threshold_changed(value: int)
signal stance_changed(value: int)
signal attack_changed(value: int)
var craft_active = ""

### ATTRIBUTES ###
@onready var strength_card = preload("res://ShopCards/AttributeCards/StrengthCard.tscn")
@onready var health_card = preload("res://ShopCards/AttributeCards/HealthCard.tscn")
@onready var avoidance_card = preload("res://ShopCards/AttributeCards/AvoidanceCard.tscn")
@onready var criticality_card = preload("res://ShopCards/AttributeCards/CriticalityCard.tscn")
@onready var endurance_card = preload("res://ShopCards/AttributeCards/EnduranceCard.tscn")
@onready var quickness_card = preload("res://ShopCards/AttributeCards/QuicknessCard.tscn")
@onready var resilience_card = preload("res://ShopCards/AttributeCards/ResilienceCard.tscn")
@onready var sword_mastery_card = preload("res://ShopCards/AttributeCards/SwordMasteryCard.tscn")
@onready var axe_mastery_card = preload("res://ShopCards/AttributeCards/AxeMasteryCard.tscn")
@onready var shield_mastery_card = preload("res://ShopCards/AttributeCards/ShieldMasteryCard.tscn")
@onready var mace_mastery_card = preload("res://ShopCards/AttributeCards/MaceMasteryCard.tscn")
@onready var stabbing_mastery_card = preload("res://ShopCards/AttributeCards/StabbingMasteryCard.tscn")
@onready var flagellation_mastery_card = preload("res://ShopCards/AttributeCards/FlagellationMasteryCard.tscn")

### TOKENS ###
@onready var regret_token1_card = preload("res://ShopCards/RegretTokenCards/RegretToken1.tscn")

### CRAFTING ###
@onready var scroll_of_luck_card = preload("res://ShopCards/CraftCards/ScrollOfLuckCard.tscn")
@onready var scroll_of_injection_card = preload("res://ShopCards/CraftCards/ScrollOfInjectionCard.tscn")

### AXE ###
@onready var wooden_hatchet_card = preload("res://ShopCards/EquipmentCards/Axe/1h/WoodenHatchet.tscn")
@onready var steel_hatchet_card = preload("res://ShopCards/EquipmentCards/Axe/1h/SteelHatchet.tscn")
@onready var verdant_splitter_card = preload("res://ShopCards/EquipmentCards/Axe/1h/VerdantSplitter.tscn")
@onready var diamond_splitter_card = preload("res://ShopCards/EquipmentCards/Axe/1h/DiamondSplitter.tscn")

@onready var battleworn_axe_card = preload("res://ShopCards/EquipmentCards/Axe/1h/BattlewornAxe.tscn")
@onready var iron_axe_card = preload("res://ShopCards/EquipmentCards/Axe/1h/IronAxe.tscn")
@onready var emberized_cleaver_card = preload("res://ShopCards/EquipmentCards/Axe/1h/EmberizedCleaver.tscn")
@onready var crimson_cleaver_card = preload("res://ShopCards/EquipmentCards/Axe/1h/CrimsonCleaver.tscn")

@onready var barbaric_decapitator_card = preload("res://ShopCards/EquipmentCards/Axe/2h/BarbaricDecapitator.tscn")
@onready var knightly_decapitator_card = preload("res://ShopCards/EquipmentCards/Axe/2h/KnightlyDecapitator.tscn")
@onready var draconic_executioner_card = preload("res://ShopCards/EquipmentCards/Axe/2h/DraconicExecutioner.tscn")
@onready var demonic_executioner_card = preload("res://ShopCards/EquipmentCards/Axe/2h/DemonicExecutioner.tscn")

### FLAGELLATION ###
@onready var wooden_whip_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/WoodenWhip.tscn")
@onready var steel_whip_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/SteelWhip.tscn")
@onready var verdant_knout_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/VerdantKnout.tscn")
@onready var diamond_knout_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/DiamondKnout.tscn")

@onready var battleworn_flail_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/BattlewornFlail.tscn")
@onready var iron_flail_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/IronFlail.tscn")
@onready var emberized_scourge_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/EmberizedScourge.tscn")
@onready var crimson_scourge_card = preload("res://ShopCards/EquipmentCards/Flagellation/1h/CrimsonScourge.tscn")

@onready var barbaric_chainflogger_card = preload("res://ShopCards/EquipmentCards/Flagellation/2h/BarbaricChainflogger.tscn")
@onready var knightly_spikes_card = preload("res://ShopCards/EquipmentCards/Flagellation/2h/KnightlySpikes.tscn")
@onready var draconic_disemboweler_card = preload("res://ShopCards/EquipmentCards/Flagellation/2h/DraconicDisemboweler.tscn")
@onready var demonic_torturer_card = preload("res://ShopCards/EquipmentCards/Flagellation/2h/DemonicTorturer.tscn")

### MACE ###
@onready var wooden_hammer_card = preload("res://ShopCards/EquipmentCards/Mace/1h/WoodenHammer.tscn")
@onready var steel_hammer_card = preload("res://ShopCards/EquipmentCards/Mace/1h/SteelHammer.tscn")
@onready var verdant_mallet_card = preload("res://ShopCards/EquipmentCards/Mace/1h/VerdantMallet.tscn")
@onready var diamond_mallet_card = preload("res://ShopCards/EquipmentCards/Mace/1h/DiamondMallet.tscn")

@onready var battleworn_mace_card = preload("res://ShopCards/EquipmentCards/Mace/1h/BattlewornMace.tscn")
@onready var iron_mace_card = preload("res://ShopCards/EquipmentCards/Mace/1h/IronMace.tscn")
@onready var emberized_crusher_card = preload("res://ShopCards/EquipmentCards/Mace/1h/EmberizedCrusher.tscn")
@onready var crimson_crusher_card = preload("res://ShopCards/EquipmentCards/Mace/1h/CrimsonCrusher.tscn")

@onready var barbaric_warhammer_card = preload("res://ShopCards/EquipmentCards/Mace/2h/BarbaricWarhammer.tscn")
@onready var knightly_warhammer_card = preload("res://ShopCards/EquipmentCards/Mace/2h/KnightlyWarhammer.tscn")
@onready var draconic_skullbasher_card = preload("res://ShopCards/EquipmentCards/Mace/2h/DraconicSkullbasher.tscn")
@onready var demonic_skullbasher_card = preload("res://ShopCards/EquipmentCards/Mace/2h/DemonicSkullbasher.tscn")

### STABBING ###
@onready var wooden_dagger_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/WoodenDagger.tscn")
@onready var steel_dagger_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/SteelDagger.tscn")
@onready var verdant_shard_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/VerdantShard.tscn")
@onready var diamond_shard_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/DiamondShard.tscn")

@onready var battleworn_carver_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/BattlewornCarver.tscn")
@onready var iron_carver_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/IronCarver.tscn")
@onready var emberized_stiletto_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/EmberizedStiletto.tscn")
@onready var crimson_stiletto_card = preload("res://ShopCards/EquipmentCards/Stabbing/1h/CrimsonStiletto.tscn")

@onready var barbaric_pike_card = preload("res://ShopCards/EquipmentCards/Stabbing/2h/BarbaricPike.tscn")
@onready var knightly_pike_card = preload("res://ShopCards/EquipmentCards/Stabbing/2h/KnightlyPike.tscn")
@onready var draconic_trident_card = preload("res://ShopCards/EquipmentCards/Stabbing/2h/DraconicTrident.tscn")
@onready var demonic_trident_card = preload("res://ShopCards/EquipmentCards/Stabbing/2h/DemonicTrident.tscn")

### SWORD ###
@onready var wooden_sword_card = preload("res://ShopCards/EquipmentCards/Sword/1h/WoodenSword.tscn")
@onready var steel_sword_card = preload("res://ShopCards/EquipmentCards/Sword/1h/SteelSword.tscn")
@onready var verdant_slicer_card = preload("res://ShopCards/EquipmentCards/Sword/1h/VerdantSlicer.tscn")
@onready var diamond_slicer_card = preload("res://ShopCards/EquipmentCards/Sword/1h/DiamondSlicer.tscn")

@onready var battleworn_blade_card = preload("res://ShopCards/EquipmentCards/Sword/1h/BattlewornBlade.tscn")
@onready var iron_blade_card = preload("res://ShopCards/EquipmentCards/Sword/1h/IronBlade.tscn")
@onready var emberized_slasher_card = preload("res://ShopCards/EquipmentCards/Sword/1h/EmberizedSlasher.tscn")
@onready var crimson_slasher_card = preload("res://ShopCards/EquipmentCards/Sword/1h/CrimsonSlasher.tscn")

@onready var barbaric_claymore_card = preload("res://ShopCards/EquipmentCards/Sword/2h/BarbaricClaymore.tscn")
@onready var knightly_claymore_card = preload("res://ShopCards/EquipmentCards/Sword/2h/KnightlyClaymore.tscn")
@onready var draconic_edge_card = preload("res://ShopCards/EquipmentCards/Sword/2h/DraconicEdge.tscn")
@onready var demonic_edge_card = preload("res://ShopCards/EquipmentCards/Sword/2h/DemonicEdge.tscn")

### SHIELD ###
@onready var wooden_guard_card = preload("res://ShopCards/EquipmentCards/Shield/Light/WoodenGuard.tscn")
@onready var steel_guard_card = preload("res://ShopCards/EquipmentCards/Shield/Light/SteelGuard.tscn")
@onready var verdant_aegis_card = preload("res://ShopCards/EquipmentCards/Shield/Light/VerdantAegis.tscn")
@onready var diamond_aegis_card = preload("res://ShopCards/EquipmentCards/Shield/Light/DiamondAegis.tscn")
@onready var battleworn_wall_card = preload("res://ShopCards/EquipmentCards/Shield/Heavy/BattlewornWall.tscn")
@onready var iron_wall_card = preload("res://ShopCards/EquipmentCards/Shield/Heavy/IronWall.tscn")
@onready var emberized_bulwark_card = preload("res://ShopCards/EquipmentCards/Shield/Heavy/EmberizedBulwark.tscn")
@onready var crimson_bulwark_card = preload("res://ShopCards/EquipmentCards/Shield/Heavy/CrimsonBulwark.tscn")

### BELT ###
@onready var leather_belt_card = preload("res://ShopCards/EquipmentCards/Belt/Light/LeatherBelt.tscn")
@onready var tailored_belt_card = preload("res://ShopCards/EquipmentCards/Belt/Light/TailoredBelt.tscn")
@onready var strap_of_elven_silk_card = preload("res://ShopCards/EquipmentCards/Belt/Light/StrapOfElvenSilk.tscn")
@onready var strap_of_sin_card = preload("res://ShopCards/EquipmentCards/Belt/Light/StrapOfSin.tscn")
@onready var plate_waistguard_card = preload("res://ShopCards/EquipmentCards/Belt/Heavy/PlateWaistguard.tscn")
@onready var steelforged_waistguard_card = preload("res://ShopCards/EquipmentCards/Belt/Heavy/SteelforgedWaistguard.tscn")
@onready var girdle_of_kings_card = preload("res://ShopCards/EquipmentCards/Belt/Heavy/GirdleOfKings.tscn")
@onready var bloodsteel_girdle_card = preload("res://ShopCards/EquipmentCards/Belt/Heavy/BloodsteelGirdle.tscn")

### BOOTS ###
@onready var leather_boots_card = preload("res://ShopCards/EquipmentCards/Boots/Light/LeatherBoots.tscn")
@onready var tailored_boots_card = preload("res://ShopCards/EquipmentCards/Boots/Light/TailoredBoots.tscn")
@onready var treads_of_elven_silk_card = preload("res://ShopCards/EquipmentCards/Boots/Light/TreadsOfElvenSilk.tscn")
@onready var treads_of_sin_card = preload("res://ShopCards/EquipmentCards/Boots/Light/TreadsOfSin.tscn")
@onready var plate_greaves_card = preload("res://ShopCards/EquipmentCards/Boots/Heavy/PlateGreaves.tscn")
@onready var steelforged_greaves_card = preload("res://ShopCards/EquipmentCards/Boots/Heavy/SteelforgedGreaves.tscn")
@onready var sabatons_of_kings_card = preload("res://ShopCards/EquipmentCards/Boots/Heavy/SabatonsOfKings.tscn")
@onready var bloodsteel_sabatons_card = preload("res://ShopCards/EquipmentCards/Boots/Heavy/BloodsteelSabatons.tscn")

### CHEST ###
@onready var leather_vest_card = preload("res://ShopCards/EquipmentCards/Chest/Light/LeatherVest.tscn")
@onready var tailored_vest_card = preload("res://ShopCards/EquipmentCards/Chest/Light/TailoredVest.tscn")
@onready var garb_of_elven_silk_card = preload("res://ShopCards/EquipmentCards/Chest/Light/GarbOfElvenSilk.tscn")
@onready var garb_of_sin_card = preload("res://ShopCards/EquipmentCards/Chest/Light/GarbOfSin.tscn")
@onready var plate_cuirass_card = preload("res://ShopCards/EquipmentCards/Chest/Heavy/PlateCuirass.tscn")
@onready var steelforged_cuirass_card = preload("res://ShopCards/EquipmentCards/Chest/Heavy/SteelforgedCuirass.tscn")
@onready var carapace_of_kings_card = preload("res://ShopCards/EquipmentCards/Chest/Heavy/CarapaceOfKings.tscn")
@onready var bloodsteel_carapace_card = preload("res://ShopCards/EquipmentCards/Chest/Heavy/BloodsteelCarapace.tscn")

### GLOVES ###
@onready var leather_gloves_card = preload("res://ShopCards/EquipmentCards/Gloves/Light/LeatherGloves.tscn")
@onready var tailored_gloves_card = preload("res://ShopCards/EquipmentCards/Gloves/Light/TailoredGloves.tscn")
@onready var hands_of_elven_silk_card = preload("res://ShopCards/EquipmentCards/Gloves/Light/HandsOfElvenSilk.tscn")
@onready var hands_of_sin_card = preload("res://ShopCards/EquipmentCards/Gloves/Light/HandsOfSin.tscn")
@onready var plate_gauntlets_card = preload("res://ShopCards/EquipmentCards/Gloves/Heavy/PlateGauntlets.tscn")
@onready var steelforged_gauntlets_card = preload("res://ShopCards/EquipmentCards/Gloves/Heavy/SteelforgedGauntlets.tscn")
@onready var grips_of_kings_card = preload("res://ShopCards/EquipmentCards/Gloves/Heavy/GripsOfKings.tscn")
@onready var bloodsteel_grips_card = preload("res://ShopCards/EquipmentCards/Gloves/Heavy/BloodsteelGrips.tscn")

### HEAD ###
@onready var leather_cap_card = preload("res://ShopCards/EquipmentCards/Head/Light/LeatherCap.tscn")
@onready var tailored_cap_card = preload("res://ShopCards/EquipmentCards/Head/Light/TailoredCap.tscn")
@onready var hat_of_elven_silk_card = preload("res://ShopCards/EquipmentCards/Head/Light/HatOfElvenSilk.tscn")
@onready var hat_of_sin_card = preload("res://ShopCards/EquipmentCards/Head/Light/HatOfSin.tscn")
@onready var plate_helmet_card = preload("res://ShopCards/EquipmentCards/Head/Heavy/PlateHelmet.tscn")
@onready var steelforged_helmet_card = preload("res://ShopCards/EquipmentCards/Head/Heavy/SteelforgedHelmet.tscn")
@onready var barbute_of_kings_card = preload("res://ShopCards/EquipmentCards/Head/Heavy/BarbuteOfKings.tscn")
@onready var bloodsteel_barbute_card = preload("res://ShopCards/EquipmentCards/Head/Heavy/BarbuteOfKings.tscn")

### LEGS ###
@onready var leather_pantaloons_card = preload("res://ShopCards/EquipmentCards/Legs/Light/LeatherPantaloons.tscn")
@onready var tailored_pantaloons_card = preload("res://ShopCards/EquipmentCards/Legs/Light/TailoredPantaloons.tscn")
@onready var legwraps_of_elven_silk_card = preload("res://ShopCards/EquipmentCards/Legs/Light/LegwrapsOfElvenSilk.tscn")
@onready var legwraps_of_sin_card = preload("res://ShopCards/EquipmentCards/Legs/Light/LegwrapsOfSin.tscn")
@onready var plate_legs_card = preload("res://ShopCards/EquipmentCards/Legs/Heavy/PlateLegs.tscn")
@onready var steelforged_Legs_card = preload("res://ShopCards/EquipmentCards/Legs/Heavy/SteelforgedLegs.tscn")
@onready var legguards_of_kings_card = preload("res://ShopCards/EquipmentCards/Legs/Heavy/LegguardsOfKings.tscn")
@onready var bloodsteel_legguards_card = preload("res://ShopCards/EquipmentCards/Legs/Heavy/BloodsteelLegguards.tscn")

### SHOULDERS ###
@onready var leather_shoulders_card = preload("res://ShopCards/EquipmentCards/Shoulders/Light/LeatherShoulders.tscn")
@onready var tailored_shoulders_card = preload("res://ShopCards/EquipmentCards/Shoulders/Light/TailoredShoulders.tscn")
@onready var mantle_of_elven_silk_card = preload("res://ShopCards/EquipmentCards/Shoulders/Light/MantleOfElvenSilk.tscn")
@onready var mantle_of_sin_card = preload("res://ShopCards/EquipmentCards/Shoulders/Light/MantleOfSin.tscn")
@onready var plate_spaulders_card = preload("res://ShopCards/EquipmentCards/Shoulders/Heavy/PlateSpaulders.tscn")
@onready var steelforged_spaulders_card = preload("res://ShopCards/EquipmentCards/Shoulders/Heavy/SteelforgedSpaulders.tscn")
@onready var pauldrons_of_kings_card = preload("res://ShopCards/EquipmentCards/Shoulders/Heavy/PauldronsOfKings.tscn")
@onready var bloodsteel_pauldrons_card = preload("res://ShopCards/EquipmentCards/Shoulders/Heavy/BloodsteelPauldrons.tscn")

### RING ###
@onready var ring_of_stone_card = preload("res://ShopCards/EquipmentCards/Ring/RingOfStone.tscn")
@onready var ring_of_noble_tears = preload("res://ShopCards/EquipmentCards/Ring/RingOfNobleTears.tscn")
@onready var ring_of_royals = preload("res://ShopCards/EquipmentCards/Ring/RingOfRoyals.tscn")
@onready var ring_of_the_emperor = preload("res://ShopCards/EquipmentCards/Ring/RingOfTheEmperor.tscn")

### AMULET ###
@onready var amulet_of_stone_card = preload("res://ShopCards/EquipmentCards/Amulet/AmuletOfStone.tscn")
@onready var amulet_of_noble_tears = preload("res://ShopCards/EquipmentCards/Amulet/AmuletOfNobleTears.tscn")
@onready var amulet_of_royals = preload("res://ShopCards/EquipmentCards/Amulet/AmuletOfRoyals.tscn")
@onready var amulet_of_the_emperor = preload("res://ShopCards/EquipmentCards/Amulet/AmuletOfTheEmperor.tscn")

var is_rerolling: = false

#var time_to_live = 9999
var rename_panels_done = 0
var points_left = 0
var regret_points_left = 0
var points_amount = 1
var prev_lvl: int = 1
var current_lvl: int = 1

var wep1_broken = 0
var wep2_broken = 0
var wep_statuses = {}

var healthbar_color = Color("77883b")
var race_modifiers

func _ready():
	wep1_broken = 0
	wep2_broken = 0
	race_modifiers = GameState_.RACE_MODIFIERS
	label_gold_position = label_gold.position

	lock_button["focus_mode"] = 0
	refresh_button["focus_mode"] = 0
	scroll_of_injection["focus_mode"] = 0
	scroll_of_luck["focus_mode"] = 0
	shop["focus_mode"] = 0
	shop_button["focus_mode"] = 0
	send_button["focus_mode"] = 0
	exp_button["focus_mode"] = 0
	concede_threshold_menu["focus_mode"] = 0
	stance_menu["focus_mode"] = 0
	attack_menu["focus_mode"] = 0
	$AttributePanel/Help["focus_mode"] = 0



	round_now = 1
	esc_menu.visible = false
	confirm_disconnect.visible = false

	equipment_script = load("res://Equipment.gd")
	equipment_instance = equipment_script.new()
	equipment_data = equipment_instance.all_equipment


	GameState_.connect("gladiator_life_changed", Callable(self, "_on_life_changed"))
	GameState_.connect("countdown_updated", Callable(self, "_on_countdown_updated"))
	GameState_.connect("card_stock_changed", Callable(self, "_on_card_stock_changed"))
	GameState_.connect("send_gladiator_data_to_peer_signal", Callable(self, "_on_send_gladiator_data_to_peer_signal"))
	GameState_.connect("broadcast_log_signal", Callable(self, "_on_log_received"))
	GameState_.connect("reroll_cards_new_round_signal", Callable(self, "_on_reroll_cards_new_round_signal"))

	GameState_.connect("add_item_to_inventory_signal", Callable(self, "_on_add_item_to_inventory"))
	GameState_.connect("remove_item_from_inventory_signal", Callable(self, "_on_remove_item_from_inventory"))
	GameState_.connect("add_item_to_equipment_signal", Callable(self, "_on_add_item_to_equipment"))
	GameState_.connect("remove_item_from_equipment_signal", Callable(self, "_on_remove_item_from_equipment"))
	
	GameState_.connect("refresh_inventory_ui_signal", Callable(self, "_on_refresh_inventory_ui"))

	health_icon_panel.add_theme_stylebox_override("disabled", health_icon_panel.get_theme_stylebox("normal"))
	strength_icon_panel.add_theme_stylebox_override("disabled", strength_icon_panel.get_theme_stylebox("normal"))
	endurance_icon_panel.add_theme_stylebox_override("disabled", endurance_icon_panel.get_theme_stylebox("normal"))
	criticality_icon_panel.add_theme_stylebox_override("disabled", criticality_icon_panel.get_theme_stylebox("normal"))
	avoidance_icon_panel.add_theme_stylebox_override("disabled", avoidance_icon_panel.get_theme_stylebox("normal"))
	quickness_icon_panel.add_theme_stylebox_override("disabled", quickness_icon_panel.get_theme_stylebox("normal"))
	resilience_icon_panel.add_theme_stylebox_override("disabled", resilience_icon_panel.get_theme_stylebox("normal"))
	sword_mastery_icon_panel.add_theme_stylebox_override("disabled", sword_mastery_icon_panel.get_theme_stylebox("normal"))
	axe_mastery_icon_panel.add_theme_stylebox_override("disabled", axe_mastery_icon_panel.get_theme_stylebox("normal"))
	stabbing_mastery_icon_panel.add_theme_stylebox_override("disabled", stabbing_mastery_icon_panel.get_theme_stylebox("normal"))
	mace_mastery_icon_panel.add_theme_stylebox_override("disabled", mace_mastery_icon_panel.get_theme_stylebox("normal"))
	flagellation_mastery_icon_panel.add_theme_stylebox_override("disabled", flagellation_mastery_icon_panel.get_theme_stylebox("normal"))
	shield_mastery_icon_panel.add_theme_stylebox_override("disabled", shield_mastery_icon_panel.get_theme_stylebox("normal"))
	

	send_button.pressed.connect(_on_send_pressed)
	chat_input.text_submitted.connect(_on_send_pressed)



	inventory_popup.clear()
	inventory_popup.add_item("Equip", 0)
	inventory_popup.add_item("Sell", 1)
	inventory_popup.id_pressed.connect(_on_inventory_popup_pressed)

	equipment_popup.clear()
	equipment_popup.add_item("Unequip", 0)
	equipment_popup.add_item("Sell", 1)
	equipment_popup.id_pressed.connect(_on_equipment_popup_pressed)

	craft_bench_popup.clear()
	craft_bench_popup.add_item("Move to inventory", 0)
	craft_bench_popup.id_pressed.connect(_on_craft_bench_popup_pressed)


	shop_grid.visible = true
	refresh_button.visible = true
	label_buy_roll.visible = true



	if multiplayer.is_server(): GameState_.initialize_card_stock()
	else: GameState_.rpc_id(1, "initialize_card_stock")
	await get_tree().create_timer(1).timeout
	all_cards = get_all_cards()

	if multiplayer.is_server():
		GameState_.refresh_gladiator_data(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "refresh_gladiator_data", multiplayer.get_unique_id())

	fix_icon_bonuses()

	await get_tree().create_timer(0.8).timeout

	populate_hud()
	roll_cards()
	refresh_button.disabled = false

	concede_threshold_menu.connect("item_selected", Callable(self, "_on_threshold_selected"))
	stance_menu.connect("item_selected", Callable(self, "_on_stance_selected"))
	attack_menu.connect("item_selected", Callable(self, "_on_attack_type_selected"))

	var keys = exp_for_level.keys()
	var int_keys = []
	for k in keys:
		int_keys.append(int(k))

	int_keys.sort()
	max_lvl = str(int_keys[-1])

func fix_icon_bonuses():
	if all_gladiators:
		health_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		strength_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		endurance_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		criticality_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		avoidance_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		quickness_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		resilience_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		axe_mastery_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		sword_mastery_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		stabbing_mastery_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		flagellation_mastery_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		mace_mastery_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])
		shield_mastery_icon_panel.set_race(all_gladiators[multiplayer.get_unique_id()]["race"])

func _process(delta: float) -> void :
	prev_lvl = current_lvl
	if all_gladiators:
		current_lvl = int(all_gladiators[multiplayer.get_unique_id()].get("level", 1))

	if prev_lvl < current_lvl:
		#points_left += 10
		grant_points_for_peer(multiplayer.get_unique_id(), 10)
		attribute_panel.modulate = "ffffff"
		TweenFX.spotlight(attribute_panel)
		update_attribute_ui()
		label_xp.scale = Vector2(1, 1)
		label_xp.modulate = "ffffff"
		label_xp.pivot_offset = label_xp.size / 2
		TweenFX.spotlight(label_xp, 0.2, Color("03877d"))
		TweenFX.pulsate(label_xp, 0.4, 1.1)
	if points_left < 0:
		points_left = 0

	time_passed += delta
	
	#endurance_bar.value = 5#endurance_sec - time_passed
	
	if rename_panels_done: 
		if intermission == false: 
			#print("end: " + str(endurance_sec))
			my_endurance_bar.value = float(new_endurance_sec) - float(time_passed)
			#print(all_gladiators[multiplayer.get_unique_id()]["name"] + ": " + str(endurance_bar.value))
		else: 
			my_endurance_bar.value = float(new_endurance_sec)

	if !intermission: label_round.bbcode_text = "[color=%s]Day  %s\n%s[/color]" % ["d2c9a5", str(round_now), str(int(time_passed))]
	if intermission:
		concede_threshold_menu.disabled = false
		stance_menu.disabled = false
		attack_menu.disabled = false
	else:
		concede_threshold_menu.disabled = true
		stance_menu.disabled = true
		attack_menu.disabled = true

	if Input.is_action_just_pressed("focus_chat"):
		chat_input.grab_focus()
	if Input.is_action_just_pressed("toggle_shop") and not chat_input.has_focus():
		if $ShopButton:
			$ShopButton.emit_signal("pressed")
	if Input.is_action_just_pressed("toggle_equipment") and not chat_input.has_focus():
		if $EquipmentButton:
			$EquipmentButton.emit_signal("pressed")
	if Input.is_action_just_pressed("refresh_cards") and not chat_input.has_focus():
		if $EquipmentButton:
			$RefreshButton.emit_signal("pressed")
	if Input.is_action_just_pressed("buy_exp") and not chat_input.has_focus():
		if $ExpButton:
			$ExpButton.emit_signal("button_up")

func _unhandled_input(event):

	if event.is_action_pressed("ui_cancel"):
		if esc_menu.visible:
			esc_menu.visible = false
		else:
			esc_menu.visible = true

func get_all_cards():
	all_cards = [

		[strength_card, "strength", card_stock["strength"]], 
		[health_card, "health", card_stock["health"]], 
		[criticality_card, "crit_rating", card_stock["crit_rating"]], 
		[endurance_card, "endurance", card_stock["endurance"]], 
		[quickness_card, "quickness", card_stock["quickness"]], 
		[resilience_card, "resilience", card_stock["resilience"]], 
		[avoidance_card, "avoidance", card_stock["avoidance"]], 


		[scroll_of_luck_card, "scroll_of_luck", card_stock["scroll_of_luck"]], 
		[scroll_of_injection_card, "scroll_of_injection", card_stock["scroll_of_injection"]], 


		[sword_mastery_card, "sword_mastery", card_stock["sword_mastery"]], 
		[axe_mastery_card, "axe_mastery", card_stock["axe_mastery"]], 
		[shield_mastery_card, "shield_mastery", card_stock["shield_mastery"]], 
		[stabbing_mastery_card, "stabbing_mastery", card_stock["stabbing_mastery"]], 
		[flagellation_mastery_card, "flagellation_mastery", card_stock["flagellation_mastery"]], 
		[mace_mastery_card, "mace_mastery", card_stock["mace_mastery"]],
		[regret_token1_card, "regret_token1", card_stock["regret_token1"]],


		[leather_vest_card, "leather_vest", card_stock["leather_vest"]], 
		[tailored_vest_card, "tailored_vest", card_stock["tailored_vest"]], 
		[garb_of_elven_silk_card, "garb_of_elven_silk", card_stock["garb_of_elven_silk"]], 
		[garb_of_sin_card, "garb_of_sin", card_stock["garb_of_sin"]], 
		[plate_cuirass_card, "plate_cuirass", card_stock["plate_cuirass"]], 
		[steelforged_cuirass_card, "steelforged_cuirass", card_stock["steelforged_cuirass"]], 
		[carapace_of_kings_card, "carapace_of_kings", card_stock["carapace_of_kings"]], 
		[bloodsteel_carapace_card, "bloodsteel_carapace", card_stock["bloodsteel_carapace"]], 


		[leather_cap_card, "leather_cap", card_stock["leather_cap"]], 
		[tailored_cap_card, "tailored_cap", card_stock["tailored_cap"]], 
		[hat_of_elven_silk_card, "hat_of_elven_silk", card_stock["hat_of_elven_silk"]], 
		[hat_of_sin_card, "hat_of_sin", card_stock["hat_of_sin"]], 
		[plate_helmet_card, "plate_helmet", card_stock["plate_helmet"]], 
		[steelforged_helmet_card, "steelforged_helmet", card_stock["steelforged_helmet"]], 
		[barbute_of_kings_card, "barbute_of_kings", card_stock["barbute_of_kings"]], 
		[bloodsteel_barbute_card, "bloodsteel_barbute", card_stock["bloodsteel_barbute"]], 


		[leather_shoulders_card, "leather_shoulders", card_stock["leather_shoulders"]], 
		[tailored_shoulders_card, "tailored_shoulders", card_stock["tailored_shoulders"]], 
		[mantle_of_elven_silk_card, "mantle_of_elven_silk", card_stock["mantle_of_elven_silk"]], 
		[mantle_of_sin_card, "mantle_of_sin", card_stock["mantle_of_sin"]], 
		[plate_spaulders_card, "plate_spaulders", card_stock["plate_spaulders"]], 
		[steelforged_spaulders_card, "steelforged_spaulders", card_stock["steelforged_spaulders"]], 
		[pauldrons_of_kings_card, "pauldrons_of_kings", card_stock["pauldrons_of_kings"]], 
		[bloodsteel_pauldrons_card, "bloodsteel_pauldrons", card_stock["bloodsteel_pauldrons"]], 


		[leather_belt_card, "leather_belt", card_stock["leather_belt"]], 
		[tailored_belt_card, "tailored_belt", card_stock["tailored_belt"]], 
		[strap_of_elven_silk_card, "strap_of_elven_silk", card_stock["strap_of_elven_silk"]], 
		[strap_of_sin_card, "strap_of_sin", card_stock["strap_of_sin"]], 
		[plate_waistguard_card, "plate_waistguard", card_stock["plate_waistguard"]], 
		[steelforged_waistguard_card, "steelforged_waistguard", card_stock["steelforged_waistguard"]], 
		[girdle_of_kings_card, "girdle_of_kings", card_stock["girdle_of_kings"]], 
		[bloodsteel_girdle_card, "bloodsteel_girdle", card_stock["bloodsteel_girdle"]], 


		[leather_boots_card, "leather_boots", card_stock["leather_boots"]], 
		[tailored_boots_card, "tailored_boots", card_stock["tailored_boots"]], 
		[treads_of_elven_silk_card, "treads_of_elven_silk", card_stock["treads_of_elven_silk"]], 
		[treads_of_sin_card, "treads_of_sin", card_stock["treads_of_sin"]], 
		[plate_greaves_card, "plate_greaves", card_stock["plate_greaves"]], 
		[steelforged_greaves_card, "steelforged_greaves", card_stock["steelforged_greaves"]], 
		[sabatons_of_kings_card, "sabatons_of_kings", card_stock["sabatons_of_kings"]], 
		[bloodsteel_sabatons_card, "bloodsteel_sabatons", card_stock["bloodsteel_sabatons"]], 


		[leather_gloves_card, "leather_gloves", card_stock["leather_gloves"]], 
		[tailored_gloves_card, "tailored_gloves", card_stock["tailored_gloves"]], 
		[hands_of_elven_silk_card, "hands_of_elven_silk", card_stock["hands_of_elven_silk"]], 
		[hands_of_sin_card, "hands_of_sin", card_stock["hands_of_sin"]], 
		[plate_gauntlets_card, "plate_gauntlets", card_stock["plate_gauntlets"]], 
		[steelforged_gauntlets_card, "steelforged_gauntlets", card_stock["steelforged_gauntlets"]], 
		[grips_of_kings_card, "grips_of_kings", card_stock["grips_of_kings"]], 
		[bloodsteel_grips_card, "bloodsteel_grips", card_stock["bloodsteel_grips"]], 


		[leather_pantaloons_card, "leather_pantaloons", card_stock["leather_pantaloons"]], 
		[tailored_pantaloons_card, "tailored_pantaloons", card_stock["tailored_pantaloons"]], 
		[legwraps_of_elven_silk_card, "legwraps_of_elven_silk", card_stock["legwraps_of_elven_silk"]], 
		[legwraps_of_sin_card, "legwraps_of_sin", card_stock["legwraps_of_sin"]], 
		[plate_legs_card, "plate_legs", card_stock["plate_legs"]], 
		[steelforged_Legs_card, "steelforged_legs", card_stock["steelforged_legs"]], 
		[legguards_of_kings_card, "legguards_of_kings", card_stock["legguards_of_kings"]], 
		[bloodsteel_legguards_card, "bloodsteel_legguards", card_stock["bloodsteel_legguards"]], 


		[wooden_sword_card, "wooden_sword", card_stock["wooden_sword"]], 
		[steel_sword_card, "steel_sword", card_stock["steel_sword"]], 
		[verdant_slicer_card, "verdant_slicer", card_stock["verdant_slicer"]], 
		[diamond_slicer_card, "diamond_slicer", card_stock["diamond_slicer"]], 
		[battleworn_blade_card, "battleworn_blade", card_stock["battleworn_blade"]], 
		[iron_blade_card, "iron_blade", card_stock["iron_blade"]], 
		[emberized_slasher_card, "emberized_slasher", card_stock["emberized_slasher"]], 
		[crimson_slasher_card, "crimson_slasher", card_stock["crimson_slasher"]], 
		[barbaric_claymore_card, "barbaric_claymore", card_stock["barbaric_claymore"]], 
		[knightly_claymore_card, "knightly_claymore", card_stock["knightly_claymore"]], 
		[draconic_edge_card, "draconic_edge", card_stock["draconic_edge"]], 
		[demonic_edge_card, "demonic_edge", card_stock["demonic_edge"]], 


		[wooden_hatchet_card, "wooden_hatchet", card_stock["wooden_hatchet"]], 
		[steel_hatchet_card, "steel_hatchet", card_stock["steel_hatchet"]], 
		[verdant_splitter_card, "verdant_splitter", card_stock["verdant_splitter"]], 
		[diamond_splitter_card, "diamond_splitter", card_stock["diamond_splitter"]], 
		[battleworn_axe_card, "battleworn_axe", card_stock["battleworn_axe"]], 
		[iron_axe_card, "iron_axe", card_stock["iron_axe"]], 
		[emberized_cleaver_card, "emberized_cleaver", card_stock["emberized_cleaver"]], 
		[crimson_cleaver_card, "crimson_cleaver", card_stock["crimson_cleaver"]], 
		[barbaric_decapitator_card, "barbaric_decapitator", card_stock["barbaric_decapitator"]], 
		[knightly_decapitator_card, "knightly_decapitator", card_stock["knightly_decapitator"]], 
		[draconic_executioner_card, "draconic_executioner", card_stock["draconic_executioner"]], 
		[demonic_executioner_card, "demonic_executioner", card_stock["demonic_executioner"]], 


		[wooden_dagger_card, "wooden_dagger", card_stock["wooden_dagger"]], 
		[steel_dagger_card, "steel_dagger", card_stock["steel_dagger"]], 
		[verdant_shard_card, "verdant_shard", card_stock["verdant_shard"]], 
		[diamond_shard_card, "diamond_shard", card_stock["diamond_shard"]], 
		[battleworn_carver_card, "battleworn_carver", card_stock["battleworn_carver"]], 
		[iron_carver_card, "iron_carver", card_stock["iron_carver"]], 
		[emberized_stiletto_card, "emberized_stiletto", card_stock["emberized_stiletto"]], 
		[crimson_stiletto_card, "crimson_stiletto", card_stock["crimson_stiletto"]], 
		[barbaric_pike_card, "barbaric_pike", card_stock["barbaric_pike"]], 
		[knightly_pike_card, "knightly_pike", card_stock["knightly_pike"]], 
		[draconic_trident_card, "draconic_trident", card_stock["draconic_trident"]], 
		[demonic_trident_card, "demonic_trident", card_stock["demonic_trident"]], 


		[wooden_whip_card, "wooden_whip", card_stock["wooden_whip"]], 
		[steel_whip_card, "steel_whip", card_stock["steel_whip"]], 
		[verdant_knout_card, "verdant_knout", card_stock["verdant_knout"]], 
		[diamond_knout_card, "diamond_knout", card_stock["diamond_knout"]], 
		[battleworn_flail_card, "battleworn_flail", card_stock["battleworn_flail"]], 
		[iron_flail_card, "iron_flail", card_stock["iron_flail"]], 
		[emberized_scourge_card, "emberized_scourge", card_stock["emberized_scourge"]], 
		[crimson_scourge_card, "crimson_scourge", card_stock["crimson_scourge"]], 
		[barbaric_chainflogger_card, "barbaric_chainflogger", card_stock["barbaric_chainflogger"]], 
		[knightly_spikes_card, "knightly_spikes", card_stock["knightly_spikes"]], 
		[draconic_disemboweler_card, "draconic_disemboweler", card_stock["draconic_disemboweler"]], 
		[demonic_torturer_card, "demonic_torturer", card_stock["demonic_torturer"]], 


		[wooden_hammer_card, "wooden_hammer", card_stock["wooden_hammer"]], 
		[steel_hammer_card, "steel_hammer", card_stock["steel_hammer"]], 
		[verdant_mallet_card, "verdant_mallet", card_stock["verdant_mallet"]], 
		[diamond_mallet_card, "diamond_mallet", card_stock["diamond_mallet"]], 
		[battleworn_mace_card, "battleworn_mace", card_stock["battleworn_mace"]], 
		[iron_mace_card, "iron_mace", card_stock["iron_mace"]], 
		[emberized_crusher_card, "emberized_crusher", card_stock["emberized_crusher"]], 
		[crimson_crusher_card, "crimson_crusher", card_stock["crimson_crusher"]], 
		[barbaric_warhammer_card, "barbaric_warhammer", card_stock["barbaric_warhammer"]], 
		[knightly_warhammer_card, "knightly_warhammer", card_stock["knightly_warhammer"]], 
		[draconic_skullbasher_card, "draconic_skullbasher", card_stock["draconic_skullbasher"]], 
		[demonic_skullbasher_card, "demonic_skullbasher", card_stock["demonic_skullbasher"]], 


		[wooden_guard_card, "wooden_guard", card_stock["wooden_guard"]], 
		[steel_guard_card, "steel_guard", card_stock["steel_guard"]], 
		[verdant_aegis_card, "verdant_aegis", card_stock["verdant_aegis"]], 
		[diamond_aegis_card, "diamond_aegis", card_stock["diamond_aegis"]], 
		[battleworn_wall_card, "battleworn_wall", card_stock["battleworn_wall"]], 
		[iron_wall_card, "iron_wall", card_stock["iron_wall"]], 
		[emberized_bulwark_card, "emberized_bulwark", card_stock["emberized_bulwark"]], 
		[crimson_bulwark_card, "crimson_bulwark", card_stock["crimson_bulwark"]], 


		[ring_of_stone_card, "ring_of_stone", card_stock["ring_of_stone"]], 
		[ring_of_noble_tears, "ring_of_noble_tears", card_stock["ring_of_noble_tears"]], 
		[ring_of_royals, "ring_of_royals", card_stock["ring_of_royals"]], 
		[ring_of_the_emperor, "ring_of_the_emperor", card_stock["ring_of_the_emperor"]], 


		[amulet_of_stone_card, "amulet_of_stone", card_stock["amulet_of_stone"]], 
		[amulet_of_noble_tears, "amulet_of_noble_tears", card_stock["amulet_of_noble_tears"]], 
		[amulet_of_royals, "amulet_of_royals", card_stock["amulet_of_royals"]], 
		[amulet_of_the_emperor, "amulet_of_the_emperor", card_stock["amulet_of_the_emperor"]], 
	]


	return all_cards

func get_equipment_by_name(item_name: String):
	for category in equipment_data.keys():
		var items = equipment_data[category]
		if items.has(item_name):
			var result: = {}
			result[item_name] = items[item_name]
			return result
	return {}

func _input(event):

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not chat_input.get_global_rect().has_point(event.position):
			chat_input.release_focus()

	if event is InputEventMouseButton and craft_active != "":
		await get_tree().create_timer(0.1).timeout
		scroll_of_luck.button_pressed = false
		scroll_of_luck.release_focus()
		scroll_of_injection.button_pressed = false
		scroll_of_injection.release_focus()

func _on_send_pressed(_submitted_text = ""):
	var msg = chat_input.text.strip_edges()
	if msg.length() == 0 or msg.length() > MAX_LENGTH:
		return

	var sender_id = get_tree().get_multiplayer().get_unique_id()
	var now = Time.get_datetime_dict_from_system()
	var timestamp = "[%02d:%02d]" % [now.hour, now.minute]
	var _name = all_gladiators[multiplayer.get_unique_id()]["name"]

	chat_input.clear()
	rpc("broadcast_message", sender_id, _name, timestamp, msg)


func _on_log_received(message):


	var formatted = "%s" % [message]

	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = formatted
	label["theme_override_constants/outline_size"] = name_and_chat_outline_thickness


	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label.scroll_active = false


	chat_log.add_child(label)

	# Remove old messages
	if chat_log.get_child_count() > MAX_MESSAGES:
		chat_log.get_child(0).queue_free()


	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value


@rpc("any_peer", "call_local")
func broadcast_message(sender_id, sender_name: String, timestamp: String, message: String):
	_add_message(sender_id, sender_name, timestamp, message)


func _add_message(sender_id, sender_name: String, timestamp: String, message: String):
	var gladiator = all_gladiators.get(sender_id)
	var color = gladiator.get("color", Color.WHITE)
	var hex_color = color

	var formatted = "%s [color=%s]%s[/color]: %s" % [timestamp, hex_color, sender_name, message]

	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label["theme_override_constants/outline_size"] = name_and_chat_outline_thickness
	label.text = formatted


	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label.scroll_active = false


	chat_log.add_child(label)





	if chat_log.get_child_count() > MAX_MESSAGES:
		chat_log.get_child(0).queue_free()


	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value

func update_equipment_ui():
	
	# here we need to update EquipmentPanelX with all peers equipment
	var all_ids = all_gladiators.keys()
	var all_item_slots = ["weapon1", "weapon2", "head", "shoulders", "chest", "belt", 
		"gloves", "boots", "legs", "amulet", "ring1", "ring2"]

	var card_scene_map: = {}
	for card in all_cards:
		card_scene_map[card[1]] = card[0] # card[1] is name, card[0] is scene



	for id in all_ids:
		var wep2_slots = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/Weapon2Slot")
		wep2_slots.visible = true

		equipment_panel_inspect = get_node("_EquipmentPanel" + str(id) + "/InspectLabel")
		equipment_panel = get_node("_EquipmentPanel" + str(id))
		equipment_panel_name = get_node("_EquipmentPanel" + str(id) + "/PanelContainer/Name")
		equipment_panel_picture = get_node("_EquipmentPanel" + str(id) + "/EquipmentPanelPicture")
		endurance_bar = get_node("_EquipmentPanel" + str(id) + "/EnduranceBar")
		if multiplayer.get_unique_id() == id:
			my_endurance_bar = endurance_bar
		equipment_panel_inspect.bbcode_enabled = true
		var _text

		var strength = all_gladiators[id]["attributes"]["strength"]
		var quickness = all_gladiators[id]["attributes"]["quickness"]
		var crit_rating = all_gladiators[id]["attributes"]["crit_rating"]
		var avoidance = all_gladiators[id]["attributes"]["avoidance"]
		var health = all_gladiators[id]["attributes"]["health"]

		var endurance = all_gladiators[id]["attributes"]["endurance"]
		var sword_mastery = all_gladiators[id]["attributes"]["sword_mastery"]
		var axe_mastery = all_gladiators[id]["attributes"]["axe_mastery"]
		var mace_mastery = all_gladiators[id]["attributes"]["mace_mastery"]
		var stabbing_mastery = all_gladiators[id]["attributes"]["stabbing_mastery"]
		var flagellation_mastery = all_gladiators[id]["attributes"]["flagellation_mastery"]
		var shield_mastery = all_gladiators[id]["attributes"]["shield_mastery"]
		var unarmed_mastery = all_gladiators[id]["attributes"]["unarmed_mastery"]





		var weight = all_gladiators[id]["weight"]
		var physique = strength + health + endurance / 2
		var agility = [quickness, crit_rating / 2, avoidance, sword_mastery / 3, axe_mastery / 3, mace_mastery / 3, 
			stabbing_mastery / 3, flagellation_mastery / 3, shield_mastery / 3, unarmed_mastery / 3].reduce( func(a, b): return a + b)

		var gladiator_physique_class
		for physique_class in physique_limits.keys():
			if physique <= physique_limits[physique_class]:
				gladiator_physique_class = physique_class
				break
			else: gladiator_physique_class = "Legendary"

		var gladiator_agility_class
		for agility_class in agility_limits.keys():
			if agility <= agility_limits[agility_class]:
				gladiator_agility_class = agility_class
				break
			else: gladiator_agility_class = "Legendary"

		var gladiator_weight_class
		for weight_class in weight_limits.keys():
			if weight <= weight_limits[weight_class]:
				gladiator_weight_class = weight_class
				break
			else: gladiator_weight_class = "Massive"

		var inspect_text = ""


		var age = all_gladiators[id]["age"]
		inspect_text += "[color=%s]%s[/color]\n" % ["d2c9a5", age]
		inspect_text += "[color=%s]Physique:[/color] [color=%s] %s [/color]\n" % ["cd8900", "d2c9a5", gladiator_physique_class]
		inspect_text += "[color=%s]Agility:[/color] [color=%s] %s [/color] \n" % ["d2b600", "d2c9a5", gladiator_agility_class]
		inspect_text += "[color=%s]Weight:[/color] [color=%s] %s [/color]" % ["847875", "d2c9a5", gladiator_weight_class]
		equipment_panel_inspect.bbcode_text = inspect_text


		var race = all_gladiators[id].get("race", "???")
		if race == "Troll":
			equipment_panel_picture.texture = troll_picture
		elif race == "Orc":
			equipment_panel_picture.texture = orc_picture
		elif race == "Human":
			equipment_panel_picture.texture = human_picture
		elif race == "Elf":
			equipment_panel_picture.texture = elf_picture


		var mainhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/MainHand")
		var offhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/OffHand")
		var vfx_mainhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/VfxMainHand")
		var vfx_offhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/VfxOffHand")
		var animation_parent = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations")



		var color = all_gladiators[id].get("color", Color.WHITE)
		var hex_color = color
		var formatted = "[color=%s]%s[/color]" % [hex_color, all_gladiators[id]["name"]]
		equipment_panel_name.bbcode_enabled = true
		equipment_panel_name.bbcode_text = formatted
		equipment_panel_name["theme_override_constants/outline_size"] = name_and_chat_outline_thickness

		equipment_panel.visible = true
		var get_spawn_point = all_gladiators[id].get("spawn_point", Vector2(0, 0))
		var side = find_spawn_side(get_spawn_point)
		
		if get_spawn_point != Vector2(0, 0):
			equipment_panel.position = all_gladiators[id]["spawn_point"]
			
		if id == multiplayer.get_unique_id():
			endurance_bar.visible = true
			if side == "left": 
				attribute_panel.position = equipment_panel.position - Vector2(180, 0)
			elif side == "right": 
				attribute_panel.position = equipment_panel.position + Vector2(302, 0)
		else:
			endurance_bar.visible = false

		if side == "left":
			animation_parent.scale.x = 1
		elif side == "right":
			animation_parent.position = equipment_panel.position - Vector2(400, 400)
			animation_parent.scale.x = -1



		var wep1_name = all_gladiators[id].get("weapon1", "???").keys()[0]
		var wep2_name = all_gladiators[id].get("weapon2", "???").keys()[0]
		var wep1_category = all_gladiators[id].get("weapon1", "???")[wep1_name]["category"]
		var wep2_category = all_gladiators[id].get("weapon2", "???")[wep2_name]["category"]
		var wep1_tier = all_gladiators[id].get("weapon1", "???")[wep1_name].get("tier", "???")
		var wep2_tier = all_gladiators[id].get("weapon2", "???")[wep2_name].get("tier", "???")
		var wep1_hands = all_gladiators[id].get("weapon1", "???")[wep1_name].get("hands", "???")


		var wep1_vfx_effect
		var wep2_vfx_effect


		if wep1_category == "unarmed":
			wep1_vfx_effect = wep1_category
		else:
			wep1_vfx_effect = wep1_category + str(wep1_tier)

		if wep2_category == "unarmed":
			wep2_vfx_effect = wep2_category
		else:
			wep2_vfx_effect = wep2_category + str(wep2_tier)

		var _slot = get_node("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/Weapon1Slot")
		var wep1_slot
		if _slot.get_child_count() > 0:
			wep1_slot = _slot.get_child(0)
			wep1_slot.modulate = "ffffff"
		else:
			wep1_slot = null

		_slot = get_node("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/Weapon2Slot")
		var wep2_slot
		if _slot.get_child_count() > 0:
			wep2_slot = _slot.get_child(0)
			wep2_slot.modulate = "ffffff"
		else:
			wep2_slot = null

		if wep1_vfx_effect.contains("?"):
			vfx_mainhand.texture = null
		elif wep_statuses[id][0] == 1:
			wep1_slot.modulate = "#d2004f"
			vfx_mainhand.texture = vfx_pngs["unarmed"]
		else:
			if vfx_pngs.has(wep1_vfx_effect):
				vfx_mainhand.texture = vfx_pngs[wep1_vfx_effect]
			else:
				vfx_mainhand.texture = null

		if wep1_hands == 2 and wep_statuses[id][1] == 1:
			if wep1_slot != null: wep1_slot.modulate = "#d2004f"

			vfx_mainhand.texture = vfx_pngs["unarmed"]
			vfx_offhand.texture = vfx_pngs["unarmed"]
		else:
			if wep2_vfx_effect.contains("?"):
				vfx_offhand.texture = null
			elif wep_statuses[id][1] == 1:
				if wep2_slot != null: wep2_slot.modulate = "#d2004f"

				vfx_offhand.texture = vfx_pngs["unarmed"]
			else:
				if vfx_pngs.has(wep2_vfx_effect):
					vfx_offhand.texture = vfx_pngs[wep2_vfx_effect]
				else:
					vfx_offhand.texture = null


		if wep1_name == "unarmed" or wep_statuses[id][0] == 1:
			mainhand.texture = null
		else:
			if wep_pngs.has(wep1_name):
				mainhand.texture = wep_pngs[wep1_name]
			else:
				mainhand.texture = null

		if wep2_name == "unarmed" or wep_statuses[id][1] == 1:
			offhand.texture = null
		else:
			if wep_pngs.has(wep2_name):
				offhand.texture = wep_pngs[wep2_name]
			else:
				offhand.texture = null


		for slot in all_item_slots:
			var item_slot
			var item_dict = all_gladiators[id][slot]
			if item_dict == {}:
				var slot_ = slot.capitalize().strip_edges().replace(" ", "") + "Slot"

				var node = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerRight/RightPanel/" + slot_)
				if node == null:
					node = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerLeft/LeftPanel/" + slot_)
				if node == null:
					node = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/" + slot_)

				item_slot = node.get_children()
				for i in item_slot:
					i.queue_free()
				continue

			var item_name = item_dict.keys()[0]
			if item_name == "unarmed":
				var slot_ = slot.capitalize().strip_edges().replace(" ", "") + "Slot"

				var node = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerRight/RightPanel/" + slot_)
				if node == null:
					node = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerLeft/LeftPanel/" + slot_)
				if node == null:
					node = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/" + slot_)

				item_slot = node.get_children()
				for i in item_slot:
					i.queue_free()
				continue

			var hands = item_dict[item_name].get("hands", -1)

			if hands == 2:
				offhand.texture = null
			if hands == 2 and wep_statuses[id][1] == 1:
				mainhand.texture = null
				offhand.texture = null


			if card_scene_map.has(item_name):
				var card_instance = card_scene_map[item_name].instantiate()

				item_slot = find_item_slot(slot, hands, id)

				var slot_available = 0
				if item_slot == null: return
				if item_slot.get_children() == []:
					slot_available = 1

				if slot_available == 1:
					card_instance.button_parent.connect(_on_equipment_pressed)
					card_instance.pressed.connect(_on_equipment_item_pressed.bind(item_name, slot))
					card_instance.set_multiplayer_authority(multiplayer.get_unique_id())

					card_instance.setup(item_dict)

					item_slot.add_child(card_instance)
					card_instance["focus_mode"] = 0
					card_instance.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
					card_instance.custom_minimum_size = item_slot.size
					card_instance["theme_override_colors/font_disabled_color"] = Color(1, 1, 1, 1)
					card_instance["theme_override_colors/icon_disabled_color"] = Color(1, 1, 1, 1)

					if multiplayer.get_unique_id() != id:
						card_instance.disabled = true
						card_instance.add_theme_stylebox_override("disabled", card_instance.get_theme_stylebox("normal"))

				else:
					continue

func _on_add_item_to_inventory(id, item_dict, slot_name):
	if id != multiplayer.get_unique_id():
		return

	var card_scene_map: = {}
	for card in all_cards:
		card_scene_map[card[1]] = card[0]

	var item_name = item_dict.keys()[0]


	if card_scene_map.has(item_name):
		var card_instance = card_scene_map[item_name].instantiate()
		card_instance.button_down.connect(_on_inventory_item_pressed.bind(item_name, slot_name))
		card_instance.set_multiplayer_authority(multiplayer.get_unique_id())
		card_instance["focus_mode"] = 0
		$Inventory/InventoryGridContainer.find_child(slot_name, true, false).add_child(card_instance)
	else:
		print("⚠️ No matching scene for item:", item_name)


func _on_remove_item_from_equipment(id, item_dict, category):
	if multiplayer.get_unique_id() != id: return
	var item_slot

	var item_name = item_dict.keys()[0]
	var hands = item_dict[item_name].get("hands", -1)

	item_slot = find_item_slot(category, hands, id)
	if hands == 2:
		var wep2slot = get_node("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/Weapon2Slot")
		wep2slot.visible = true

	item_slot.get_child(0).queue_free()
	update_equipment_ui()

func find_item_slot(category, hands, id):
	var item_slot
	var wep2slot = get_node("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/Weapon2Slot")

	if hands == 2:
		item_slot = get_node("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/Weapon1Slot")


		wep2slot.visible = false

	elif hands == 1 and category in ["weapon1", "weapon2"]:
		item_slot = get_node("_EquipmentPanel" + str(id) + "/PanelContainerBottom/BottomPanel/Weapon" + category[-1] + "Slot")

	elif category in ["ring1", "ring2"]:
		item_slot = get_node("_EquipmentPanel" + str(id) + "/PanelContainerRight/RightPanel/Ring" + category[-1] + "Slot")

	else:

		item_slot = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerRight/RightPanel").find_child(category.capitalize() + "Slot", true, false)

		if item_slot == null:
			item_slot = get_node_or_null("_EquipmentPanel" + str(id) + "/PanelContainerLeft/LeftPanel").find_child(category.capitalize() + "Slot", true, false)

	return item_slot
		

func _on_refresh_inventory_ui(id, inventory_dict):
	if multiplayer.get_unique_id() != id:
		return

	var grid = $Inventory/InventoryGridContainer

	# Clear all UI slots
	for slot in grid.get_children():
		for child in slot.get_children():
			child.queue_free()

	# Rebuild UI from authoritative inventory
	for slot_name in inventory_dict.keys():
		var slot_node = grid.find_child(slot_name, true, false)

		if inventory_dict[slot_name].is_empty():
			continue

		var item_name = inventory_dict[slot_name].keys()[0]
		var item_data = inventory_dict[slot_name][item_name]

		_on_add_item_to_inventory(id, inventory_dict[slot_name], slot_name)
		#var icon = preload("res://path/to/item_icons/%s.png" % item_name).instantiate()
		#slot_node.add_child(icon)
		

func _on_remove_item_from_inventory(id, _item_dict, slot_name):
	if multiplayer.get_unique_id() != id: return
	$Inventory/InventoryGridContainer.find_child(slot_name, true, false).get_child(0).queue_free()

func _on_send_gladiator_data_to_peer_signal(peer_id: int, _all_gladiators):
	print("update gladiator dict")
	all_gladiators = _all_gladiators
	#print(all_gladiators)
	if rename_panels_done == 0:
		rename_equipment_panels(all_gladiators)
		for id in all_gladiators.keys():
			wep_statuses[id] = [0, 0]
			prev_life_dict[id] = 999999
			life_dict[id] = 999999
		rename_panels_done = 1
	update_equipment_ui()
	fix_icon_bonuses()
	if peer_id == multiplayer.get_unique_id():
		player_gladiator_data = all_gladiators[peer_id]
		update_craft_ui()
		update_attribute_ui()
		update_concede_ui()
		update_stance_ui()
		update_attack_ui()
		update_gold(all_gladiators[peer_id]["gold"])
		update_experience(all_gladiators[peer_id]["exp"])
		update_gladiator_stats(peer_id)
		label_gold.get_income_details(all_gladiators[peer_id].get("income_last_round", {}))
	populate_hud()

func update_craft_ui():
	var crafting_mats = all_gladiators[multiplayer.get_unique_id()].get("crafting_mats", {})

	if crafting_mats["scroll_of_luck"] == 0:
		scroll_of_luck.get_child(0).text = ""
		scroll_of_luck.disabled = true
	else:
		scroll_of_luck.get_child(0).text = str(crafting_mats["scroll_of_luck"])
		scroll_of_luck.disabled = false

	if crafting_mats["scroll_of_injection"] == 0:
		scroll_of_injection.get_child(0).text = ""
		scroll_of_injection.disabled = true
	else:
		scroll_of_injection.get_child(0).text = str(crafting_mats["scroll_of_injection"])
		scroll_of_injection.disabled = false

func update_stance_ui():
	var previous_index = stance_menu.get_selected_id()
	var options = ["Normal", 
		"Defensive", 
		"Offensive", 
		"Jester"]
	stance_menu.clear()
	for option in options: stance_menu.add_item(option)
	if previous_index == -1: stance_menu.select(0)
	else: stance_menu.select(previous_index)

func update_attack_ui():
	var previous_index = attack_menu.get_selected_id()
	var options = ["Normal", 
		"Light", 
		"Heavy"]
	attack_menu.clear()
	for option in options: attack_menu.add_item(option)
	if previous_index == -1: attack_menu.select(0)
	else: attack_menu.select(previous_index)

func update_concede_ui():
	var previous_index = concede_threshold_menu.get_selected_id()

	var attributes = all_gladiators[multiplayer.get_unique_id()].get("attributes", {})
	var options = ["50% (" + str(int(round(0.5 * attributes["health"]))) + " hp)", 
		"40% (" + str(int(round(0.4 * attributes["health"]))) + " hp)", 
		"30% (" + str(int(round(0.3 * attributes["health"]))) + " hp)", 
		"20% (" + str(int(round(0.2 * attributes["health"]))) + " hp)", 
		"10% (" + str(int(round(0.1 * attributes["health"]))) + " hp)", 
		"0% (" + str(int(round(0.0 * attributes["health"]))) + " hp)"]

	concede_threshold_menu.clear()
	for option in options: concede_threshold_menu.add_item(option)
	if previous_index == -1: concede_threshold_menu.select(0)
	else: concede_threshold_menu.select(previous_index)

func update_attribute_ui():
	var attributes = all_gladiators[multiplayer.get_unique_id()].get("attributes", {})
	health_panel.text = str(int(attributes["health"]))
	strength_panel.text = str(int(attributes["strength"]))
	endurance_panel.text = str(int(attributes["endurance"]))
	criticality_panel.text = str(int(attributes["crit_rating"]))
	avoidance_panel.text = str(int(attributes["avoidance"]))
	quickness_panel.text = str(int(attributes["quickness"]))
	resilience_panel.text = str(int(attributes["resilience"]))
	sword_mastery_panel.text = str(int(attributes["sword_mastery"]))
	axe_mastery_panel.text = str(int(attributes["axe_mastery"]))
	stabbing_mastery_panel.text = str(int(attributes["stabbing_mastery"]))
	mace_mastery_panel.text = str(int(attributes["mace_mastery"]))
	flagellation_mastery_panel.text = str(int(attributes["flagellation_mastery"]))
	shield_mastery_panel.text = str(int(attributes["shield_mastery"]))
	unarmed_mastery_panel.text = str(int(attributes["unarmed_mastery"]))
	
	points_left = all_gladiators[multiplayer.get_unique_id()]["points"]
	points_left_label.text = "Points: " + str(points_left)
	
	regret_points_left = all_gladiators[multiplayer.get_unique_id()]["regret_points"]
	
	#print("points left: " + str(points_left))
	
	'''
	health_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	strength_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	endurance_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	criticality_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	avoidance_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	quickness_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	resilience_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	axe_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	sword_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	stabbing_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	flagellation_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	mace_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	shield_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	'''
	
	#print(regret_points_left)
	regret_points_label.text = "Regret: " + str(regret_points_left)
	attribute_panel.visible = true

	if regret_points_left > 0:
		regret_points_label.visible = true
	else:
		regret_points_label.visible = false

	if points_left > 0:
		points_info.visible = true
		points_left_label.visible = true
		for icon in attribute_icons:
			icon.disabled = false
	else:
		points_info.visible = false
		points_left_label.visible = false
		for icon in attribute_icons:
			icon.disabled = true


















func _on_equipment_pressed(parent_name: String):
	equipment_button_parent_name = parent_name



func update_inventory_ui(glad_id: int):
	var gladiator_inventory = all_gladiators[glad_id]["inventory"]


	for child in inventory_grid.get_children():
		child.queue_free()


	var card_scene_map: = {}
	for card in all_cards:
		card_scene_map[card[1]] = card[0]

	for slot_name in gladiator_inventory.keys():
		var slot_data = gladiator_inventory[slot_name]

		if typeof(slot_data) == TYPE_DICTIONARY and slot_data.size() > 0:
			var item_name = slot_data.keys()[0]


			if card_scene_map.has(item_name):
				var card_instance = card_scene_map[item_name].instantiate()
				card_instance.pressed.connect(_on_inventory_item_pressed.bind(item_name, slot_name))
				card_instance.set_multiplayer_authority(multiplayer.get_unique_id())
				card_instance["focus_mode"] = 0
				inventory_grid.add_child(card_instance)
			else:
				print("⚠️ No matching scene for item:", item_name)

func _on_attack_type_selected(index: int):
	var selected_text = attack_menu.get_item_text(index)
	var type = ""

	if selected_text == "Normal": type = "normal"
	elif selected_text == "Light": type = "light"
	elif selected_text == "Heavy": type = "heavy"

	if multiplayer.is_server():
		GameState_.peer_attack_type(multiplayer.get_unique_id(), type)
	else:
		GameState_.rpc_id(1, "peer_attack_type", multiplayer.get_unique_id(), type)


func _on_stance_selected(index: int):
	var selected_text = stance_menu.get_item_text(index)
	var stance = ""

	if selected_text == "Normal": stance = "normal"
	elif selected_text == "Defensive": stance = "defensive"
	elif selected_text == "Offensive": stance = "offensive"
	elif selected_text == "Jester": stance = "jester"

	if multiplayer.is_server():
		GameState_.peer_stance(multiplayer.get_unique_id(), stance)
	else:
		GameState_.rpc_id(1, "peer_stance", multiplayer.get_unique_id(), stance)

func _on_threshold_selected(index: int):
	var selected_text = concede_threshold_menu.get_item_text(index)
	var regex = RegEx.new()
	regex.compile("^\\d+")
	var result = regex.search(selected_text)
	var threshold = result.get_string() if result != null else "0"
	threshold = float(threshold) / 100

	if multiplayer.is_server():
		GameState_.peer_concede(multiplayer.get_unique_id(), threshold)
	else:
		GameState_.rpc_id(1, "peer_concede", multiplayer.get_unique_id(), threshold)

	emit_signal("concede_threshold_changed", threshold)



func _on_equipment_popup_pressed(id: int):
	match id:
		0:
			if !intermission:
				if multiplayer.is_server():
					GameState_.add_to_peer_log(multiplayer.get_unique_id(), "[INFO] ❌Cannot unequip item during duel!")
				else:
					GameState_.rpc_id(1, "add_to_peer_log", multiplayer.get_unique_id(), "[INFO] ❌Cannot unequip item during duel!")


				return

			if multiplayer.is_server():
				GameState_.unequip_item(multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)
			else:
				GameState_.rpc_id(1, "unequip_item", multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)


			await get_tree().create_timer(0.2).timeout

		1:
			if !intermission:
				if multiplayer.is_server():
					GameState_.add_to_peer_log(multiplayer.get_unique_id(), "[INFO] ❌Cannot sell equipped item during duel!")
				else:
					GameState_.rpc_id(1, "add_to_peer_log", multiplayer.get_unique_id(), "[INFO] ❌Cannot sell equipped item during duel!")
				return


			if multiplayer.is_server():
				GameState_.sell_from_equipment(multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)
			else:
				GameState_.rpc_id(1, "sell_from_equipment", multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)

func _on_inventory_popup_pressed(id: int):
	match id:
		0:


			if !intermission:
				if multiplayer.is_server():
					GameState_.add_to_peer_log(multiplayer.get_unique_id(), "[INFO] ❌Cannot equip item during duel!")
				else:
					GameState_.rpc_id(1, "add_to_peer_log", multiplayer.get_unique_id(), "[INFO] ❌Cannot equip item during duel!")
				return

			if multiplayer.is_server():
				GameState_.equip_item(multiplayer.get_unique_id(), selected_item_name, selected_slot)
			else:
				GameState_.rpc_id(1, "equip_item", multiplayer.get_unique_id(), selected_item_name, selected_slot)

			await get_tree().create_timer(0.2).timeout

		1:

			if multiplayer.is_server():
				GameState_.sell_from_inventory(multiplayer.get_unique_id(), selected_item_name, selected_slot)
			else:
				GameState_.rpc_id(1, "sell_from_inventory", multiplayer.get_unique_id(), selected_item_name, selected_slot)


func _on_craft_bench_popup_pressed(id: int):
	match id:
		0: pass



func _on_equipment_item_pressed(item_name: String, category):

	selected_slot = category
	selected_item_name = item_name


	equipment_popup.set_position(get_viewport().get_mouse_position())
	equipment_popup.popup()

func _on_inventory_item_pressed(item_name: String, slot_name: String):

	selected_item_name = item_name
	selected_slot = slot_name









	if craft_active:


		if multiplayer.is_server():
			GameState_.use_craft_mat_on_item(multiplayer.get_unique_id(), craft_active, selected_item_name, selected_slot)
		else:
			GameState_.rpc_id(1, "use_craft_mat_on_item", multiplayer.get_unique_id(), craft_active, selected_item_name, selected_slot)

		scroll_of_luck.button_pressed = false
		scroll_of_injection.button_pressed = false
		craft_active = ""
	else:
		inventory_popup.set_position(get_viewport().get_mouse_position())
		inventory_popup.popup()


func clear_shop_grid():
	var tweens = []

	for child in shop_grid.get_children():
		for c in child.get_children():
			# Skip cards that are already faded out (invisible)
			if c.modulate.a <= 0.05:
				c.queue_free()
				continue

			var tween: = get_tree().create_tween()
			tween.tween_property(c, "modulate:a", 0.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			if c:
				var node_ref: = c
				tween.tween_callback( func(): if node_ref: node_ref.queue_free())

			tweens.append(tween)

	if tweens.size() > 0:
		await tweens[-1].finished

func roll_cards():
	shop_grid.modulate.a = 1
	all_cards = get_all_cards()
	var weighted_random_cards = weighted_random_selection(all_cards, 5)
	var i = 0
	var shop_grid_children = shop_grid.get_children()
	
	for card in weighted_random_cards:
		var card_instance = card.instantiate()
		card_instance.set_multiplayer_authority(multiplayer.get_unique_id())
		card_instance.modulate.a = 0
		card_instance["focus_mode"] = 0
		shop_grid_children[i].add_child(card_instance)
		#print("spawned card in shop")

		var tween: = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(card_instance, "modulate:a", 1.0, 0.4)
		tween.tween_property(card_instance, "scale", Vector2.ONE, 0.1)

		await get_tree().create_timer(0.05).timeout
		i += 1
		
	

func _on_reroll_cards_new_round_signal(active_players: Array):
	if is_rerolling:
		print("blocked dual rerolls")
		return
	if is_shop_locked:
		print("skipping reroll due to locked shop")
		return

	await get_tree().process_frame
	for player in active_players:
		
		if multiplayer.get_unique_id() == player:
			refresh_button.disabled = true
			reroll_cards()
			#await get_tree().create_timer(1).timeout
			refresh_button.disabled = false


func reroll_cards():
	if is_rerolling:
		print("blocked dual rerolls")
		return

	is_rerolling = true
	refresh_button.disabled = true

	await clear_shop_grid()
	await roll_cards()

	refresh_button.disabled = false
	is_rerolling = false

func weighted_random_selection(_all_cards: Array, count: int = 5):
	var selected: = []
	var pool: = []


	# Step 1: Build a pool based on weights
	for pair in _all_cards:
		var item = pair[0]
		var item_name = pair[1]
		var stock = int(pair[2])

		var item_dict = get_equipment_by_name(item_name)


		if item_dict != {}:
			# Only add cards that are below player level + 1
			if item_dict[item_name]["level"] > int(all_gladiators[multiplayer.get_unique_id()]["level"]) + 1:
				continue

		for i in stock:
			pool.append(item) # Add item 'stock' times

	# Step 2: Randomly pick items from the pool
	for i in count:
		if pool.is_empty():
			break
		var index: = randi() % pool.size()
		selected.append(pool[index])

	return selected



func _on_refresh_button_pressed():

	if refresh_button.disabled:
		return

	if is_refreshing:
		return

	if gold < 2:
		return

	if multiplayer.is_server():
		GameState_.buy_reroll(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "buy_reroll", multiplayer.get_unique_id())

	refresh_button.pivot_offset = refresh_button.size / 2
	TweenFX.spin(refresh_button, 0.5)
	is_refreshing = true
	refresh_button.disabled = true
	await reroll_cards()
	await get_tree().create_timer(0.8).timeout
	refresh_button.disabled = false
	is_refreshing = false


func _on_equipment_button_pressed():
	equipment_pressed = !equipment_pressed
	if equipment_pressed: pass


	else: pass



func _on_shop_button_pressed():
	shop_pressed = !shop_pressed
	if shop_pressed:
		shop_grid.visible = true
		refresh_button.visible = true
		label_buy_roll.visible = true
		lock_button.visible = true
	else:
		shop_grid.visible = false
		refresh_button.visible = false
		label_buy_roll.visible = false
		lock_button.visible = false



func _on_card_stock_initialized(new_attr_cards_stock: Dictionary):
	card_stock = new_attr_cards_stock


func _on_card_stock_changed(new_all_cards_stock: Dictionary):
	card_stock = new_all_cards_stock


func _on_countdown_updated(time_left: int):
	if time_left > 0: intermission = true
	if intermission:
		label_round.bbcode_text = "[color=%s]Day  %s\n - [/color]" % ["d2c9a5", str(round_now)]
		if reroll_start_of_intermission:
			round_now += 1
			reroll_start_of_intermission = 0

		if countdown_label:
			countdown_label.text = "%d" % time_left
			if time_left <= 3:
				countdown_label.pivot_offset = countdown_label.size / 2
				countdown_label.scale = Vector2(1, 1)
				countdown_label.modulate = "ffffff"
				TweenFX.pulsate(countdown_label, 0.5)
				TweenFX.spotlight(countdown_label, 0.5)
			

		
		if time_left == 0:
			reroll_start_of_intermission = 1
			#intermission = false
			time_passed = 0
			countdown_label.text = ""
			#await get_tree().create_timer(1.0).timeout
			



func get_visual_slot(peer_id: int) -> int:
	var peer_ids = GameState_.all_gladiators.keys()
	peer_ids.sort()

	var index = peer_ids.find(peer_id)
	if index == -1:
		return 1
	return index + 1 # HUD containers are named Player1–8

func _on_life_changed(peer_id: int, new_life: int):
	var container_name = "Player%d" % get_visual_slot(peer_id)
	var container = $VBoxContainer.get_node_or_null(container_name)
	if container == null:
		return
	container.modulate = "ffffff"

	life_label = container.get_node("TextureRect/PlayerLife")
	life_label.text = "❤️ %d" % new_life

func populate_hud():
	var peer_ids = all_gladiators.keys()
	peer_ids.sort()
	for i in range(min(peer_ids.size(), 8)):
		var peer_id = peer_ids[i]

		var gladiator_data = all_gladiators[peer_id]
		var container_name = "Player%d/TextureRect" % (i + 1)
		var player = "Player%d" % (i + 1)

		var player_container = $VBoxContainer.get_node_or_null(container_name)
		if player_container == null:
			push_warning("Missing container: %s" % container_name)
			continue
		$VBoxContainer.get_node_or_null(player).modulate = "ffffff"

		name_label = player_container.get_node("PlayerInfo/PlayerName")
		race_label = player_container.get_node("PlayerInfo/PlayerRace")
		life_label = player_container.get_node("PlayerLife")
		var color = gladiator_data.get("color", Color.WHITE)
		var _name = gladiator_data.get("name", "Unknown")

		name_label.bbcode_enabled = true
		name_label.bbcode_text = "[color=%s]%s[/color]" % [color, _name]

		race_label.text = str(gladiator_data.get("race", "???")) + "       Lvl " + all_gladiators[peer_id]["level"]

		prev_life_dict[peer_id] = life_dict[peer_id]
		life_dict[peer_id] = int(gladiator_data.get("player_life", 0))

		var texture_rect = $VBoxContainer.get_node_or_null(player + "/TextureRect")
		texture_rect.scale = Vector2(1, 1)
		texture_rect.modulate = "ffffff"
		texture_rect.pivot_offset = texture_rect.size / 2
		if life_dict[peer_id] < prev_life_dict[peer_id]:
			TweenFX.critical_hit(texture_rect)
			TweenFX.shake(texture_rect, 0.6, 3)
			
		var life = int(gladiator_data.get("player_life", 0))
		life_label.text = "❤️ %d" % life




func update_gold(amount: int):
	prev_gold = gold
	gold = amount

	if prev_gold == gold: return

	label_gold.bbcode_text = "[color=%s]$ %s[/color]" % ["d2b600", str(amount)]
	label_gold.pivot_offset = label_gold.size / 2
	label_gold.scale = Vector2(1, 1)
	label_gold.modulate = "ffffff"
	label_gold.position = label_gold_position

	if prev_gold > gold:
		TweenFX.punch_out(label_gold, 0.2, 0.95)
		TweenFX.spotlight(label_gold, 0.2, Color("#d2004f"))
	if prev_gold < gold:
		TweenFX.hop(label_gold)
		TweenFX.spotlight(label_gold, 0.3)


	label_buy_roll.bbcode_enabled = true
	label_buy_exp.bbcode_enabled = true
	if gold < 2:
		label_buy_roll.bbcode_text = "[color=%s]$ 2[/color]" % ["79444a"]
	else:
		label_buy_roll.bbcode_text = "[color=%s]$ 2[/color]" % ["d2b600"]

	if gold < 5:
		label_buy_exp.bbcode_text = "[color=%s]$ 5[/color]" % ["79444a"]
	else:
		label_buy_exp.bbcode_text = "[color=%s]$ 5[/color]" % ["d2b600"]

func update_experience(amount: int):
	var _lvl = all_gladiators[multiplayer.get_unique_id()]["level"]

	if _lvl == max_lvl:
		label_xp.bbcode_text = "[color=%s]Lv. %s[/color]" % ["d2c9a5", _lvl]
		label_buy_exp.visible = false
		exp_button.visible = false
	else:
		var exp_to_lvl_up = str(exp_for_level[str(int(all_gladiators[multiplayer.get_unique_id()]["level"]) + 1)])
		label_xp.bbcode_text = "[color=%s]Lv. %s  %s/%s[/color]" % ["d2c9a5", _lvl, str(amount), exp_to_lvl_up]


func _on_exp_button_button_up():
	var _lvl = all_gladiators[multiplayer.get_unique_id()]["level"]
	if _lvl == max_lvl: 
		return
		
	var amount = 4
	var cost = 5
	exp_button.pivot_offset = exp_button.size / 2
	exp_button.scale = Vector2(1, 1)
	exp_button.modulate = "ffffff"
	if gold > cost:
		TweenFX.spotlight(exp_button, 0.3)
	if multiplayer.is_server():
		GameState_.grant_exp_for_peer(multiplayer.get_unique_id(), amount, cost)
	else:
		GameState_.rpc_id(1, "grant_exp_for_peer", multiplayer.get_unique_id(), amount, cost)

func format_name(raw_name: String) -> String:
	var parts = raw_name.split("_")
	var joined = ""
	for i in parts.size():
		joined += parts[i]
		if i < parts.size() - 1:
			joined += " "
	return joined.capitalize()


func _on_resume_pressed() -> void :
	esc_menu.visible = false

func _on_options_pressed() -> void :
	print("Options not implemented yet.")

func _on_disconnect_pressed() -> void :
	resume_button.visible = false
	options_button.visible = false
	disconnect_button.visible = false
	confirm_disconnect.visible = true

func _on_yes_button_up() -> void :
	if !multiplayer.is_server():
		var gladiator = all_gladiators.get(multiplayer.get_unique_id(), {})
		if gladiator == {}:
			var color = gladiator.get("color", Color.WHITE)
			var hex_color = color
			var formatted = "[color=%s]%s[/color][color=%s] disconnected![/color]" % [hex_color, GameState_.selected_name, Color.RED.to_html()]
			rpc("broadcast_message", multiplayer.get_unique_id(), formatted)

		await get_tree().create_timer(1.0).timeout

		NetworkManager_.leave_game()
		multiplayer.multiplayer_peer.close()
		get_tree().set_multiplayer(null)
		get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
	else:
		var gladiator = all_gladiators.get(multiplayer.get_unique_id(), {})
		if gladiator == {}:
			var color = gladiator.get("color", Color.WHITE)
			var hex_color = color
			var formatted = "[color=%s]%s[/color][color=%s] (host) disconnected![/color]" % [hex_color, GameState_.selected_name, Color.RED.to_html()]
			rpc("broadcast_message", multiplayer.get_unique_id(), formatted)
			await get_tree().create_timer(1.0).timeout

		GameState_.erase_all_data()

		NetworkManager_.leave_game()
		multiplayer.multiplayer_peer.close()
		get_tree().set_multiplayer(null)
		get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

func _on_no_button_up() -> void :
	resume_button.visible = true
	options_button.visible = true
	disconnect_button.visible = true
	confirm_disconnect.visible = false

func enable_craft_with_material(crafting_mat, toggled_on):

	if toggled_on:

		craft_active = crafting_mat
	else:

		craft_active = ""



func _on_scroll_of_luck_toggled(toggled_on: bool):
	enable_craft_with_material("scroll_of_luck", toggled_on)



func _on_scroll_of_injection_toggled(toggled_on: bool) -> void :
	enable_craft_with_material("scroll_of_injection", toggled_on)


func pretty_print_dict(data: Dictionary, indent: int = 0) -> String:
	var out: = ""
	var pad: = "    ".repeat(indent)

	for key in data.keys():
		var value = data[key]

		if typeof(value) == TYPE_DICTIONARY:
			out += "%s%s:\n" % [pad, str(key)]
			out += pretty_print_dict(value, indent + 1)

		elif typeof(value) == TYPE_ARRAY:
			out += "%s%s: [\n" % [pad, str(key)]
			for item in value:
				if typeof(item) in [TYPE_DICTIONARY, TYPE_ARRAY]:
					out += pretty_print_dict(item, indent + 1)
				else:
					out += "%s    %s,\n" % [pad, str(item)]
			out += "%s]\n" % pad

		else:
			out += "%s%s: %s\n" % [pad, str(key), str(value)]


	return out


func rename_equipment_panels(_all_gladiators: Dictionary) -> void :
	var ids: = _all_gladiators.keys()
	ids.sort()

	var count: = ids.size()
	var max_panels: = 8

	# Loop only through the number of gladiators
	for i in range(min(count, max_panels)):
		var old_name: = "EquipmentPanel" + str(i + 1)
		if has_node(old_name):
			var panel: = get_node(old_name)
			panel.name = "_EquipmentPanel" + str(ids[i])
		else:
			push_warning("Node '%s' not found in scene" % old_name)

#func _gui_input(event: InputEvent) -> void:
	# Check if the event is a mouse button click

func get_amount(left_click, right_click):
	var amount
	
	if left_click == true: 
		if points_left <= 0: amount = 0
		elif Input.is_key_pressed(KEY_SHIFT) and points_left >= 5: amount = 5
		elif Input.is_key_pressed(KEY_CTRL) and points_left >= 10: amount = 10
		else: amount = 1
		
	if right_click == true:
		if Input.is_key_pressed(KEY_SHIFT) and regret_points_left >= 5: amount = -5
		elif Input.is_key_pressed(KEY_CTRL) and regret_points_left >= 10: amount = -10
		else: amount = -1

	return amount

func grant_points_for_peer(_id, amount):
	if multiplayer.is_server():
		GameState_.request_points(multiplayer.get_unique_id(), amount)
	else:
		GameState_.rpc_id(1, "request_points", multiplayer.get_unique_id(), amount)

func _on_health_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
			
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
		
		#health_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var current_timestamp = Time.get_unix_time_from_system()
		var current_timestamp_in_milliseconds = current_timestamp*1000
		print(str(current_timestamp_in_milliseconds) + ": on_health_icon_gui_input " + str(multiplayer.get_unique_id()))
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "health", 0, false)
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "health", 0, false)
			
		update_attribute_ui()


func _on_strength_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#strength_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "strength", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "strength", 0, false)
			
			
		update_attribute_ui()


func _on_endurance_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#endurance_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "endurance", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "endurance", 0, false)
			
			
		update_attribute_ui()


func _on_criticality_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#criticality_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "crit_rating", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "crit_rating", 0, false)
			
			
		update_attribute_ui()


func _on_avoidance_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
		
		#avoidance_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "avoidance", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "avoidance", 0, false)
			
			
		update_attribute_ui()


func _on_quickness_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#quickness_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "quickness", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "quickness", 0, false)
			
			
		update_attribute_ui()


func _on_resilience_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#resilience_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "resilience", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "resilience", 0, false)
			
			
		update_attribute_ui()


func _on_sword_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#sword_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "sword_mastery", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "sword_mastery", 0, false)
			
			
		update_attribute_ui()


func _on_axe_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#axe_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "axe_mastery", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "axe_mastery", 0, false)
			
			
		update_attribute_ui()


func _on_stabbing_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#stabbing_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "stabbing_mastery", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "stabbing_mastery", 0, false)
			
			
		update_attribute_ui()


func _on_mace_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#mace_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "mace_mastery", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "mace_mastery", 0, false)
			
			
		update_attribute_ui()


func _on_flagellation_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
		
		#flagellation_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "flagellation_mastery", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "flagellation_mastery", 0, false)
			
			
		update_attribute_ui()


func _on_shield_icon_gui_input(event: InputEvent) -> void:
	var left_click = false
	var right_click = false
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click = true
				right_click = false
			MOUSE_BUTTON_RIGHT:
				left_click = false
				right_click = true
				
		var amount = get_amount(left_click, right_click)
		if right_click and (abs(regret_points_left) < abs(amount)):
			return
			
		#shield_mastery_icon_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if multiplayer.is_server():
			GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "shield_mastery", 0, false)
			
			
		else:
			GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "shield_mastery", 0, false)
			
			
		update_attribute_ui()







'
func _on_strength_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "strength", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "strength", false)
		points_left -= amount
	update_attribute_ui()

func _on_endurance_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "endurance", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "endurance", false)
		points_left -= amount
	update_attribute_ui()

func _on_criticality_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "crit_rating", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "crit_rating", false)
		points_left -= amount
	update_attribute_ui()

func _on_avoidance_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "avoidance", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "avoidance", false)
		points_left -= amount
	update_attribute_ui()

func _on_quickness_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "quickness", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "quickness", false)
		points_left -= amount
	update_attribute_ui()

func _on_resilience_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "resilience", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "resilience", false)
		points_left -= amount
	update_attribute_ui()

func _on_sword_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "sword_mastery", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "sword_mastery", false)
		points_left -= amount
	update_attribute_ui()

func _on_axe_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "axe_mastery", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "axe_mastery", false)
		points_left -= amount
	update_attribute_ui()

func _on_stabbing_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "stabbing_mastery", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "stabbing_mastery", false)
		points_left -= amount
	update_attribute_ui()

func _on_mace_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "mace_mastery", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "mace_mastery", false)
		points_left -= amount
	update_attribute_ui()

func _on_flagellation_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "flagellation_mastery", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "flagellation_mastery", false)
		points_left -= amount
	update_attribute_ui()

func _on_shield_icon_button_up() -> void :
	var amount = get_amount(left_click, right_click)
	if multiplayer.is_server():
		GameState_.buy_attribute_card(multiplayer.get_unique_id(), amount, "shield_mastery", 0, false)
		points_left -= amount
	else:
		GameState_.rpc_id(1, "buy_attribute_card", multiplayer.get_unique_id(), amount, "shield_mastery", false)
		points_left -= amount
	update_attribute_ui()
'

func play_animation(id, animation, _weapon, hand):
	var _hand
	var tier = _weapon.get("tier", -1)

	if hand == "mainhand":
		_hand = "MainHand"
	elif hand == "offhand":
		_hand = "OffHand"

	var animation_player = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/" + _hand + "AnimationPlayer")

	var vfx = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/Vfx" + _hand)
	vfx.modulate = "ffffff"



	if animation_player.has_animation(animation):
		if tier == 1:
			vfx.modulate = "ffffffb2"
		elif tier == 2:
			vfx.modulate = "ffffffcc"
		elif tier == 3:
			vfx.modulate = "ffffffe6"
		elif tier == 4:
			vfx.modulate = "ffffff"

		animation_player.stop()
		animation_player.play(animation)

func wep_broken(id, _wep1_broken, _wep2_broken):
	wep_statuses[id] = [_wep1_broken, _wep2_broken]
	update_equipment_ui()




func find_spawn_side(target):
	for side in GameState_.spawn_points.keys():
		for point in GameState_.spawn_points[side]:
			if point == target:
				return side
	return "unknown"

func parry_animation(id, hand):
	var mainhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/MainHand")
	var offhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/OffHand")
	mainhand["modulate"] = "ffffff"
	offhand["modulate"] = "ffffff"

	if hand == "MainHand":
		TweenFX.spotlight(mainhand, 0.3)
		TweenFX.blink(mainhand, 0.1, 1)
	elif hand == "OffHand":
		TweenFX.spotlight(offhand, 0.3)
		TweenFX.blink(offhand, 0.1, 1)


func block_animation(id, hand):
	var mainhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/MainHand")
	var offhand = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/OffHand")
	mainhand["modulate"] = "ffffff"

	var animation_player = get_node_or_null("_EquipmentPanel" + str(id) + "/Animations/OffHandAnimationPlayer")

	if animation_player.has_animation("block"):
		animation_player.play("block")

	if hand == "MainHand":
		TweenFX.spotlight(mainhand, 0.3, "d2c9a5")

	elif hand == "OffHand":
		TweenFX.spotlight(offhand, 0.3, "d2c9a5")



func hit_animation(id):
	var _equipment_panel_picture = get_node("_EquipmentPanel" + str(id) + "/EquipmentPanelPicture")
	_equipment_panel_picture["modulate"] = "ffffff"
	TweenFX.spotlight(_equipment_panel_picture, 0.2, "d2c9a5")


func crit_animation(id):
	var _equipment_panel_picture = get_node("_EquipmentPanel" + str(id) + "/EquipmentPanelPicture")
	_equipment_panel_picture["modulate"] = "ffffff"
	TweenFX.spotlight(_equipment_panel_picture, 0.2, "79444a")


func dodge_animation(id):
	var _equipment_panel_picture = get_node("_EquipmentPanel" + str(id) + "/EquipmentPanelPicture")


func update_hp(id, current_health, max_health):
	if current_health < 0.6 * max_health and current_health >= 0.3 * max_health:
		healthbar_color = Color("b3a555")
	elif current_health < 0.3 * max_health:
		healthbar_color = Color("78222c")
	else:
		healthbar_color = Color("77883b")

	var health_bar = get_node("_EquipmentPanel" + str(id) + "/HealthBar")
	var health_bar_text = get_node("_EquipmentPanel" + str(id) + "/HealthBar/HealthBarText")
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar_text.text = str(int(current_health))

	var old_sb = health_bar.get_theme_stylebox("fill")

	if old_sb:
		var new_sb = old_sb.duplicate()
		new_sb.bg_color = healthbar_color
		health_bar.add_theme_stylebox_override("fill", new_sb)


func _on_lock_shop_pressed() -> void :
	if is_refreshing:
		print("can't lock shop due to rerolling ongoing")
		return

	is_shop_locked = !is_shop_locked
	refresh_button.disabled = is_shop_locked

	var cards = shop_grid.get_children()
	#var i = 0
	for card in cards:
		card.get_children()[0].disabled = is_shop_locked
		#i += 1

	if is_shop_locked == true: shop_grid.modulate = "ffffffce"
	else: shop_grid.modulate = "ffffff"
	
	
	
func update_gladiator_stats(id):
	var combined_gladiator_bonuses = all_gladiators.get("total_modifier_bonuses", {})


	#var recalculated_hit_chance = 0

	var chest_absorb = 0
	var head_absorb = 0
	var shoulders_absorb = 0
	var belt_absorb = 0
	var legs_absorb = 0
	var boots_absorb = 0
	var gloves_absorb = 0

	if all_gladiators[id].has("chest") and all_gladiators[id]["chest"].size() > 0:
		var chest_name = all_gladiators[id]["chest"].keys()[0]
		chest_absorb = all_gladiators[id]["chest"][chest_name].get("absorb", 0)
	if all_gladiators[id].has("shoulders") and all_gladiators[id]["shoulders"].size() > 0:
		var shoulders_name = all_gladiators[id]["shoulders"].keys()[0]
		shoulders_absorb = all_gladiators[id]["shoulders"][shoulders_name].get("absorb", 0)
	if all_gladiators[id].has("head") and all_gladiators[id]["head"].size() > 0:
		var head_name = all_gladiators[id]["head"].keys()[0]
		head_absorb = all_gladiators[id]["head"][head_name].get("absorb", 0)

	if all_gladiators[id].has("belt") and all_gladiators[id]["belt"].size() > 0:
		var belt_name = all_gladiators[id]["belt"].keys()[0]
		belt_absorb = all_gladiators[id]["belt"][belt_name].get("absorb", 0)
	if all_gladiators[id].has("legs") and all_gladiators[id]["legs"].size() > 0:
		var legs_name = all_gladiators[id]["legs"].keys()[0]
		legs_absorb = all_gladiators[id]["legs"][legs_name].get("absorb", 0)
	if all_gladiators[id].has("boots") and all_gladiators[id]["boots"].size() > 0:
		var boots_name = all_gladiators[id]["boots"].keys()[0]
		boots_absorb = all_gladiators[id]["boots"][boots_name].get("absorb", 0)
	if all_gladiators[id].has("gloves") and all_gladiators[id]["gloves"].size() > 0:
		var gloves_name = all_gladiators[id]["gloves"].keys()[0]
		gloves_absorb = all_gladiators[id]["gloves"][gloves_name].get("absorb", 0)


	var stance = all_gladiators[id]["stance"]
	var attack_type = all_gladiators[id]["attack_type"]

	var strength = all_gladiators[id]["attributes"]["strength"]
	var quickness = all_gladiators[id]["attributes"]["quickness"]
	var crit_rating = all_gladiators[id]["attributes"]["crit_rating"]
	var avoidance = all_gladiators[id]["attributes"]["avoidance"]
	var max_health = all_gladiators[id]["attributes"]["health"]
	var resilience = all_gladiators[id]["attributes"]["resilience"]
	var endurance = all_gladiators[id]["attributes"]["endurance"]
	var sword_mastery = all_gladiators[id]["attributes"]["sword_mastery"]
	var axe_mastery = all_gladiators[id]["attributes"]["axe_mastery"]
	var stabbing_mastery = all_gladiators[id]["attributes"]["stabbing_mastery"]
	var mace_mastery = all_gladiators[id]["attributes"]["mace_mastery"]
	var flagellation_mastery = all_gladiators[id]["attributes"]["flagellation_mastery"]

	var stance_dodge_mod = 1
	var stance_parry_block_mod = 1
	var stance_attack_speed_mod = 1
	var stance_crit_chance_mod = 1
	var stance_crit_multi_mod = 1
	var stance_endurance_mod = 1
	var attack_type_hit_mod = 1
	var attack_type_str_mod = 1

	if stance == "defensive":
		stance_dodge_mod = 1.15
		stance_parry_block_mod = 1.15
		stance_attack_speed_mod = 1.1
		stance_crit_chance_mod = 0.9
		stance_crit_multi_mod = 0.9

	elif stance == "offensive":
		stance_dodge_mod = 0.9
		stance_parry_block_mod = 0.9
		stance_attack_speed_mod = 0.9
		stance_crit_chance_mod = 1.1
		stance_crit_multi_mod = 1.1
	elif stance == "jester":
		stance_endurance_mod = 0.9

	if attack_type == "light":
		attack_type_hit_mod = 1.1
		attack_type_str_mod = 0.7
	elif attack_type == "heavy":
		attack_type_hit_mod = 0.9
		attack_type_str_mod = 1.3


	var level = all_gladiators[id]["level"]
	var weapon1_name = all_gladiators[id]["weapon1"].keys()[0]
	var weapon2_name = all_gladiators[id]["weapon2"].keys()[0]

	var weapon1_skill_req = all_gladiators[id]["weapon1"][weapon1_name]["skill_req"]
	var weapon1_str_req = all_gladiators[id]["weapon1"][weapon1_name]["str_req"]
	var weapon1_speed = all_gladiators[id]["weapon1"][weapon1_name]["speed"]
	var weapon1_range = all_gladiators[id]["weapon1"][weapon1_name]["range"]
	var weapon1_crit_chance = 1 + all_gladiators[id]["weapon1"][weapon1_name]["crit_chance"]
	var weapon1_crit_multi = all_gladiators[id]["weapon1"][weapon1_name]["crit_multi"]

	var weapon2_skill_req = all_gladiators[id]["weapon2"][weapon2_name]["skill_req"]
	var weapon2_str_req = all_gladiators[id]["weapon2"][weapon2_name]["str_req"]
	var weapon2_speed = all_gladiators[id]["weapon2"][weapon2_name]["speed"]
	var weapon2_range = all_gladiators[id]["weapon2"][weapon2_name]["range"]
	var weapon2_crit_chance = 1 + all_gladiators[id]["weapon2"][weapon2_name]["crit_chance"]
	var weapon2_crit_multi = all_gladiators[id]["weapon2"][weapon2_name]["crit_multi"]

	var armor_absorb = 1.0
	var concede_threshold = all_gladiators[id]["concede"]



	var race = all_gladiators[id]["race"].to_lower()
	var gladiator_name = all_gladiators[id].name


	var weight = all_gladiators[id]["weight"] - strength / 40
	var endurance_weight = 1 - weight / (100 + weight)
	var endurance_decay = endurance / 75 + 1
	endurance_sec = 2 + stance_endurance_mod * endurance * endurance_weight / endurance_decay
	var weapon1 = all_gladiators[id]["weapon1"][weapon1_name]
	var weapon2 = all_gladiators[id]["weapon2"][weapon2_name]
	var weapon1_durability = all_gladiators[id]["weapon1"][weapon1_name]["durability"]
	var weapon2_durability = all_gladiators[id]["weapon2"][weapon2_name]["durability"]

	var life_on_block = combined_gladiator_bonuses.get("life_on_block", 0)

	var shield_absorb = all_gladiators[id]["weapon2"][weapon2_name].get("absorb", -1)
	var weapon1_can_parry = all_gladiators[id]["weapon1"][weapon1_name]["parry"]
	var weapon2_can_parry = all_gladiators[id]["weapon2"][weapon2_name]["parry"]
	var weapon2_can_block = all_gladiators[id]["weapon2"][weapon2_name]["block"]
	var weapon_hands_to_carry = all_gladiators[id]["weapon1"][weapon1_name]["hands"]


	var weapon1_category = all_gladiators[id]["weapon1"][weapon1_name].get("category", "")
	var weapon2_category = all_gladiators[id]["weapon2"][weapon2_name].get("category", "")
	var glad_weapon1_category_skill = all_gladiators[id]["attributes"][weapon1_category + "_mastery"]
	var glad_weapon2_category_skill = all_gladiators[id]["attributes"][weapon2_category + "_mastery"]

	var hit_base_per_lvl = - 1.1
	var hit_skill_weight_1 = (glad_weapon1_category_skill / (weapon1_skill_req * (0.8 + weight / 150.0))) # Reduce hit chance with weight
	var hit_skill_weight_2 = (glad_weapon2_category_skill / (weapon2_skill_req * (0.8 + weight / 150.0))) # Reduce hit chance with weight
	var hit_curve_smoothness = 6 + float(level) / 4 # In low level, hit curve is more smooth (exponential part)
	var wep1_difficulty = 1 # vary around 1 -> higher makes it easier to handle
	var wep2_difficulty = 1 # vary around 1 -> higher makes it easier to handle

	var block_chance
	var crit_multi
	var crit_chance
	var hit_chance
	var attack_speed
	var parry_chance
	

	if weapon2_can_block:
		#block_chance = stance_parry_block_mod * (0.8 - exp(-0.4 * (2 * glad_weapon2_category_skill / weapon2_skill_req - 1.0))) + combined_gladiator_bonuses.get("increased_block_chance", 0) / 100.0
		var block_skill_weight1 = (0.7*glad_weapon2_category_skill / (weapon2_skill_req * (0.8 + weight / 400.0)))
		block_chance = stance_parry_block_mod * (wep1_difficulty + 1.1/(hit_base_per_lvl - (block_skill_weight1 ** hit_curve_smoothness)))

		crit_multi = [stance_crit_multi_mod * ((weapon1_crit_multi + (((1 + weapon1_crit_multi) ** weapon1_crit_multi) * crit_rating) / (weapon1_crit_multi * crit_rating + 400))), 
			stance_crit_multi_mod * ((weapon1_crit_multi + (((1 + weapon1_crit_multi) ** weapon1_crit_multi) * crit_rating) / (weapon1_crit_multi * crit_rating + 400)))]

		var W1 = weight / ( 400 + weight)
		crit_chance = [weapon1_crit_chance - 1 - W1 + stance_crit_chance_mod * (((weapon1_crit_chance-W1) ** 4) * crit_rating / ((((weapon1_crit_chance-W1) ** 4) * crit_rating) + 300+6*weight)), 
					   weapon1_crit_chance - 1 - W1 + stance_crit_chance_mod * (((weapon1_crit_chance-W1) ** 4) * crit_rating / ((((weapon1_crit_chance-W1) ** 4) * crit_rating) + 300+6*weight))]


		hit_chance = [attack_type_hit_mod * (wep1_difficulty + 1 / (hit_base_per_lvl - (hit_skill_weight_1 ** hit_curve_smoothness))), 
			attack_type_hit_mod * (wep1_difficulty + 1 / (hit_base_per_lvl - (hit_skill_weight_1 ** hit_curve_smoothness)))]
	else:
		block_chance = 0
		crit_multi = [stance_crit_multi_mod * ((weapon1_crit_multi + (((1 + weapon1_crit_multi) ** weapon1_crit_multi) * crit_rating) / (weapon1_crit_multi * crit_rating + 400))), 
			stance_crit_multi_mod * ((weapon2_crit_multi + (((1 + weapon2_crit_multi) ** weapon2_crit_multi) * crit_rating) / (weapon2_crit_multi * crit_rating + 400)))]

		var W1 = weight / ( 400 + weight)
		var W2 = weight / ( 400 + weight)
		
		crit_chance = [weapon1_crit_chance - 1 - W1 + stance_crit_chance_mod * (((weapon1_crit_chance-W1) ** 4) * crit_rating / ((((weapon1_crit_chance-W1) ** 4) * crit_rating) + 300+6*weight)), 
					   weapon2_crit_chance - 1 - W2 + stance_crit_chance_mod * (((weapon2_crit_chance-W2) ** 4) * crit_rating / ((((weapon2_crit_chance-W2) ** 4) * crit_rating) + 300+6*weight))]

		hit_chance = [attack_type_hit_mod * (wep1_difficulty + 1 / (hit_base_per_lvl - (hit_skill_weight_1 ** hit_curve_smoothness))), 
			attack_type_hit_mod * (wep2_difficulty + 1 / (hit_base_per_lvl - (hit_skill_weight_2 ** hit_curve_smoothness)))]

	if weapon1_name == "unarmed":
		crit_chance[0] = 0.10
		crit_multi[0] = 1.1
		hit_chance[0] = 0.7
		weapon1_speed = 0.25
	if weapon2_name == "unarmed":
		crit_chance[1] = 0.10
		crit_multi[1] = 1.1
		hit_chance[1] = 0.7
		weapon2_speed = 0.25

# === Damage calculations ===
	if weapon_hands_to_carry == 1:
		var K = (1 + combined_gladiator_bonuses.get("global_increased_attack_speed", 0) / 100.0) \
		* stance_attack_speed_mod

		attack_speed = 1 / (K * (
				5
				+ weapon1_speed
				+ weapon2_speed
				- weight / (400.0 + weight)
				- 5.0 / (1.0 + (0.7 * quickness / ((100.0 + 3.0 * weight) / (weapon1_speed + weapon2_speed))) ** 2)))

		var parry_skill_weight1 = (0.55*glad_weapon1_category_skill / (weapon1_skill_req * (0.8 + weight / 400.0)))
		var parry_skill_weight2 = (0.55*glad_weapon2_category_skill / (weapon2_skill_req * (0.8 + weight / 400.0)))
		parry_chance = [stance_parry_block_mod * (wep1_difficulty + 1.1/(hit_base_per_lvl - (parry_skill_weight1 ** hit_curve_smoothness))), 
						stance_parry_block_mod * (wep2_difficulty + 1.1/(hit_base_per_lvl - (parry_skill_weight2 ** hit_curve_smoothness)))]

	else:
		var K = (1 + combined_gladiator_bonuses.get("global_increased_attack_speed", 0) / 100.0) \
		* stance_attack_speed_mod

		attack_speed = 1 / (K * (
				5
				+ weapon1_speed
				- weight / (400.0 + weight)
				- 5.0 / (1.0 + (0.7 * quickness / ((100.0 + 3.0 * weight) / (weapon1_speed))) ** 2)))

		var parry_skill_weight1 = (0.55*glad_weapon1_category_skill / (weapon1_skill_req * (0.8 + weight / 400.0)))
		parry_chance = [stance_parry_block_mod * (wep1_difficulty + 1.1/(hit_base_per_lvl - (parry_skill_weight1 ** hit_curve_smoothness))), 
						stance_parry_block_mod * (wep2_difficulty + 1.1/(hit_base_per_lvl - (parry_skill_weight1 ** hit_curve_smoothness)))]
						

	var combined_avg_absorb = (head_absorb + shoulders_absorb + chest_absorb + belt_absorb + legs_absorb + boots_absorb + gloves_absorb)
	var absorb_after_resilience = combined_avg_absorb
	var dodge_chance = stance_dodge_mod * ((2 * avoidance / ((1.1 + 0.05 * weight) ** 1.5)) / 200) / ((2 * avoidance / (1.1 + 0.05 * weight) / 200) + 1)
	#seconds_to_live = endurance / 3.0



	update_glad_stats(attack_speed, hit_chance, dodge_chance, parry_chance, block_chance, absorb_after_resilience, crit_chance, crit_multi, endurance_sec, weight, weapon_hands_to_carry, weapon1_name, weapon2_name)
	
func update_glad_stats(attack_speed, hit, dodge, parry, block, absorb, crit_chance, crit_multi, _seconds, weight, weapon_hands_to_carry, weapon1_name, weapon2_name): 
	
	if my_endurance_bar and intermission:
		new_endurance_sec = _seconds
		my_endurance_bar.max_value = new_endurance_sec
	
	if block > 0 or weapon_hands_to_carry == 2:
		stat_attack_speed.bbcode_text = "%s" % snapped(1/attack_speed, 0.001)
		stat_hit.bbcode_text = "%s" % [snapped(clamp(0.0, 100.0, 100*hit[0]), 0.1)]
		stat_dodge.bbcode_text = "%s" % snapped(clamp(0.0, 100.0, 100*dodge), 0.1)
		stat_parry.bbcode_text = "%s" % [snapped(clamp(0.0, 100.0, 100*parry[0]), 0.1)]
		stat_block.bbcode_text = "-"# % snapped(100*block, 0.1)
		stat_absorb.bbcode_text = "%s" % int(round(absorb))
		stat_crit.bbcode_text = "%s" % [snapped(clamp(0.0, 100.0, 100*crit_chance[0]), 0.1)]
		stat_multi.bbcode_text = "×  %s" % [snapped(crit_multi[0], 0.01)]
		stat_weight.bbcode_text = "%s" % int(round(weight))
		
	elif weapon_hands_to_carry == 1 and block == 0:
		stat_attack_speed.bbcode_text = "%s" % snapped(1/attack_speed, 0.001)
		stat_hit.bbcode_text = "%s  |  %s" % [snapped(clamp(0.0, 100.0, 100*hit[0]), 0.1), snapped(clamp(0.0, 100.0, 100*hit[1]), 0.1)]
		stat_dodge.bbcode_text = "%s" % snapped(clamp(0.0, 100.0, 100*dodge), 0.1)
		stat_parry.bbcode_text = "%s  |  %s" % [snapped(clamp(0.0, 100.0, 100*parry[0]), 0.1), snapped(clamp(0.0, 100.0, 100*parry[1]), 0.1)]
		stat_block.bbcode_text = "-"# % snapped(100*block, 0.1)
		stat_absorb.bbcode_text = "%s" % int(round(absorb))
		stat_crit.bbcode_text = "%s  |  %s" % [snapped(clamp(0.0, 100.0, 100*crit_chance[0]), 0.1), snapped(clamp(0.0, 100.0, 100*crit_chance[1]), 0.1)]
		stat_multi.bbcode_text = "× %s  |  %s" % [snapped(crit_multi[0], 0.1), snapped(crit_multi[1], 0.01)]
		stat_weight.bbcode_text = "%s" % int(round(weight))

	if block > 0 and weapon_hands_to_carry == 1:
		stat_block.bbcode_text = "%s" % snapped(clamp(0.0, 100.0, 100*block), 0.1)
	



func _on_help_toggled(_toggled_on: bool) -> void:
	$AttributePanelHelp.visible = !$AttributePanelHelp.visible


func _on_cancel_help_pressed() -> void:
	$AttributePanelHelp.visible = false
