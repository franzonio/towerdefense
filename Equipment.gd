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
			"modifiers": 
				{
				"attributes": {},
				"alterations": {}
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
			"modifiers": 
				{
				"attributes": 
					{
					"sword_mastery": 5,
					"avoidance": 5
					},
				"bonuses": {}
				
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
			"modifiers": 
				{
				"attributes": 
					{
					"sword_mastery": 5,
					"avoidance": 5
					},
				"bonuses": {}
				
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
			"modifiers": 
				{
				"attributes": 
					{
					"axe_mastery": 5,
					"avoidance": 5
					},
				"bonuses": {}
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
			"modifiers": 
				{
				"attributes": 
					{
					"axe_mastery": 5,
					"avoidance": 5
					},
				"bonuses": {}
				}
				}
	},

	"hammer": {
		"blunt_club": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "hammer",
			"weight": 4,
			"hands": 1,
			"min_dmg": 4.0, 
			"max_dmg": 5.0,
			"durability": 40,
			"str_req": 30,
			"skill_req": 25,
			"level": 3,
			"crit_chance": 0.1,
			"crit_multi": 1.15,
			"speed": 0.35,
			"range": 150,
			"parry": true,
			"block": false,
			"modifiers": 
				{
				"attributes": 
					{
					"hammer_mastery": 5,
					"health": 5
					},
				"bonuses": {}
				
			}
		}
	},
	
	"dagger": {
		"small_dagger": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "dagger",
			"weight": 2,
			"hands": 1,
			"min_dmg": 3.0, 
			"max_dmg": 5.0,
			"durability": 40,
			"str_req": 20,
			"skill_req": 30,
			"level": 3,
			"crit_chance": 0.2,
			"crit_multi": 1.3,
			"speed": 0.35,
			"range": 150,
			"parry": true,
			"block": false,
			"modifiers": 
				{
				"attributes": 
					{
					"dagger_mastery": 5,
					"quickness": 5,
					"crit_chance": 5
					},
				"bonuses": {}
				
			}
		}
	},
	
	"chain": {
		"thin_whip": {
			"price": 20,
			"stock": 250,
			"type": "weapon",
			"category": "chain",
			"weight": 3,
			"hands": 1,
			"min_dmg": 1.0, 
			"max_dmg": 7.0,
			"durability": 20,
			"str_req": 30,
			"skill_req": 20,
			"level": 3,
			"crit_chance": 0.15,
			"crit_multi": 1.5,
			"speed": 0.20,
			"range": 150,
			"parry": true,
			"block": false,
			"modifiers": 
				{
				"attributes": 
					{
					"chain_mastery": 5,
					"crit_multi": 5
					},
				"bonuses": {}
				
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
			"modifiers": 
				{
				"attributes": {
					"shield_mastery": 5,
					"avoidance": 5
				},
				"bonuses": {}
				}
			}
	}
}
