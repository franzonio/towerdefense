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
		### LIGHT SWORD 1H ###
		"wooden_sword": {
			"price": 10, "stock": 25, "type": "weapon", "category": "sword", "weight": 3, "hands": 1,
			"min_dmg": 3.0, "max_dmg": 6.0, "durability": 30, "str_req": 20, "skill_req": 30, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"steel_sword": {
			"price": 60, "stock": 15, "type": "weapon", "category": "sword", "weight": 4, "hands": 1,
			"min_dmg": 6.0, "max_dmg": 10.0, "durability": 50, "str_req": 30, "skill_req": 40, "level": 3,
			"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.28, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"verdant_slicer": {
			"price": 150, "stock": 10, "type": "weapon", "category": "sword", "weight": 4, "hands": 1,
			"min_dmg": 9.0, "max_dmg": 15.0, "durability": 70, "str_req": 40, "skill_req": 50, "level": 6,
			"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.3, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"diamond_slicer": {
			"price": 300, "stock": 52323, "type": "weapon", "category": "sword", "weight": 5, "hands": 1,
			"min_dmg": 13.0, "max_dmg": 20.0, "durability": 100, "str_req": 50, "skill_req": 60, "level": 10,
			"crit_chance": 0.18, "crit_multi": 1.5, "speed": 0.32, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### HEAVY SWORD 1H ###
		"battleworn_blade": {
			"price": 10, "stock": 25, "type": "weapon", "category": "sword", "weight": 5, "hands": 1,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 30, "str_req": 20, "skill_req": 30, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"iron_blade": {
			"price": 60, "stock": 15, "type": "weapon", "category": "sword", "weight": 7, "hands": 1,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 50, "str_req": 30, "skill_req": 40, "level": 3,
			"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.28, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"emberized_slasher": {
			"price": 150, "stock": 10, "type": "weapon", "category": "sword", "weight": 8, "hands": 1,
			"min_dmg": 13.0, "max_dmg": 18.0, "durability": 70, "str_req": 40, "skill_req": 50, "level": 6,
			"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.3, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"crimson_slasher": {
			"price": 300, "stock": 52323, "type": "weapon", "category": "sword", "weight": 9, "hands": 1,
			"min_dmg": 18.0, "max_dmg": 25.0, "durability": 100, "str_req": 50, "skill_req": 60, "level": 10,
			"crit_chance": 0.18, "crit_multi": 1.5, "speed": 0.32, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### 2H SWORD ###
		"barbaric_claymore": {
			"price": 20, "stock": 250, "type": "weapon", "category": "sword", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"knightly_claymore": {
			"price": 20, "stock": 250, "type": "weapon", "category": "sword", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"draconic_edge": {
			"price": 20, "stock": 250, "type": "weapon", "category": "sword", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"demonic_edge": {
			"price": 20, "stock": 250, "type": "weapon", "category": "sword", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		}
	},
		
	
	
	"axe": {
		### LIGHT AXE 1H ###
		"wooden_hatchet": {
			"price": 10, "stock": 25, "type": "weapon", "category": "axe", "weight": 3, "hands": 1,
			"min_dmg": 3.0, "max_dmg": 6.0, "durability": 30, "str_req": 20, "skill_req": 30, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"steel_hatchet": {
			"price": 60, "stock": 15, "type": "weapon", "category": "axe", "weight": 4, "hands": 1,
			"min_dmg": 6.0, "max_dmg": 10.0, "durability": 50, "str_req": 30, "skill_req": 40, "level": 3,
			"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.28, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"verdant_splitter": {
			"price": 150, "stock": 10, "type": "weapon", "category": "axe", "weight": 4, "hands": 1,
			"min_dmg": 9.0, "max_dmg": 15.0, "durability": 70, "str_req": 40, "skill_req": 50, "level": 6,
			"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.3, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"diamond_splitter": {
			"price": 300, "stock": 52323, "type": "weapon", "category": "axe", "weight": 5, "hands": 1,
			"min_dmg": 13.0, "max_dmg": 20.0, "durability": 100, "str_req": 50, "skill_req": 60, "level": 10,
			"crit_chance": 0.18, "crit_multi": 1.5, "speed": 0.32, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### HEAVY AXE 1H ###
		"battleworn_axe": {
			"price": 10, "stock": 25, "type": "weapon", "category": "axe", "weight": 5, "hands": 1,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 30, "str_req": 20, "skill_req": 30, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"iron_axe": {
			"price": 60, "stock": 15, "type": "weapon", "category": "axe", "weight": 7, "hands": 1,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 50, "str_req": 30, "skill_req": 40, "level": 3,
			"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.28, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"emberized_cleaver": {
			"price": 150, "stock": 10, "type": "weapon", "category": "axe", "weight": 8, "hands": 1,
			"min_dmg": 13.0, "max_dmg": 18.0, "durability": 70, "str_req": 40, "skill_req": 50, "level": 6,
			"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.3, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"crimson_cleaver": {
			"price": 300, "stock": 52323, "type": "weapon", "category": "axe", "weight": 9, "hands": 1,
			"min_dmg": 18.0, "max_dmg": 25.0, "durability": 100, "str_req": 50, "skill_req": 60, "level": 10,
			"crit_chance": 0.18, "crit_multi": 1.5, "speed": 0.32, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### 2H AXE ###
		"barbaric_decapitator": {
			"price": 20, "stock": 250, "type": "weapon", "category": "axe", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"knightly_decapitator": {
			"price": 20, "stock": 250, "type": "weapon", "category": "axe", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"draconic_executioner": {
			"price": 20, "stock": 250, "type": "weapon", "category": "axe", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"demonic_executioner": {
			"price": 20, "stock": 250, "type": "weapon", "category": "axe", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		}
	},
	
	"mace": {
		### LIGHT MACE 1H ###
		"wooden_hammer": {
			"price": 10, "stock": 25, "type": "weapon", "category": "mace", "weight": 3, "hands": 1,
			"min_dmg": 3.0, "max_dmg": 6.0, "durability": 30, "str_req": 20, "skill_req": 30, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"steel_hammer": {
			"price": 60, "stock": 15, "type": "weapon", "category": "mace", "weight": 4, "hands": 1,
			"min_dmg": 6.0, "max_dmg": 10.0, "durability": 50, "str_req": 30, "skill_req": 40, "level": 3,
			"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.28, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"verdant_mallet": {
			"price": 150, "stock": 10, "type": "weapon", "category": "mace", "weight": 4, "hands": 1,
			"min_dmg": 9.0, "max_dmg": 15.0, "durability": 70, "str_req": 40, "skill_req": 50, "level": 6,
			"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.3, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"diamond_mallet": {
			"price": 300, "stock": 5, "type": "weapon", "category": "mace", "weight": 5, "hands": 1,
			"min_dmg": 13.0, "max_dmg": 20.0, "durability": 100, "str_req": 50, "skill_req": 60, "level": 10,
			"crit_chance": 0.18, "crit_multi": 1.5, "speed": 0.32, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### HEAVY MACE 1H ###
		"battleworn_mace": {
			"price": 10, "stock": 25, "type": "weapon", "category": "mace", "weight": 5, "hands": 1,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 30, "str_req": 20, "skill_req": 30, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"iron_mace": {
			"price": 60, "stock": 15, "type": "weapon", "category": "mace", "weight": 7, "hands": 1,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 50, "str_req": 30, "skill_req": 40, "level": 3,
			"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.28, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"emberized_crusher": {
			"price": 150, "stock": 10, "type": "weapon", "category": "mace", "weight": 8, "hands": 1,
			"min_dmg": 13.0, "max_dmg": 18.0, "durability": 70, "str_req": 40, "skill_req": 50, "level": 6,
			"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.3, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"crimson_crusher": {
			"price": 300, "stock": 52323, "type": "weapon", "category": "mace", "weight": 9, "hands": 1,
			"min_dmg": 18.0, "max_dmg": 25.0, "durability": 100, "str_req": 50, "skill_req": 60, "level": 10,
			"crit_chance": 0.18, "crit_multi": 1.5, "speed": 0.32, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### 2H MACE ###
		"barbaric_warhammer": {
			"price": 20, "stock": 250, "type": "weapon", "category": "mace", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"knightly_warhammer": {
			"price": 20, "stock": 250, "type": "weapon", "category": "mace", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"draconic_skullbasher": {
			"price": 20, "stock": 250, "type": "weapon", "category": "mace", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"demonic_skullbasher": {
			"price": 20, "stock": 250, "type": "weapon", "category": "mace", "weight": 8, "hands": 2,
			"min_dmg": 10.0,  "max_dmg": 12.0, "durability": 50, "str_req": 40, "skill_req": 30, "level": 3,
			"crit_chance": 0.3, "crit_multi": 1.4, "speed": 0.25, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		}
	},
		
	"stabbing": {
		### LIGHT STABBING 1H ###
		"wooden_dagger": {
			"price": 8, "stock": 30, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 2.0, "max_dmg": 5.0, "durability": 25, "str_req": 15, "skill_req": 25, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.3, "speed": 0.35, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"steel_dagger": {
			"price": 50, "stock": 20, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 40, "str_req": 25, "skill_req": 35, "level": 3,
			"crit_chance": 0.18, "crit_multi": 1.4, "speed": 0.38, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"verdant_shard": {
			"price": 140, "stock": 10, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 60, "str_req": 35, "skill_req": 45, "level": 6,
			"crit_chance": 0.2, "crit_multi": 1.5, "speed": 0.4, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"diamond_shard": {
			"price": 280, "stock": 5, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 12.0, "max_dmg": 18.0, "durability": 90, "str_req": 45, "skill_req": 55, "level": 10,
			"crit_chance": 0.22, "crit_multi": 1.6, "speed": 0.42, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
		### HEAVY STABBING 1H ###
		"battleworn_carver": {
			"price": 8, "stock": 30, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 2.0, "max_dmg": 5.0, "durability": 25, "str_req": 15, "skill_req": 25, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.3, "speed": 0.35, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"iron_carver": {
			"price": 50, "stock": 20, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 40, "str_req": 25, "skill_req": 35, "level": 3,
			"crit_chance": 0.18, "crit_multi": 1.4, "speed": 0.38, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"emberized_stiletto": {
			"price": 140, "stock": 10, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 60, "str_req": 35, "skill_req": 45, "level": 6,
			"crit_chance": 0.2, "crit_multi": 1.5, "speed": 0.4, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"crimson_stiletto": {
			"price": 280, "stock": 5, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 12.0, "max_dmg": 18.0, "durability": 90, "str_req": 45, "skill_req": 55, "level": 10,
			"crit_chance": 0.22, "crit_multi": 1.6, "speed": 0.42, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
		### STABBING 2H ###
		"barbaric_pike": {
			"price": 8, "stock": 30, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 2,
			"min_dmg": 2.0, "max_dmg": 5.0, "durability": 25, "str_req": 15, "skill_req": 25, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.3, "speed": 0.35, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"knightly_pike": {
			"price": 50, "stock": 20, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 2,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 40, "str_req": 25, "skill_req": 35, "level": 3,
			"crit_chance": 0.18, "crit_multi": 1.4, "speed": 0.38, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"draconic_trident": {
			"price": 140, "stock": 10, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 2,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 60, "str_req": 35, "skill_req": 45, "level": 6,
			"crit_chance": 0.2, "crit_multi": 1.5, "speed": 0.4, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"demonic_trident": {
			"price": 280, "stock": 5, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 2,
			"min_dmg": 12.0, "max_dmg": 18.0, "durability": 90, "str_req": 45, "skill_req": 55, "level": 10,
			"crit_chance": 0.22, "crit_multi": 1.6, "speed": 0.42, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 20, "quickness": 12 }, "bonuses": {} }
		}
	},
	
	"flagellation": {
		### LIGHT FLAGELLATION 1H ###
		"wooden_whip": {
			"price": 8, "stock": 30, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 2.0, "max_dmg": 5.0, "durability": 25, "str_req": 15, "skill_req": 25, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.3, "speed": 0.35, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"steel_whip": {
			"price": 50, "stock": 20, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 40, "str_req": 25, "skill_req": 35, "level": 3,
			"crit_chance": 0.18, "crit_multi": 1.4, "speed": 0.38, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"verdant_knout": {
			"price": 140, "stock": 10, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 60, "str_req": 35, "skill_req": 45, "level": 6,
			"crit_chance": 0.2, "crit_multi": 1.5, "speed": 0.4, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"diamond_knout": {
			"price": 280, "stock": 5, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 12.0, "max_dmg": 18.0, "durability": 90, "str_req": 45, "skill_req": 55, "level": 10,
			"crit_chance": 0.22, "crit_multi": 1.6, "speed": 0.42, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
					###### HEAVY FLAGELLATION 1H ######
		"battleworn_flail": {
			"price": 8, "stock": 30, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 2.0, "max_dmg": 5.0, "durability": 25, "str_req": 15, "skill_req": 25, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.3, "speed": 0.35, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"iron_flail": {
			"price": 50, "stock": 20, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 40, "str_req": 25, "skill_req": 35, "level": 3,
			"crit_chance": 0.18, "crit_multi": 1.4, "speed": 0.38, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"emberized_scourge": {
			"price": 140, "stock": 10, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 60, "str_req": 35, "skill_req": 45, "level": 6,
			"crit_chance": 0.2, "crit_multi": 1.5, "speed": 0.4, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"crimson_scourge": {
			"price": 280, "stock": 5, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 1,
			"min_dmg": 12.0, "max_dmg": 18.0, "durability": 90, "str_req": 45, "skill_req": 55, "level": 10,
			"crit_chance": 0.22, "crit_multi": 1.6, "speed": 0.42, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
					###### FLAGELLATION 2H ######
		"barbaric_chainflogger": {
			"price": 8, "stock": 30, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 2,
			"min_dmg": 2.0, "max_dmg": 5.0, "durability": 25, "str_req": 15, "skill_req": 25, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.3, "speed": 0.35, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"knightly_spikes": {
			"price": 50, "stock": 20, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 2,
			"min_dmg": 5.0, "max_dmg": 8.0, "durability": 40, "str_req": 25, "skill_req": 35, "level": 3,
			"crit_chance": 0.18, "crit_multi": 1.4, "speed": 0.38, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"draconic_disemboweler": {
			"price": 140, "stock": 10, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 2,
			"min_dmg": 8.0, "max_dmg": 13.0, "durability": 60, "str_req": 35, "skill_req": 45, "level": 6,
			"crit_chance": 0.2, "crit_multi": 1.5, "speed": 0.4, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"demonic_torturer": {
			"price": 280, "stock": 5, "type": "weapon", "category": "flagellation", "weight": 2, "hands": 2,
			"min_dmg": 12.0, "max_dmg": 18.0, "durability": 90, "str_req": 45, "skill_req": 55, "level": 10,
			"crit_chance": 0.22, "crit_multi": 1.6, "speed": 0.42, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 20, "quickness": 12 }, "bonuses": {} }
		}
	},
	
	"shield": {
					###### SHIELD LIGHT ######
		"wooden_guard": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"steel_guard": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"verdant_aegis": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"diamond_aegis": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
			
					###### SHIELD HEAVY ######
		"battleworn_wall": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"iron_wall": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"emberized_bulwark": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"crimson_bulwark": {
			"price": 20, "stock": 250, "type": "weapon", "category": "shield", "weight": 3, "hands": 1,
			"min_dmg": 0.0,  "max_dmg": 0.0, "durability": 30, "absorb": 5, "str_req": 20, "skill_req": 30,
			"level": 3, "crit_chance": 0, "crit_multi": 0, "speed": 0, "range": 0, "parry": false, "block": true,
			"modifiers": { "attributes": { "shield_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		}
	},
	
	### ARMOR ###
					###### CHEST ######
	"chest": {
		"leather_vest": {
			"price": 8, "stock": 250, "type": "armor", "category": "chest", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"tailored_vest": { 
			"price": 10, "stock": 250, "type": "armor", "category": "chest", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"garb_of_elven_silk": {
			"price": 18, "stock": 200, "type": "armor", "category": "chest", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"garb_of_sin": { 
			"price": 35,"stock": 150,"type": "armor","category": "chest","weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		"plate_cuirass": {
			"price": 8, "stock": 250, "type": "armor", "category": "chest", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"steelforged_cuirass": { 
			"price": 10, "stock": 250, "type": "armor", "category": "chest", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"carapace_of_kings": {
			"price": 18, "stock": 200, "type": "armor", "category": "chest", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"bloodsteel_carapace": { 
			"price": 35,"stock": 150,"type": "armor","category": "chest","weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
	},
					###### HEAD ######
	"head": {
		"leather_cap": {
			"price": 8, "stock": 250, "type": "armor", "category": "head", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"tailored_cap": { 
			"price": 10, "stock": 250, "type": "armor", "category": "head", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"hat_of_elven_silk": {
			"price": 18, "stock": 200, "type": "armor", "category": "head", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"hat_of_sin": { 
			"price": 35,"stock": 150,"type": "armor","category": "head","weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		"plate_helmet": {
			"price": 8, "stock": 250, "type": "armor", "category": "head", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"steelforged_helmet": { 
			"price": 10, "stock": 250, "type": "armor", "category": "head", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"barbute_of_kings": {
			"price": 18, "stock": 200, "type": "armor", "category": "head", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"bloodsteel_barbute": { 
			"price": 35,"stock": 150,"type": "armor","category": "head","weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		
	},
	
					###### SHOULDERS ######
	"shoulders": {
		"leather_shoulders": {
			"price": 8, "stock": 250, "type": "armor", "category": "shoulders", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"tailored_shoulders": { 
			"price": 10, "stock": 250, "type": "armor", "category": "shoulders", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"mantle_of_elven_silk": {
			"price": 18, "stock": 200, "type": "armor", "category": "shoulders", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"mantle_of_sin": { 
			"price": 35,"stock": 150,"type": "armor","category": "shoulders", "weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		"plate_spaulders": {
			"price": 8, "stock": 250, "type": "armor", "category": "shoulders", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"steelforged_spaulders": { 
			"price": 10, "stock": 250, "type": "armor", "category": "shoulders", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"pauldrons_of_kings": {
			"price": 18, "stock": 200, "type": "armor", "category": "shoulders", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"bloodsteel_pauldrons": { 
			"price": 35,"stock": 150,"type": "armor","category": "shoulders","weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
	},
					###### BELT ######
	"belt": {
		"leather_belt": {
			"price": 8, "stock": 250, "type": "armor", "category": "belt", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"tailored_belt": { 
			"price": 10, "stock": 250, "type": "armor", "category": "belt", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"strap_of_elven_silk": {
			"price": 18, "stock": 200, "type": "armor", "category": "belt", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"strap_of_sin": { 
			"price": 35,"stock": 150,"type": "armor","category": "belt","weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		"plate_waistguard": {
			"price": 8, "stock": 250, "type": "armor", "category": "belt", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"steelforged_waistguard": { 
			"price": 10, "stock": 250, "type": "armor", "category": "belt", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"girdle_of_kings": {
			"price": 18, "stock": 200, "type": "armor", "category": "belt", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"bloodsteel_girdle": { 
			"price": 35,"stock": 150,"type": "armor","category": "belt","weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
	},
	
					###### BOOTS ######
	"boots": {
		"leather_boots": {
			"price": 8, "stock": 250, "type": "armor", "category": "boots", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"tailored_boots": { 
			"price": 10, "stock": 250, "type": "armor", "category": "boots", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"treads_of_elven_silk": {
			"price": 18, "stock": 200, "type": "armor", "category": "boots", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"treads_of_sin": { 
			"price": 35,"stock": 150,"type": "armor","category": "boots", "weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		"plate_greaves": {
			"price": 8, "stock": 250, "type": "armor", "category": "boots", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"steelforged_greaves": { 
			"price": 10, "stock": 250, "type": "armor", "category": "boots", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"sabatons_of_kings": {
			"price": 18, "stock": 200, "type": "armor", "category": "boots", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"bloodsteel_sabatons": { 
			"price": 35,"stock": 150,"type": "armor","category": "boots", "weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
	},
	
					###### GLOVES ######
	"gloves": {
		"leather_gloves": {
			"price": 8, "stock": 250, "type": "armor", "category": "gloves", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"tailored_gloves": { 
			"price": 10, "stock": 250, "type": "armor", "category": "gloves", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"hands_of_elven_silk": {
			"price": 18, "stock": 200, "type": "armor", "category": "gloves", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"hands_of_sin": { 
			"price": 35,"stock": 150,"type": "armor","category": "gloves", "weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		"plate_gauntlets": {
			"price": 8, "stock": 250, "type": "armor", "category": "gloves", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"steelforged_gauntlets": { 
			"price": 10, "stock": 250, "type": "armor", "category": "gloves", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"grips_of_kings": {
			"price": 18, "stock": 200, "type": "armor", "category": "gloves", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"bloodsteel_grips": { 
			"price": 35,"stock": 150,"type": "armor","category": "gloves", "weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
	},
	
					###### LEGS ######
	"legs": {
		"leather_pantaloons": {
			"price": 8, "stock": 250, "type": "armor", "category": "legs", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"tailored_pantaloons": { 
			"price": 10, "stock": 250, "type": "armor", "category": "legs", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"legwraps_of_elven_silk": {
			"price": 18, "stock": 200, "type": "armor", "category": "legs", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"legwraps_of_sin": { 
			"price": 35,"stock": 150,"type": "armor","category": "legs", "weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
		
		"plate_legs": {
			"price": 8, "stock": 250, "type": "armor", "category": "legs", "weight": 1, "absorb": 1,
			"str_req": 10, "level": 1, 
			"modifiers": { "attributes": { "quickness": 3, "avoidance": 2 }, "bonuses": {} }
		},
		
		"steelforged_legs": { 
			"price": 10, "stock": 250, "type": "armor", "category": "legs", "weight": 1, "absorb": 2,
			"str_req": 20, "level": 2,
			"modifiers":  { "attributes": {}, "bonuses": {} }
		},
		
		"legguards_of_kings": {
			"price": 18, "stock": 200, "type": "armor", "category": "legs", "weight": 2, "absorb": 2,
			"str_req": 25, "level": 3,
			"modifiers": { "attributes": { "avoidance": 3, "crit_rating": 2 }, "bonuses": {} }
		},

		"bloodsteel_legguards": { 
			"price": 35,"stock": 150,"type": "armor","category": "legs", "weight": 5,"absorb": 4,
			"str_req": 40, "level": 5,
			"modifiers": { "attributes": { "endurance": 4, "resilience": 2 }, "bonuses": {} }
		},
	},

	"rings": {
		"ring_of_stone": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "ring", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "resilience": 5, "endurance": 5, "health": 5 }, "bonuses": {} }
		},
		
		"ring_of_noble_tears": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "ring", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "avoidance": 8, "endurance": 8, "health": 8 }, "bonuses": {} }
		},
		
		"ring_of_royals": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "ring", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "avoidance": 12, "quickness": 12, "health": 12 }, "bonuses": {} }
		},
		
		"ring_of_the_emperor": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "ring", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "crit_rating": 17, "quickness": 17, "health": 17 }, "bonuses": {} }
		},
	},
	
	"amulet": {	
		"amulet_of_stone": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "amulet", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "resilience": 5, "endurance": 5, "health": 5 }, "bonuses": {} }
		},
		
		"amulet_of_noble_tears": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "amulet", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "avoidance": 8, "endurance": 8, "health": 8 }, "bonuses": {} }
		},
		
		"amulet_of_royals": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "amulet", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "avoidance": 12, "quickness": 12, "health": 12 }, "bonuses": {} }
		},
		
		"amulet_of_the_emperor": {
			"price": 25, "stock": 250, "type": "jewellery", "category": "amulet", "weight": 0,
			"absorb": 0, "str_req": 0, "level": 1,
			"modifiers": { "attributes": { "crit_rating": 17, "quickness": 17, "health": 17 }, "bonuses": {} }
		},
	}
		
		
		
	
}
	
