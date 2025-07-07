extends Node
class_name CombatManager

var damage_popup_scene = preload("res://DamagePopup.tscn") 

func deal_attack(attacker: Node, defender: Node):
	
	var hit_chance = calculate_hit_chance(
		attacker.weapon_skill,
		attacker.weapon_req,
	)
	var dodge_success = 0	# default 0 means defender did not didge
	var hit_success = 1		# default 1 means attacker hit successfully
	var crit = 1
	
	if randf() > hit_chance:
		print("%s missed the attack!" % [attacker.name])
		hit_success = 0
		#return false
		
	if randf() < attacker.crit_chance:
		crit = 2

	var raw_damage = hit_success*(randf_range(attacker.base_dmg_min, attacker.base_dmg_max)*crit+attacker.strength/15)
	
	if raw_damage > 0:
		# Check for dodge
		if randf() < defender.dodge_chance:
			dodge_success = 1
			print("%s dodged the attack from %s!" % [defender.name, attacker.name])
			#return
	
	var final_damage = (1-dodge_success)*roundf(raw_damage * (1.0 - clamp(defender.armor, 0, 1.0)))

	if defender.has_method("take_damage"):
		defender.take_damage(final_damage)
		damage_popup(final_damage, defender, hit_success, dodge_success)
		print("%s dealt %.1d damage to %s" % [attacker.name, final_damage, defender.name])
		return true
	else:
		push_warning("Defender %s has no take_damage() method!" % defender.name)
		return false

func damage_popup(damage:float, defender: Node, hit_success, dodge_success):
	# Show damage popup
	var popup = damage_popup_scene.instantiate()
	popup.global_position = defender.global_position + Vector2(randi_range(-8, 8), -20)

	popup.show_damage(damage, hit_success, dodge_success)
	get_tree().current_scene.add_child(popup)



func calculate_hit_chance(weapon_skill: float, weapon_req: float) -> float:
	
	var skill_factor = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
	
	return skill_factor
