extends Node
class_name CombatManager

var damage_popup_scene = preload("res://DamagePopup.tscn") 

func deal_attack(attacker: Node, defender: Node, attacker_direction):
	
	var hit_chance = calculate_hit_chance(
		attacker.weapon_skill,
		attacker.weapon_req,
	)
	
	var dodge_success = 0	# default 0 means defender did not didge
	var hit_success = 1		# default 1 means attacker hit successfully
	var crit = 1
	
	if randf() > hit_chance:
		#print("%s missed the attack!" % [attacker.name])
		hit_success = 0
		# 🟡 Attacker missed → make them vulnerable to next hit
		attacker.next_taken_hit_critical = true
		# 🟢 Defender gets a guaranteed crit next time
		defender.next_attack_critical = true
			
		
	if randf() < attacker.crit_chance or attacker.next_attack_critical:
		crit = 2
		attacker.next_attack_critical = false  # reset after use

	var raw_damage = (randf_range(attacker.weapon_dmg_min, attacker.weapon_dmg_max)*crit+attacker.strength/15)
	
	if raw_damage > 0 and randf() < defender.dodge_chance:
		dodge_success = 1
		# 🟢 Defender dodged → gets next guaranteed crit
		defender.next_attack_critical = true
		# 🔴 Attacker is vulnerable → takes next hit as crit
		attacker.next_taken_hit_critical = true
		#print("%s dodged the attack from %s!" % [defender.name, attacker.name])
		#return
	
	var final_damage = hit_success*(1-dodge_success)*roundf(raw_damage - defender.armor)

	if defender.has_method("take_damage"):
		defender.take_damage(final_damage)
		damage_popup(final_damage, defender, hit_success, dodge_success, crit, attacker_direction)
		#print("%s dealt %.1d damage to %s" % [attacker.name, final_damage, defender.name])
		return true
	else:
		push_warning("Defender %s has no take_damage() method!" % defender.name)
		return false

func damage_popup(damage:float, defender: Node, hit_success, dodge_success, crit, attacker_direction):
	# Show damage popup
	var popup = damage_popup_scene.instantiate()
	
	#print("direction: %f" % [attacker_direction])
	popup.global_position = defender.global_position + Vector2(70*attacker_direction, -20)

	popup.show_damage(damage, hit_success, dodge_success, crit)
	get_tree().current_scene.add_child(popup)



func calculate_hit_chance(weapon_skill: float, weapon_req: float) -> float:
	
	var skill_factor = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
	
	return skill_factor
