extends Node

# buy from shop -> add to inventory -> equip

@export var all_equipment = {
	"sword": {
		"simple_sword": {
			"price": 20,
			"stock": 500,
			"type": "weapon",
			"hands": 1,
			"min_dmg": 3, 
			"max_dmg": 6,
			"durability": 30,
			"str_req": 20,
			"skill_req": 30,
			"lvl": 1,
			"crit": 0.1,
			"speed": 1,
			"range": 150,
			"parry:": true,
			"block": false,
			"attributes": 
			{
				"weapon_skill": 0,
				"avoidance": 0
			}
		},
		"iron_sword": {
			"stock": 20,
			"type": "weapon",
			"hands": 1,
			"min_dmg": 4, 
			"max_dmg": 7,
			"durability": 40,
			"req": 30,
			"lvl": 1,
			"crit": 0.1,
			"speed": 1,
			"range": 150,
			"parry:": true,
			"block": false,
			"attributes": 
			{
				"weapon_skill": 0,
				"avoidance": 5
			}
		
		}
	},
	
	"axe": {
		"light_axe": {
			"stock": 20,
			"type": "weapon",
			"hands": 1,
			"min_dmg": 2, 
			"max_dmg": 6,
			"durability": 30,
			"req": 20,
			"lvl": 1,
			"crit": 0.1,
			"speed": 1,
			"range": 150,
			"parry:": true,
			"block": false,
			"attributes": 
			{
				"weapon_skill": 0,
				"avoidance": 0
			}
		},
		"copper_axe": {
			"stock": 20,
			"type": "weapon",
			"hands": 1,
			"min_dmg": 4, 
			"max_dmg": 8,
			"durability": 40,
			"req": 30,
			"lvl": 1,
			"crit": 0.1,
			"speed": 1,
			"range": 150,
			"parry:": true,
			"block": false,
			"attributes": 
			{
				"weapon_skill": 0,
				"avoidance": 5
			}
		
		}
	},
}
