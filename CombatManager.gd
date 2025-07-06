extends Node
class_name CombatManager



func deal_attack(attacker: Node, defender: Node, 
				weapon_req: float, weapon_weight: float, crit_chance: float, 
				strength: float, base_dmg_min: int, base_dmg_max: int,
				dodge_chance: float):
	
	var hit_chance = calculate_hit_chance(
		attacker.weapon_skill,
		attacker.weapon_req,
	)
	var hit_success = 1
	var crit = 1
	
	if randf() > hit_chance:
		print("%s missed the attack!" % [attacker.name])
		hit_success = 0
		return false
		
	if randf() < crit_chance:
		crit = 2

	var raw_damage = hit_success*(randf_range(attacker.base_dmg_min, attacker.base_dmg_max)*crit+attacker.strength/15)
	
	if raw_damage > 0:
		# Check for dodge
		if randf() < defender.dodge_chance:
			print("%s dodged the attack from %s!" % [defender.name, attacker.name])
			return
	
	var final_damage = roundf(raw_damage * (1.0 - clamp(defender.armor, 0, 1.0)))

	if defender.has_method("take_damage"):
		defender.take_damage(final_damage)
		print("%s dealt %.1d damage to %s" % [attacker.name, final_damage, defender.name])
		return true
	else:
		push_warning("Defender %s has no take_damage() method!" % defender.name)
		return false



func calculate_hit_chance(weapon_skill: float, weapon_req: float) -> float:
	
	var skill_factor = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
	
	return skill_factor
