extends Node

# buy from shop -> add to inventory -> equip

@export var all_equipment = {
	"fist_weapon": {
		"unarmed": {
			"hands": 1,
			"min_dmg": 1.0, 
			"max_dmg": 3.0,
			"durability": INF,
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
			}
			}
			
	},
	"sword": {
		"simple_sword": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "sword",
			"weight": 3,
			"hands": 1,
			"min_dmg": 3.0, 
			"max_dmg": 6.0,
			"durability": 30,
			"str_req": 20,
			"skill_req": 30,
			"level": 3,
			"crit_chance": 0.1,
			"crit_multi": 1.2,
			"speed": 0.25,
			"range": 150,
			"parry": true,
			"block": false,
			"modifications": 
			{
				"weapon_skill": 5,
				"avoidance": 5
			}
		},
		"sturdy_blade": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "sword",
			"weight": 8,
			"hands": 2,
			"min_dmg": 10.0, 
			"max_dmg": 12.0,
			"durability": 50,
			"str_req": 40,
			"skill_req": 30,
			"level": 3,
			"crit_chance": 0.3,
			"crit_multi": 1.4,
			"speed": 0.25,
			"range": 150,
			"parry": true,
			"block": false,
			"modifications": 
			{
				"weapon_skill": 5,
				"avoidance": 5
			}
		}
	},
	
	"axe": {
		"light_axe": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "axe",
			"weight": 3,
			"hands": 1,
			"min_dmg": 4.0, 
			"max_dmg": 10.0,
			"durability": 30,
			"str_req": 30,
			"skill_req": 30,
			"level": 3,
			"crit_chance": 0.1,
			"crit_multi": 1.2,
			"speed": 0.25,
			"range": 150,
			"parry": true,
			"block": false,
			"modifications": 
			{
				"weapon_skill": 5,
				"avoidance": 5
			}
		},
		"copper_axe": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "axe",
			"weight": 4,
			"hands": 1,
			"min_dmg": 4.0, 
			"max_dmg": 10.0,
			"durability": 30,
			"str_req": 30,
			"skill_req": 30,
			"level": 3,
			"crit": 0.1,
			"speed": 0.25,
			"range": 150,
			"parry": true,
			"block": false,
			"attributes": 
			{
				"weapon_skill": 5,
				"avoidance": 5
			}
		}
	},

	"shield": {
		"wooden_buckler": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "shield",
			"weight": 3,
			"hands": 1,
			"min_dmg": 0.0, 
			"max_dmg": 0.0,
			"durability": 30,
			"absorb": 5,
			"str_req": 20,
			"skill_req": 30,
			"level": 3,
			"crit_chance": 0,
			"crit_multi": 0,
			"speed": 0,
			"range": 0,
			"parry": false,
			"block": true,
			"modifications": 
			{
				"weapon_skill": 5,
				"avoidance": 5
			}
		
			
		}
		
	}
}
