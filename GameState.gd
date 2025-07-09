extends Node
class_name GameState

var selected_race: String = ""
var gladiator_attributes: Dictionary = {}
var gladiator_alive: int = 0
var skeleton_alive: int = 0

#$Main/HUD.update_gold(new_gold_amount)
#$HUD.update_experience(new_xp)

const RACE_MODIFIERS = {
	"Orc": {
		"strength": 1.25,
		"weapon_skill": 1,
		"quickness": 0.7,
		"crit_rating": 1.2,
		"avoidance": 0.6,
		"health": 1.25,
		"resilience": 1.35,
		"endurance": 0.9
	},
	"Elf": {
		"strength": 0.7,
		"weapon_skill": 1.3,
		"quickness": 1.4,
		"crit_rating": 1.2,
		"avoidance": 1.55,
		"health": 0.8,
		"resilience": 0.7,
		"endurance": 1.35
	},
	"Human": {
		"strength": 1,
		"weapon_skill": 1.15,
		"quickness": 1.1,
		"crit_rating": 1,
		"avoidance": 1.1,
		"health": 1.1,
		"resilience": 1.1,
		"endurance": 1.2
	},
	"Troll": {
		"strength": 1.5,
		"weapon_skill": 0.8,
		"quickness": 0.6,
		"crit_rating": 1,
		"avoidance": 0.5,
		"health": 1.5,
		"resilience": 1.4,
		"endurance": 0.8
	}
}
