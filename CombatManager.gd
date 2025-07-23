extends Node
class_name CombatManager

var damage_popup_scene = preload("res://DamagePopup.tscn") 

func deal_attack(attacker: Node, defender: Node, weapon, hit_chance, crit_chance):

	var dodge_success = 0	# default 0 means defender did not didge
	var hit_success = 1		# default 1 means attacker hit successfully
	var crit = 1
	
	if randf() > hit_chance:
		hit_success = 0
		attacker.next_taken_hit_critical = true
		defender.next_attack_critical = true
			
		
	if randf() < crit_chance or attacker.next_attack_critical:
		crit = 2
		attacker.next_attack_critical = false  # reset after use

	var raw_damage = (randf_range(weapon["min_dmg"], weapon["max_dmg"])*crit+attacker.strength/15)
	
	if raw_damage > 0 and randf() < defender.dodge_chance:
		dodge_success = 1
		defender.next_attack_critical = true
		attacker.next_taken_hit_critical = true
	
	var final_damage = hit_success*(1-dodge_success)*roundf(raw_damage - defender.armor)

	if defender.has_method("receive_damage"):
		defender.rpc_id(defender.get_multiplayer_authority(), "receive_damage", final_damage, hit_success, dodge_success, crit)
		return true
	else:
		push_warning("Defender %s has no take_damage() method!" % defender.name)
		return false
		
