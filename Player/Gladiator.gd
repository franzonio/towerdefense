extends CharacterBody2D

@onready var DamagePopupScene = preload("res://DamagePopup.tscn")

#@onready var synchronizer = $MultiplayerSynchronizer
var no_wep = {"hands": 1,
			"min_dmg": 1, 
			"max_dmg": 3,
			"durability": 1,
			"crit_chance": 0.1,
			"crit_multi": 1.1,
			"speed": 0.25,
			"range": 150,
			"parry": false,
			"block": false,
			"price": 0,
			"stock": 500,
			"type": "weapon",
			"category": "unarmed",
			"str_req": 20,
			"skill_req": 30,
			"level": 1,
			"attributes": 
			{
				"weapon_skill": 0,
			}}
var no_wep_hit_chance = 0.7
var no_wep_crit_chance = no_wep["crit_chance"]
var no_wep_crit_multi = no_wep["crit_multi"]
var no_wep_attack_speed = no_wep["speed"]

var time_passed = 0
@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite
@onready var health_bar = $HealthBar
@onready var health_bar_text = $HealthBar/HealthBarText
@onready var multiplayer_sync = $MultiplayerSynchronizer

@export var speed: float = 250.0
#@export var max_health: int = 100
#var current_health: int = max_health

#@export var name: String = ""
@export var race: String = ""
@export var level: String 
@export var attributes: Dictionary = {}
@export var gladiator_name: String = ""

#@onready var nameLabel = $Name

#var velocity: Vector2 = Vector2.ZERO
@export var current_animation: String = "idle_down"
@export var prev_animation: String = "idle_down"

var input_vector := Vector2.ZERO

####
@export var weapon1_dmg_min: float
@export var weapon1_dmg_max: float
@export var weapon1_str_req: float
@export var weapon1_skill_req: float
@export var weapon1_speed: float
@export var weapon1_range = 150.0
@export var weapon1_crit_chance: float
@export var weapon1_crit_multi: float
@export var weapon2_dmg_min: float
@export var weapon2_dmg_max: float
@export var weapon2_str_req: float
@export var weapon2_skill_req: float
@export var weapon2_speed: float
@export var weapon2_range = 150.0
@export var weapon2_crit_chance: float
@export var weapon2_crit_multi: float
@export var weapon1_durability: int
@export var weapon2_durability: int
@export var weapon1_can_parry: bool
@export var weapon2_can_parry: bool
@export var weapon2_can_block: bool
@export var weapon1: Dictionary
@export var weapon2: Dictionary
@export var weapon_hands_to_carry: int

@export var shield_absorb: int
@export var armor_absorb := 1.0
@export var endurance_sec: float


@export var strength := 1.0
@export var quickness := 1.0
@export var crit_rating := 1.0
@export var avoidance := 1.0
@export var max_health := 1.0
@export var resilience := 1.0
@export var endurance := 1.0
@export var weapon_skill := 1.0
@export var sword_mastery := 1.0
@export var dagger_mastery := 1.0
@export var axe_mastery := 1.0
@export var chain_mastery := 1.0
@export var hammer_mastery := 1.0

var attack_type_str_mod = 1
var glad_weapon1_category_skill
var glad_weapon2_category_skill
var recalculated_hit_chance = 0
 
#var weapon: Dictionary


 # === Damage calculations ===
@export var attack_speed: float 
@export var time_since_last_attack: float
@export var crit_chance: Array
@export var crit_multi: Array
@export var parry_chance: Array
@export var block_chance: float
@export var hit_chance: Array
@export var next_attack_critical: bool = false
@export var next_taken_hit_critical: bool = false
@export var next_attack_weapon: int

var spawn_point

 # === Calculations ===
@export var weight = 1
@export var move_speed := 0
@export var current_health = max_health
@export var armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
@export var dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
@export var seconds_to_live = endurance/3.0

####
var all_gladiators
var target_position: Vector2 = Vector2.ZERO

const ATTACK_RANGE := 160.0
@export var last_attack_time := -999.0

var current_attack_target: Node = null
var attack_charge_time: float = 0.0

var float_speed = -30
var lifetime = 30

var attack_right_animations: Array = []# all_animations.filter(func(name): return name.begins_with("attack_right"))
var attack_left_animations: Array = []# = all_animations.filter(func(name): return name.begins_with("attack_left"))

@export var opponent_peer_id: int = -1
@onready var opponent: Node = null
#@onready var round_manager = get_tree().get_root().get_node("Main/RoundManager")

@export var in_combat := false
var last_played_animation: String = ""
@export var direction: Vector2 = Vector2.ZERO
var owner_id
@export var dead: int
var opponent_dead = false
@export var concede_threshold := 0.5

signal died

func _ready():
	time_passed = -1000
	await get_tree().process_frame 
	dead = 0
	add_to_group("gladiators")
	sprite.play("idle_down")
	GameState_.connect("send_gladiator_data_to_peer_signal", Callable(self, "_on_send_gladiator_data_to_peer_signal"))
	if is_multiplayer_authority():
		
		var hud = get_node("/root/Main/HUD")
		if hud:
			hud.concede_threshold_changed.connect(_on_concede_threshold_changed)
	await get_tree().create_timer(1.0).timeout # 11
	time_passed = 0
	# Intermission phase where players buy upgrades
	
	if multiplayer.is_server(): update_all_gladiators(GameState_.all_gladiators)

	await get_tree().create_timer(0.1).timeout

	if multiplayer.is_server():
		GameState_.refresh_gladiator_data(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "refresh_gladiator_data", multiplayer.get_unique_id())


	#$HealthBar.value = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	#$HealthBar.bg_color = Color.FOREST_GREEN
	$HealthBar/HealthBarText.text = str(int(current_health))

	if opponent_peer_id:
		if opponent == null:
			for g in get_tree().get_nodes_in_group("gladiators"):
				if g.get_multiplayer_authority() == opponent_peer_id: opponent = g
		
		var all_animations = sprite.sprite_frames.get_animation_names()

		for animation_name in all_animations:
			if animation_name.begins_with("attack_right"): attack_right_animations.append(animation_name)
			if animation_name.begins_with("attack_left"): attack_left_animations.append(animation_name)
	
# Only process input if this is OUR player
func _process(delta: float) -> void:
	time_passed += delta
	if is_multiplayer_authority():
		if opponent and opponent.dead and not opponent_dead:
			opponent_dead = true
		if !dead and time_passed > endurance_sec and !opponent_dead:
			dead = 1
			print("_process peer " + str(multiplayer.get_unique_id()) + " died")
			rpc("die")

func _physics_process(delta):
	$HealthBar.value = current_health
	if is_multiplayer_authority() and opponent != null and is_instance_valid(opponent) and opponent.current_health > opponent.max_health*opponent.concede_threshold and opponent_peer_id:
		if opponent_dead: return
		prev_animation = current_animation
		check_for_attack(delta)
		handle_ai_movement(delta)
		handle_animation()
	else: 
		if opponent_dead: return
		if current_animation.begins_with("attack"): sprite.play(current_animation)
		elif !current_animation.begins_with("attack") and current_animation != "N/A": sprite.play(current_animation)
		
func _on_send_gladiator_data_to_peer_signal(_peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators
		
func _on_concede_threshold_changed(value: float):
	concede_threshold = value
	
func handle_animation():
	if current_animation.begins_with("attack") and !sprite.is_playing(): sprite.play(current_animation)
	elif !current_animation.begins_with("attack") and current_animation != "N/A": sprite.play(current_animation)
	
	if not sprite.is_connected("animation_finished", _on_any_animation_finished): sprite.animation_finished.connect(_on_any_animation_finished, CONNECT_ONE_SHOT)
	
	
func _on_any_animation_finished(): 
	if sprite.animation == "die": emit_signal("died")
	else: current_animation = "N/A"
		
		
func check_for_attack(delta: float):
	if opponent == null or !is_instance_valid(opponent):
		current_attack_target = null
		attack_charge_time = 0.0
		return

	if opponent and opponent.is_inside_tree():
		var distance = global_position.distance_to(opponent.global_position)

		if distance <= ATTACK_RANGE:
			in_combat = true
			current_attack_target = opponent
			attack_charge_time += delta

			#print("opponent.current_health" + str(opponent.current_health))
			if attack_charge_time >= attack_speed and opponent.current_health > opponent.max_health*opponent.concede_threshold and !opponent.dead:
				if direction.x > 0.0: current_animation = attack_right_animations[randi_range(0, attack_right_animations.size()-1)]
				if direction.x < 0.0: current_animation = attack_left_animations[randi_range(0, attack_left_animations.size()-1)]
				

				
				var weapon
				var _hit_chance
				var _crit_chance
				var _crit_multi
				#print(str(owner_id) + " weapon: " + str(next_attack_weapon))
				#print("weapon1_durability: " + str(weapon1_durability))
				#print("weapon2_durability: " + str(weapon2_durability))
				if weapon1_durability <= 0: 
					weapon1 = no_wep
					#print("Switch to fists in weapon slot 1")
				if weapon2_durability <= 0: 
					weapon2 = no_wep
					#print("Switch to fists in weapon slot 2")
				
				if next_attack_weapon == 0: 
					weapon = weapon1
					if weapon1_durability > 0:
						_hit_chance = hit_chance[0]
						_crit_chance = crit_chance[0]
						_crit_multi = crit_multi[0]
					else:
						_hit_chance = no_wep_hit_chance
						_crit_chance = no_wep_crit_chance
						_crit_multi = no_wep_crit_multi
					next_attack_weapon = 1
				elif next_attack_weapon == 1: 
					if !weapon2_can_block: weapon = weapon2
					else: weapon = weapon1
					if weapon2_durability > 0:
						_hit_chance = hit_chance[1]
						_crit_chance = crit_chance[1]
						_crit_multi = crit_multi[1]
					else:
						_hit_chance = no_wep_hit_chance
						_crit_chance = no_wep_crit_chance
						_crit_multi = no_wep_crit_multi
					next_attack_weapon = 0
					
				#print("Peer parry chance: " + str(parry_chance))
				#print("Opponent parry chance: " + str(opponent.parry_chance))
				#print("Crit? " + str(next_attack_critical))
				#if multiplayer.is_server(): print("before deal_attack crit_multi:" + str(crit_multi))
				#if multiplayer.is_server(): print("before deal_attack _crit_multi:" + str(_crit_multi))
				var dodge_modify = 1
				var jester_penalty = 1
				if all_gladiators[opponent_peer_id]["stance"] == "jester":
					jester_penalty = 0.95
				if all_gladiators[opponent_peer_id]["attack_type"] == "light":
					dodge_modify = 1.4
				if all_gladiators[opponent_peer_id]["attack_type"] == "heavy":
					dodge_modify = 0.6
				if recalculated_hit_chance == 0 and (jester_penalty or dodge_modify):
					update_gladiator_after_strategy(jester_penalty, dodge_modify)
					
				deal_attack(self, opponent, weapon, _hit_chance, _crit_chance, _crit_multi)
				attack_charge_time = 0.0
		else:
			attack_charge_time = 0.0
			in_combat = false
	else:
		in_combat = false
		attack_charge_time = 0.0

func deal_attack(attacker: Node, defender: Node, _weapon, _hit_chance, _crit_chance, _crit_multi):
	var wep_min_dmg = _weapon["min_dmg"]
	var wep_max_dmg = _weapon["max_dmg"]
	var wep_category = _weapon["category"]
	var block_success = 0
	var parry_success = 0	# default 0 means defender did not parry
	var dodge_success = 0	# default 0 means defender did not dodge
	var hit_success = 1		# default 1 means attacker hit successfully
	var crit = 1.0
	var defender_weapon1_destroyed = 0
	var defender_weapon2_destroyed = 0
	
	if randf() > _hit_chance:
		hit_success = 0
			
	if hit_success and randf() < _crit_chance or attacker.next_attack_critical:
		crit = _crit_multi
		attacker.next_attack_critical = false  # reset after use

	var effective_str = attack_type_str_mod*strength
	var roll_wep_dmg = randf_range(wep_min_dmg, wep_max_dmg)
	var dmg_after_str = 0
	var str_used_before_max = 0
	
	if roll_wep_dmg + effective_str/15.0 > _weapon["max_dmg"]:
		str_used_before_max = (wep_max_dmg-roll_wep_dmg)*15
		var str_left = effective_str - str_used_before_max
		if wep_category == "dagger":
			dmg_after_str = roll_wep_dmg + str_used_before_max/15 + str_left/34
		elif wep_category == "sword":
			dmg_after_str = roll_wep_dmg + str_used_before_max/15 + str_left/30
		elif wep_category == "axe":
			dmg_after_str = roll_wep_dmg + str_used_before_max/15 + str_left/26
		elif wep_category == "hammer":
			dmg_after_str = roll_wep_dmg + str_used_before_max/15 + str_left/20
		elif wep_category == "chain":
			dmg_after_str = roll_wep_dmg + str_used_before_max/15 + str_left/18
		elif wep_category == "unarmed":
			dmg_after_str = roll_wep_dmg + str_used_before_max/15 + str_left/50
	else:
		dmg_after_str = roll_wep_dmg + effective_str/15.0

	var raw_damage = dmg_after_str*crit
	
	if raw_damage > 0 and randf() < defender.dodge_chance:
		dodge_success = 1
		defender.next_attack_critical = true
		attacker.next_taken_hit_critical = true
		
	elif hit_success and defender.weapon2_can_block and defender.weapon2_durability > 0 and raw_damage > 0 and randf() < defender.block_chance:
		block_success = 1
		defender.weapon2_durability -= clamp(raw_damage - defender.shield_absorb, 0, 9999)
		if defender.weapon2_durability <= 0:
			defender_weapon2_destroyed = 1
			
	elif hit_success and defender.weapon2_can_parry and defender.weapon2_durability > 0 and raw_damage > 0 and randf() < defender.parry_chance[1]:
		parry_success = 1
		defender.weapon2_durability -= raw_damage
		if defender.weapon2_durability <= 0:
			defender_weapon2_destroyed = 1
			
	elif hit_success and defender.weapon1_can_parry and defender.weapon2_durability < 0 and defender.weapon1_durability > 0 and raw_damage > 0 and randf() < defender.parry_chance[0]:
		parry_success = 1
		defender.weapon1_durability -= raw_damage
		if defender.weapon1_durability <= 0:
			defender_weapon1_destroyed = 1
	
	var final_damage = hit_success*(1-dodge_success)*(1-parry_success)*(1-block_success)*roundf(raw_damage - defender.armor)

	if defender.has_method("receive_damage"):
		defender.rpc_id(defender.get_multiplayer_authority(), "receive_damage", final_damage, raw_damage, 
		hit_success, dodge_success, crit, parry_success, defender_weapon1_destroyed, defender_weapon2_destroyed, 
		defender.weapon1_durability, defender.weapon2_durability, block_success, defender.shield_absorb)
		return true
	else:
		push_warning("Defender %s has no take_damage() method!" % defender.name)
		return false

@rpc("any_peer", "call_local")
func receive_damage(amount: int, raw_damage, hit_success, dodge_success, crit, parry_success, defender_weapon1_broken, 
					defender_weapon2_broken, wep1_new_durability, wep2_new_durability, block_success, shield_absorb):
	if !hit_success or dodge_success: next_attack_critical = true
	
	weapon1_durability = wep1_new_durability
	weapon2_durability = wep2_new_durability
	current_health -= amount
	$HealthBar.value = current_health
	#$HealthBar.bg_color = Color.DARK_RED
	$HealthBar/HealthBarText.text = str(int(current_health))
	rpc("show_damage_popup", amount, raw_damage, hit_success, dodge_success, crit, parry_success,
	 						defender_weapon1_broken, defender_weapon2_broken, block_success, shield_absorb)
	if current_health <= concede_threshold*max_health and is_multiplayer_authority(): rpc("die")


@rpc("any_peer", "call_local")
func die():
	if is_multiplayer_authority():
		var health_loss
		dead = 1
		if current_health <= 0: health_loss = 15 + abs(current_health) 
		else: health_loss = 5
		if multiplayer.is_server(): GameState_.modify_gladiator_life(owner_id, health_loss)  # Run it locally too!
		else: GameState_.modify_gladiator_life.rpc(owner_id, health_loss)
		
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.disabled = true
	sprite.stop()
	
	if not sprite.is_playing():
		sprite.play("die")
		
	print("die()  |  peer " + str(multiplayer.get_unique_id()) + " emits died signal")
	emit_signal("died")
	

func handle_ai_movement(delta):
	direction = (target_position - global_position).normalized()
	
	if !in_combat: velocity = direction * move_speed
	else: velocity = Vector2.ZERO
		
	position += velocity * delta

	if !current_animation.begins_with("attack"):# or current_animation != "N/A":
		if !in_combat:
			if abs(direction.x) > abs(direction.y): current_animation = "walk_right" if direction.x > 0 else "walk_left"
			else: current_animation = "walk_down" if direction.y > 0 else "walk_up"
			prev_animation = current_animation
		else:
			# Stop at idle direction depending on last move
			if prev_animation == "walk_right": current_animation = "idle_right"
			elif prev_animation == "walk_left": current_animation = "idle_left"
			elif prev_animation == "walk_up": current_animation = "idle_up"
			elif prev_animation == "walk_down": current_animation = "idle_down"

	# Stop when close enough
	if global_position.distance_to(target_position) < 10:
		velocity = Vector2.ZERO
		target_position = Vector2.ZERO


# Called by the server to initialize this gladiator
#@rpc("any_peer", "call_local")
func initialize_gladiator(data, opponent_id, _spawn_point, meeting_point, peer_id):
	spawn_point = _spawn_point
	position = _spawn_point
	
	owner_id = peer_id
	if opponent_id: 
		opponent_peer_id = opponent_id
		target_position = meeting_point
	else: target_position = position
	
	update_gladiator(data)



@rpc("any_peer", "call_local")
func show_damage_popup(amount, raw_damage, hit_success, dodge_success, crit, parry_success,
					defender_weapon1_broken, defender_weapon2_broken, block_success, shield_absorb):
	var popup = DamagePopupScene.instantiate()
	if prev_animation == "idle_left" or prev_animation == "walk_left": popup.global_position = global_position + Vector2(150, 40)
	elif prev_animation == "idle_right" or prev_animation == "walk_right": popup.global_position = global_position + Vector2(-150, 40)
	else: popup.global_position = global_position + Vector2(0, 40)
	#print("show_damage_popup" + str(spawn_point))
	popup.show_damage(amount, raw_damage, hit_success, dodge_success, crit, parry_success, spawn_point,
	 				defender_weapon1_broken, defender_weapon2_broken, block_success, shield_absorb)
	get_tree().current_scene.add_child(popup)


func customize_popup_font(color: Color, size, text: String):
		$Label.add_theme_color_override("font_color", color) 
		$Label.add_theme_font_size_override("font_size", size)
		$Label.text = text
		$Label.modulate.a = 1.0  # Fully visible


'''func handle_input(delta):
	input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * move_speed
	position += velocity * delta

	prev_animation = current_animation
	# Update animation
	if !sprite.animation == "attack":
		if input_vector != Vector2.ZERO:
			if abs(input_vector.x) > abs(input_vector.y):
				current_animation = "walk_right" if input_vector.x > 0 else "walk_left"
			else:
				current_animation = "walk_down" if input_vector.y > 0 else "walk_up"
		else:
			if prev_animation == "walk_right": current_animation = "idle_right"
			elif prev_animation == "walk_left": current_animation = "idle_left"
			elif prev_animation == "walk_up": current_animation = "idle_up"
			elif prev_animation == "walk_down": current_animation = "idle_down"

		sprite.play(current_animation)'''

func update_all_gladiators(data: Dictionary): 
	for id in data:
		for g in get_tree().get_nodes_in_group("gladiators"):
			if g.owner_id == id:
				#var stats = data[id]
				if g.is_multiplayer_authority():
					# Local node: update directly
					g.update_gladiator(data[id])
				else:
					# Remote node: call via RPC on owner
					g.rpc_id(g.get_multiplayer_authority(), "update_gladiator", data[id])

func update_gladiator_after_strategy(hit_chance_penalty, dodge_mod):
	glad_weapon1_category_skill = (glad_weapon1_category_skill-5)*hit_chance_penalty
	glad_weapon2_category_skill = (glad_weapon2_category_skill-5)*hit_chance_penalty
	
	var hit_base_per_lvl = -(1.6-float(level)/12) # Less penalty for too low weapon mastery in low levels
	var hit_skill_weight_1 = -(glad_weapon1_category_skill/(20*(0.8 + weight/400))) # Reduce hit chance with weight
	var hit_skill_weight_2 = -(glad_weapon2_category_skill/(20*(0.8 + weight/400))) # Reduce hit chance with weight
	var hit_curve_smoothness = 6+float(level)/4 # In low level, hit curve is more smooth (exponential part)
	var wep1_difficulty = 1 # vary around 1 -> higher makes it easier to handle
	var wep2_difficulty = 1 # vary around 1 -> higher makes it easier to handle
	
	if weapon2_can_block:
		hit_chance = [wep1_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_1**hit_curve_smoothness), 
					wep1_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_1**hit_curve_smoothness)]
	else: 
		hit_chance = [wep1_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_1**hit_curve_smoothness), 
					  wep2_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_2**hit_curve_smoothness)]
					
	avoidance = avoidance/dodge_mod
	dodge_chance = ((2*avoidance/((1.1+0.05*weight)**1.5))/200) / ((2*avoidance/(1.1+0.05*weight)/200)+1)
	
	
	recalculated_hit_chance = 1

@rpc("any_peer", "call_local")
func update_gladiator(data: Dictionary):
	#print("update_gladiator: " + str(data))
	var stance = data["stance"]
	var attack_type = data["attack_type"]
	strength = data["attributes"]["strength"]
	quickness = data["attributes"]["quickness"]
	crit_rating = data["attributes"]["crit_rating"]
	avoidance = data["attributes"]["avoidance"]
	max_health = data["attributes"]["health"]
	resilience = data["attributes"]["resilience"]
	endurance = data["attributes"]["endurance"]
	sword_mastery = data["attributes"]["sword_mastery"]
	axe_mastery = data["attributes"]["axe_mastery"]
	dagger_mastery = data["attributes"]["dagger_mastery"]
	hammer_mastery = data["attributes"]["hammer_mastery"]
	chain_mastery = data["attributes"]["chain_mastery"]
	
	var stance_dodge_mod = 1
	var stance_parry_block_mod = 1
	var stance_attack_speed_mod = 1
	var stance_crit_chance_mod = 1
	var stance_crit_multi_mod = 1
	var stance_endurance_mod = 1
	var attack_type_hit_mod = 1
	

	if stance == "defensive": 
		stance_dodge_mod = 1.15
		stance_parry_block_mod = 1.15
		stance_attack_speed_mod = 0.9
		stance_crit_chance_mod = 0.9
		stance_crit_multi_mod = 0.9
		
	elif stance == "offensive": 
		stance_dodge_mod = 0.9
		stance_parry_block_mod = 0.9
		stance_attack_speed_mod = 1.1
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
	
	
	level = data["level"]
	var weapon1_name = data["weapon1"].keys()[0]
	var weapon2_name = data["weapon2"].keys()[0]
	#print("asd data: " + str(data))
	#print("weapon1_name: " + str(weapon1_name))
	#print("weapon2_name: " + str(weapon2_name))
	weapon1_skill_req = data["weapon1"][weapon1_name]["skill_req"]
	weapon1_str_req = data["weapon1"][weapon1_name]["str_req"]
	weapon1_speed = data["weapon1"][weapon1_name]["speed"]
	weapon1_range = data["weapon1"][weapon1_name]["range"]
	weapon1_crit_chance = data["weapon1"][weapon1_name]["crit_chance"]
	weapon1_crit_multi = data["weapon1"][weapon1_name]["crit_multi"]
	
	weapon2_skill_req = data["weapon2"][weapon2_name]["skill_req"]
	weapon2_str_req = data["weapon2"][weapon2_name]["str_req"]
	weapon2_speed = data["weapon2"][weapon2_name]["speed"]
	weapon2_range = data["weapon2"][weapon2_name]["range"]
	weapon2_crit_chance = data["weapon2"][weapon2_name]["crit_chance"]
	weapon2_crit_multi = data["weapon2"][weapon2_name]["crit_multi"]
	
	armor_absorb = 1.0
	concede_threshold = data["concede"]
	#print(str(owner_id) + " concede: " + str(concede_threshold))
	#print("\ndata" + str(data) + "\n")
	
	gladiator_name = data.name
	#$Name.label_settings.set_font_color(data["color"])
	$Name.text = data.name
	$Name.add_theme_color_override("font_color", data.color)
	

	
	weight = data["weight"] - strength/40 # 100 str reduces weight with 2.5
	var endurance_weight = 1 - weight/(100+weight) # less endurance with more weight
	var endurance_decay = endurance/75 + 1
	endurance_sec = randf_range(2,3) + stance_endurance_mod*endurance*endurance_weight/endurance_decay
	print("Should live " + str(endurance_sec) + " seconds")
	weapon1 = data["weapon1"][weapon1_name]
	weapon2 = data["weapon2"][weapon2_name]
	weapon1_durability = data["weapon1"][weapon1_name]["durability"]
	weapon2_durability = data["weapon2"][weapon2_name]["durability"]
	
	shield_absorb = data["weapon2"][weapon2_name].get("absorb", -1)
	weapon1_can_parry = data["weapon1"][weapon1_name]["parry"]
	weapon2_can_parry = data["weapon2"][weapon2_name]["parry"]
	weapon2_can_block = data["weapon2"][weapon2_name]["block"]
	weapon_hands_to_carry = data["weapon1"][weapon1_name]["hands"]
	
	# Determine which weapon type is used, and set weapon_skill to players weapon_mastery
	var weapon1_category = data["weapon1"][weapon1_name].get("category", "")
	var weapon2_category = data["weapon2"][weapon2_name].get("category", "")
	glad_weapon1_category_skill = data["attributes"][weapon1_category + "_mastery"]
	glad_weapon2_category_skill = data["attributes"][weapon2_category + "_mastery"]
	
	var hit_base_per_lvl = -(1.6-float(level)/12) # Less penalty for too low weapon mastery in low levels
	var hit_skill_weight_1 = -(glad_weapon1_category_skill/(20*(0.8 + weight/400))) # Reduce hit chance with weight
	var hit_skill_weight_2 = -(glad_weapon2_category_skill/(20*(0.8 + weight/400))) # Reduce hit chance with weight
	var hit_curve_smoothness = 6+float(level)/4 # In low level, hit curve is more smooth (exponential part)
	var wep1_difficulty = 1 # vary around 1 -> higher makes it easier to handle
	var wep2_difficulty = 1 # vary around 1 -> higher makes it easier to handle
	
	if weapon2_can_block: 
		block_chance = stance_parry_block_mod*(0.8 - exp(-0.4*(2*glad_weapon2_category_skill / weapon2_skill_req-1.0)))
		crit_multi = [stance_crit_multi_mod*weapon1_crit_multi, stance_crit_multi_mod*weapon1_crit_multi]
		crit_chance = [stance_crit_chance_mod*weapon1_crit_chance*crit_rating/20.0, stance_crit_chance_mod*weapon1_crit_chance*crit_rating/20.0]
		hit_chance = [attack_type_hit_mod*(wep1_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_1**hit_curve_smoothness)), 
					attack_type_hit_mod*(wep1_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_1**hit_curve_smoothness))]
	else: 
		block_chance = 0
		crit_multi = [stance_crit_multi_mod*weapon1_crit_multi, stance_crit_multi_mod*weapon2_crit_multi]
		crit_chance = [stance_crit_chance_mod*weapon1_crit_chance*crit_rating/20.0, stance_crit_chance_mod*weapon2_crit_chance*crit_rating/20.0]
		hit_chance = [attack_type_hit_mod*(wep1_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_1**hit_curve_smoothness)), 
					  attack_type_hit_mod*(wep2_difficulty + 1/(hit_base_per_lvl + hit_skill_weight_2**hit_curve_smoothness))]
		
		#hit_chance = [(glad_weapon1_category_skill/weapon1_skill_req) - 0.20*glad_weapon1_category_skill/100, 
		#			(glad_weapon2_category_skill/weapon2_skill_req) - 0.20*glad_weapon2_category_skill/100]
 # === Damage calculations ===
	if weapon_hands_to_carry == 1: 
		attack_speed = stance_attack_speed_mod*(1/(weapon1_speed+weapon2_speed))/(log(10+sqrt(quickness))/log(10))
		
		var ratio1 = glad_weapon1_category_skill / weapon1_skill_req
		var ratio2 = glad_weapon2_category_skill / weapon2_skill_req
		parry_chance = [stance_parry_block_mod*(0.8 - exp(-0.4*(2*ratio1-1.0))), stance_parry_block_mod*(0.8 - exp(-0.4*(2*ratio2-1.0)))]
	else: 
		attack_speed = stance_attack_speed_mod*(1/(weapon1_speed))/(log(10+sqrt(quickness))/log(10))
		
		var ratio1 = glad_weapon1_category_skill / weapon1_skill_req
		parry_chance = [stance_parry_block_mod*(0.8 - exp(-0.4*(2*ratio1-1.0)))/2, stance_parry_block_mod*(0.8 - exp(-0.4*(2*ratio1-1.0)))/2]


	if weapon1_durability == 1:		# THIS MEANS EQUIPPING NO WEP IN SLOT
		crit_chance[0] = no_wep_crit_chance
		crit_multi[0] = no_wep_crit_multi
		hit_chance[0] = no_wep_hit_chance
	if weapon2_durability == 1:
		crit_chance[1] = no_wep_crit_chance
		crit_multi[1] = no_wep_crit_multi
		hit_chance[1] = no_wep_hit_chance

	move_speed = 500
	current_health = max_health
	armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
	dodge_chance = stance_dodge_mod*((2*avoidance/((1.1+0.05*weight)**1.5))/200) / ((2*avoidance/(1.1+0.05*weight)/200)+1)
	
	#dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
	seconds_to_live = endurance/3.0

	time_since_last_attack = 0.0
	next_attack_critical = false
	next_taken_hit_critical = false
	next_attack_weapon = 0

	current_health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar/HealthBarText.text = str(int(max_health))
