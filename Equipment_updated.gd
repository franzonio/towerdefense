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
			"price": 5, "stock": 8, "type": "weapon", "category": "sword", "weight": 4, "hands": 1,
			"min_dmg": 3, "max_dmg": 6, "durability": 42, "str_req": 35, "skill_req": 55, "level": 1,
			"crit_chance": 0.2, "crit_multi": 1.25, "speed": 0.55, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"steel_sword": {
			"price": 8, "stock": 6, "type": "weapon", "category": "sword", "weight": 5, "hands": 1,
			"min_dmg": 7, "max_dmg": 11, "durability": 70, "str_req": 45, "skill_req": 65, "level": 4,
			"crit_chance": 0.2, "crit_multi": 1.25, "speed": 0.55, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"verdant_slicer": {
			"price": 12, "stock": 4, "type": "weapon", "category": "sword", "weight": 6, "hands": 1,
			"min_dmg": 11, "max_dmg": 16, "durability": 106, "str_req": 55, "skill_req": 85, "level": 7,
			"crit_chance": 0.25, "crit_multi": 1.3, "speed": 0.6, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"diamond_slicer": {
			"price": 16, "stock": 2, "type": "weapon", "category": "sword", "weight": 6, "hands": 1,
			"min_dmg": 17, "max_dmg": 22, "durability": 142, "str_req": 65, "skill_req": 110, "level": 10,
			"crit_chance": 0.25, "crit_multi": 1.3, "speed": 0.6, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### HEAVY SWORD 1H ###
		"battleworn_blade": {
			"price": 5, "stock": 8, "type": "weapon", "category": "sword", "weight": 6, "hands": 1,
			"min_dmg": 4, "max_dmg": 7, "durability": 40, "str_req": 60, "skill_req": 30, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.2, "speed": 0.5, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"iron_blade": {
			"price": 8, "stock": 6, "type": "weapon", "category": "sword", "weight": 7, "hands": 1,
			"min_dmg": 8, "max_dmg": 13, "durability": 60, "str_req": 70, "skill_req": 40, "level": 4,
			"crit_chance": 0.15, "crit_multi": 1.2, "speed": 0.5, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"emberized_slasher": {
			"price": 12, "stock": 4, "type": "weapon", "category": "sword", "weight": 8, "hands": 1,
			"min_dmg": 14, "max_dmg": 18, "durability": 94, "str_req": 90, "skill_req": 50, "level": 7,
			"crit_chance": 0.2, "crit_multi": 1.25, "speed": 0.55, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"crimson_slasher": {
			"price": 16, "stock": 2, "type": "weapon", "category": "sword", "weight": 9, "hands": 1,
			"min_dmg": 20, "max_dmg": 25, "durability": 128, "str_req": 110, "skill_req": 65, "level": 10,
			"crit_chance": 0.2, "crit_multi": 1.25, "speed": 0.55, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### 2H SWORD ###
		"barbaric_claymore": {
			"price": 8, "stock": 8, "type": "weapon", "category": "sword", "weight": 10, "hands": 2,
			"min_dmg": 8,  "max_dmg": 13, "durability": 55, "str_req": 60, "skill_req": 40, "level": 1,
			"crit_chance": 0.2, "crit_multi": 1.25, "speed": 0.55, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"knightly_claymore": {
			"price": 12, "stock": 6, "type": "weapon", "category": "sword", "weight": 12, "hands": 2,
			"min_dmg": 17,  "max_dmg": 23, "durability": 82, "str_req": 75, "skill_req": 50, "level": 4,
			"crit_chance": 0.2, "crit_multi": 1.25, "speed": 0.55, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"draconic_edge": {
			"price": 18, "stock": 4, "type": "weapon", "category": "sword", "weight": 14, "hands": 2,
			"min_dmg": 25,  "max_dmg": 34, "durability": 118, "str_req": 100, "skill_req": 60, "level": 7,
			"crit_chance": 0.25, "crit_multi": 1.3, "speed": 0.6, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"demonic_edge": {
			"price": 24, "stock": 2, "type": "weapon", "category": "sword", "weight": 15, "hands": 2,
			"min_dmg": 36,  "max_dmg": 46, "durability": 152, "str_req": 115, "skill_req": 80, "level": 10,
			"crit_chance": 0.25, "crit_multi": 1.3, "speed": 0.6, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "sword_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		}
	},
		
	
	
	"axe": {
		### LIGHT AXE 1H ###
		"wooden_hatchet": {
			"price": 5, "stock": 8, "type": "weapon", "category": "axe", "weight": 5, "hands": 1,
			"min_dmg": 3, "max_dmg": 8, "durability": 38, "str_req": 40, "skill_req": 55, "level": 1,
			"crit_chance": 0.2, "crit_multi": 1.3, "speed": 0.5, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"steel_hatchet": {
			"price": 8, "stock": 6, "type": "weapon", "category": "axe", "weight": 6, "hands": 1,
			"min_dmg": 7, "max_dmg": 13, "durability": 64, "str_req": 50, "skill_req": 65, "level": 4,
			"crit_chance": 0.2, "crit_multi": 1.3, "speed": 0.5, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"verdant_splitter": {
			"price": 12, "stock": 4, "type": "weapon", "category": "axe", "weight": 7, "hands": 1,
			"min_dmg": 12, "max_dmg": 18, "durability": 88, "str_req": 60, "skill_req": 85, "level": 7,
			"crit_chance": 0.25, "crit_multi": 1.35, "speed": 0.55, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"diamond_splitter": {
			"price": 16, "stock": 2, "type": "weapon", "category": "axe", "weight": 7, "hands": 1,
			"min_dmg": 18, "max_dmg": 26, "durability": 124, "str_req": 70, "skill_req": 115, "level": 10,
			"crit_chance": 0.25, "crit_multi": 1.35, "speed": 0.55, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### HEAVY AXE 1H ###
		"battleworn_axe": {
			"price": 5, "stock": 8, "type": "weapon", "category": "axe", "weight": 7, "hands": 1,
			"min_dmg": 4, "max_dmg": 9, "durability": 36, "str_req": 65, "skill_req": 30, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.25, "speed": 0.45, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"iron_axe": {
			"price": 8, "stock": 6, "type": "weapon", "category": "axe", "weight": 8, "hands": 1,
			"min_dmg": 8, "max_dmg": 16, "durability": 58, "str_req": 75, "skill_req": 40, "level": 4,
			"crit_chance": 0.15, "crit_multi": 1.25, "speed": 0.45, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"emberized_cleaver": {
			"price": 12, "stock": 4, "type": "weapon", "category": "axe", "weight": 10, "hands": 1,
			"min_dmg": 14, "max_dmg": 21, "durability": 80, "str_req": 95, "skill_req": 50, "level": 7,
			"crit_chance": 0.2, "crit_multi": 1.3, "speed": 0.5, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"crimson_cleaver": {
			"price": 16, "stock": 2, "type": "weapon", "category": "axe", "weight": 11, "hands": 1,
			"min_dmg": 22, "max_dmg": 30, "durability": 114, "str_req": 115, "skill_req": 70, "level": 10,
			"crit_chance": 0.2, "crit_multi": 1.3, "speed": 0.5, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### 2H AXE ###
		"barbaric_decapitator": {
			"price": 8, "stock": 8, "type": "weapon", "category": "axe", "weight": 12, "hands": 2,
			"min_dmg": 7,  "max_dmg": 16, "durability": 48, "str_req": 70, "skill_req": 35, "level": 1,
			"crit_chance": 0.2, "crit_multi": 1.3, "speed": 0.5, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"knightly_decapitator": {
			"price": 12, "stock": 6, "type": "weapon", "category": "axe", "weight": 14, "hands": 2,
			"min_dmg": 16,  "max_dmg": 28, "durability": 70, "str_req": 85, "skill_req": 45, "level": 4,
			"crit_chance": 0.2, "crit_multi": 1.3, "speed": 0.5, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"draconic_executioner": {
			"price": 18, "stock": 4, "type": "weapon", "category": "axe", "weight": 16, "hands": 2,
			"min_dmg": 24,  "max_dmg": 40, "durability": 92, "str_req": 105, "skill_req": 60, "level": 7,
			"crit_chance": 0.25, "crit_multi": 1.35, "speed": 0.55, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"demonic_executioner": {
			"price": 24, "stock": 2, "type": "weapon", "category": "axe", "weight": 17, "hands": 2,
			"min_dmg": 34,  "max_dmg": 55, "durability": 128, "str_req": 125, "skill_req": 80, "level": 10,
			"crit_chance": 0.25, "crit_multi": 1.35, "speed": 0.55, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		}
	},
	
	"mace": {
		### LIGHT MACE 1H ###
		"wooden_hammer": {
			"price": 5, "stock": 8, "type": "weapon", "category": "mace", "weight": 6, "hands": 1,
			"min_dmg": 5, "max_dmg": 8, "durability": 40, "str_req": 45, "skill_req": 45, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.15, "speed": 0.45, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"steel_hammer": {
			"price": 8, "stock": 6, "type": "weapon", "category": "mace", "weight": 7, "hands": 1,
			"min_dmg": 11, "max_dmg": 14, "durability": 68, "str_req": 55, "skill_req": 55, "level": 4,
			"crit_chance": 0.1, "crit_multi": 1.15, "speed": 0.45, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"verdant_mallet": {
			"price": 12, "stock": 4, "type": "weapon", "category": "mace", "weight": 8, "hands": 1,
			"min_dmg": 16, "max_dmg": 21, "durability": 102, "str_req": 70, "skill_req": 70, "level": 7,
			"crit_chance": 0.15, "crit_multi": 1.15, "speed": 0.5, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"diamond_mallet": {
			"price": 16, "stock": 2, "type": "weapon", "category": "mace", "weight": 9, "hands": 1,
			"min_dmg": 23, "max_dmg": 31, "durability": 140, "str_req": 80, "skill_req": 80, "level": 10,
			"crit_chance": 0.15, "crit_multi": 1.15, "speed": 0.5, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### HEAVY MACE 1H ###
		"battleworn_mace": {
			"price": 5, "stock": 8, "type": "weapon", "category": "mace", "weight": 8, "hands": 1,
			"min_dmg": 7, "max_dmg": 10, "durability": 38, "str_req": 60, "skill_req": 30, "level": 1,
			"crit_chance": 0.05, "crit_multi": 1.1, "speed": 0.4, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"iron_mace": {
			"price": 8, "stock": 6, "type": "weapon", "category": "mace", "weight": 10, "hands": 1,
			"min_dmg": 13, "max_dmg": 17, "durability": 62, "str_req": 70, "skill_req": 40, "level": 4,
			"crit_chance": 0.05, "crit_multi": 1.1, "speed": 0.4, "range": 160, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 10, "avoidance": 7 }, "bonuses": {} }
		},
		"emberized_crusher": {
			"price": 12, "stock": 4, "type": "weapon", "category": "mace", "weight": 12, "hands": 1,
			"min_dmg": 18, "max_dmg": 25, "durability": 94, "str_req": 85, "skill_req": 55, "level": 7,
			"crit_chance": 0.1, "crit_multi": 1.1, "speed": 0.45, "range": 170, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 15, "avoidance": 10 }, "bonuses": {} }
		},
		"crimson_crusher": {
			"price": 16, "stock": 2, "type": "weapon", "category": "mace", "weight": 14, "hands": 1,
			"min_dmg": 28, "max_dmg": 36, "durability": 130, "str_req": 105, "skill_req": 65, "level": 10,
			"crit_chance": 0.1, "crit_multi": 1.1, "speed": 0.45, "range": 180, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 20, "avoidance": 12 }, "bonuses": {} }
		},
		
		### 2H MACE ###
		"barbaric_warhammer": {
			"price": 8, "stock": 8, "type": "weapon", "category": "mace", "weight": 18, "hands": 2,
			"min_dmg": 11,  "max_dmg": 17, "durability": 52, "str_req": 75, "skill_req": 30, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.1, "speed": 0.45, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"knightly_warhammer": {
			"price": 12, "stock": 6, "type": "weapon", "category": "mace", "weight": 20, "hands": 2,
			"min_dmg": 23,  "max_dmg": 31, "durability": 74, "str_req": 85, "skill_req": 40, "level": 4,
			"crit_chance": 0.1, "crit_multi": 1.1, "speed": 0.45, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"draconic_skullbasher": {
			"price": 18, "stock": 4, "type": "weapon", "category": "mace", "weight": 22, "hands": 2,
			"min_dmg": 35,  "max_dmg": 43, "durability": 109, "str_req": 105, "skill_req": 55, "level": 7,
			"crit_chance": 0.15, "crit_multi": 1.15, "speed": 0.5, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		},
		"demonic_skullbasher": {
			"price": 24, "stock": 2, "type": "weapon", "category": "mace", "weight": 24, "hands": 2,
			"min_dmg": 49,  "max_dmg": 59, "durability": 144, "str_req": 135, "skill_req": 65, "level": 10,
			"crit_chance": 0.15, "crit_multi": 1.15, "speed": 0.5, "range": 150, "parry": true, "block": false,
			"modifiers": { "attributes": { "mace_mastery": 5, "avoidance": 5 }, "bonuses": {} }
		}
	},
		
	"stabbing": {
		### LIGHT STABBING 1H ###
		"wooden_dagger": {
			"price": 5, "stock": 8, "type": "weapon", "category": "stabbing", "weight": 2, "hands": 1,
			"min_dmg": 3, "max_dmg": 4, "durability": 50, "str_req": 30, "skill_req": 55, "level": 1,
			"crit_chance": 0.3, "crit_multi": 1.25, "speed": 0.6, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"steel_dagger": {
			"price": 8, "stock": 6, "type": "weapon", "category": "stabbing", "weight": 3, "hands": 1,
			"min_dmg": 7, "max_dmg": 9, "durability": 76, "str_req": 40, "skill_req": 65, "level": 4,
			"crit_chance": 0.3, "crit_multi": 1.25, "speed": 0.6, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"verdant_shard": {
			"price": 12, "stock": 4, "type": "weapon", "category": "stabbing", "weight": 4, "hands": 1,
			"min_dmg": 11, "max_dmg": 13, "durability": 114, "str_req": 50, "skill_req": 85, "level": 7,
			"crit_chance": 0.35, "crit_multi": 1.3, "speed": 0.65, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"diamond_shard": {
			"price": 16, "stock": 2, "type": "weapon", "category": "stabbing", "weight": 4, "hands": 1,
			"min_dmg": 16, "max_dmg": 18, "durability": 150, "str_req": 60, "skill_req": 110, "level": 10,
			"crit_chance": 0.35, "crit_multi": 1.3, "speed": 0.65, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
		### HEAVY STABBING 1H ###
		"battleworn_carver": {
			"price": 5, "stock": 8, "type": "weapon", "category": "stabbing", "weight": 3, "hands": 1,
			"min_dmg": 4, "max_dmg": 5, "durability": 44, "str_req": 50, "skill_req": 35, "level": 1,
			"crit_chance": 0.2, "crit_multi": 1.2, "speed": 0.55, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"iron_carver": {
			"price": 8, "stock": 6, "type": "weapon", "category": "stabbing", "weight": 4, "hands": 1,
			"min_dmg": 8, "max_dmg": 11, "durability": 66, "str_req": 65, "skill_req": 40, "level": 4,
			"crit_chance": 0.2, "crit_multi": 1.2, "speed": 0.55, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"emberized_stiletto": {
			"price": 12, "stock": 4, "type": "weapon", "category": "stabbing", "weight": 5, "hands": 1,
			"min_dmg": 13, "max_dmg": 15, "durability": 102, "str_req": 85, "skill_req": 50, "level": 7,
			"crit_chance": 0.25, "crit_multi": 1.25, "speed": 0.6, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"crimson_stiletto": {
			"price": 16, "stock": 2, "type": "weapon", "category": "stabbing", "weight": 5, "hands": 1,
			"min_dmg": 18, "max_dmg": 22, "durability": 138, "str_req": 105, "skill_req": 65, "level": 10,
			"crit_chance": 0.25, "crit_multi": 1.25, "speed": 0.6, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
		### STABBING 2H ###
		"barbaric_pike": {
			"price": 8, "stock": 8, "type": "weapon", "category": "stabbing", "weight": 6, "hands": 2,
			"min_dmg": 8, "max_dmg": 10, "durability": 52, "str_req": 55, "skill_req": 40, "level": 1,
			"crit_chance": 0.25, "crit_multi": 1.3, "speed": 0.6, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"knightly_pike": {
			"price": 12, "stock": 6, "type": "weapon", "category": "stabbing", "weight": 7, "hands": 2,
			"min_dmg": 16, "max_dmg": 19, "durability": 78, "str_req": 70, "skill_req": 50, "level": 4,
			"crit_chance": 0.25, "crit_multi": 1.3, "speed": 0.6, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"draconic_trident": {
			"price": 18, "stock": 4, "type": "weapon", "category": "stabbing", "weight": 8, "hands": 2,
			"min_dmg": 24, "max_dmg": 28, "durability": 114, "str_req": 95, "skill_req": 60, "level": 7,
			"crit_chance": 0.3, "crit_multi": 1.35, "speed": 0.65, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"demonic_trident": {
			"price": 24, "stock": 2, "type": "weapon", "category": "stabbing", "weight": 9, "hands": 2,
			"min_dmg": 34, "max_dmg": 39, "durability": 148, "str_req": 110, "skill_req": 80, "level": 10,
			"crit_chance": 0.3, "crit_multi": 1.35, "speed": 0.65, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "stabbing_mastery": 20, "quickness": 12 }, "bonuses": {} }
		}
	},
	
	"flagellation": {
		### LIGHT FLAGELLATION 1H ###
		"wooden_whip": {
			"price": 5, "stock": 8, "type": "weapon", "category": "flagellation", "weight": 5, "hands": 1,
			"min_dmg": 2, "max_dmg": 13, "durability": 32, "str_req": 35, "skill_req": 55, "level": 1,
			"crit_chance": 0.2, "crit_multi": 1.45, "speed": 0.4, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"steel_whip": {
			"price": 8, "stock": 6, "type": "weapon", "category": "flagellation", "weight": 6, "hands": 1,
			"min_dmg": 5, "max_dmg": 21, "durability": 50, "str_req": 45, "skill_req": 65, "level": 4,
			"crit_chance": 0.2, "crit_multi": 1.6, "speed": 0.4, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"verdant_knout": {
			"price": 12, "stock": 4, "type": "weapon", "category": "flagellation", "weight": 7, "hands": 1,
			"min_dmg": 8, "max_dmg": 30, "durability": 68, "str_req": 60, "skill_req": 80, "level": 7,
			"crit_chance": 0.25, "crit_multi": 1.75, "speed": 0.45, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"diamond_knout": {
			"price": 16, "stock": 2, "type": "weapon", "category": "flagellation", "weight": 8, "hands": 1,
			"min_dmg": 10, "max_dmg": 42, "durability": 86, "str_req": 70, "skill_req": 90, "level": 10,
			"crit_chance": 0.25, "crit_multi": 1.9, "speed": 0.45, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
					###### HEAVY FLAGELLATION 1H ######
		"battleworn_flail": {
			"price": 5, "stock": 8, "type": "weapon", "category": "flagellation", "weight": 9, "hands": 1,
			"min_dmg": 6, "max_dmg": 14, "durability": 28, "str_req": 55, "skill_req": 35, "level": 1,
			"crit_chance": 0.1, "crit_multi": 1.25, "speed": 0.35, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"iron_flail": {
			"price": 8, "stock": 6, "type": "weapon", "category": "flagellation", "weight": 11, "hands": 1,
			"min_dmg": 11, "max_dmg": 23, "durability": 46, "str_req": 70, "skill_req": 40, "level": 4,
			"crit_chance": 0.1, "crit_multi": 1.35, "speed": 0.35, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"emberized_scourge": {
			"price": 12, "stock": 4, "type": "weapon", "category": "flagellation", "weight": 13, "hands": 1,
			"min_dmg": 16, "max_dmg": 35, "durability": 62, "str_req": 90, "skill_req": 50, "level": 7,
			"crit_chance": 0.15, "crit_multi": 1.45, "speed": 0.4, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"crimson_scourge": {
			"price": 16, "stock": 2, "type": "weapon", "category": "flagellation", "weight": 15, "hands": 1,
			"min_dmg": 19, "max_dmg": 51, "durability": 80, "str_req": 100, "skill_req": 60, "level": 10,
			"crit_chance": 0.15, "crit_multi": 1.55, "speed": 0.4, "range": 130, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 20, "quickness": 12 }, "bonuses": {} }
		},
		
					###### FLAGELLATION 2H ######
		"barbaric_chainflogger": {
			"price": 8, "stock": 8, "type": "weapon", "category": "flagellation", "weight": 16, "hands": 2,
			"min_dmg": 9, "max_dmg": 24, "durability": 38, "str_req": 80, "skill_req": 35, "level": 1,
			"crit_chance": 0.15, "crit_multi": 1.35, "speed": 0.4, "range": 100, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 5, "quickness": 5 }, "bonuses": {} }
		},
		"knightly_spikes": {
			"price": 12, "stock": 6, "type": "weapon", "category": "flagellation", "weight": 22, "hands": 2,
			"min_dmg": 13, "max_dmg": 47, "durability": 52, "str_req": 90, "skill_req": 40, "level": 4,
			"crit_chance": 0.15, "crit_multi": 1.45, "speed": 0.4, "range": 110, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 10, "quickness": 7 }, "bonuses": {} }
		},
		"draconic_disemboweler": {
			"price": 18, "stock": 4, "type": "weapon", "category": "flagellation", "weight": 26, "hands": 2,
			"min_dmg": 19, "max_dmg": 63, "durability": 70, "str_req": 110, "skill_req": 50, "level": 7,
			"crit_chance": 0.2, "crit_multi": 1.5, "speed": 0.45, "range": 120, "parry": false, "block": false,
			"modifiers": { "attributes": { "flagellation_mastery": 15, "quickness": 10 }, "bonuses": {} }
		},
		"demonic_torturer": {
			"price": 24, "stock": 2, "type": "weapon", "category": "flagellation", "weight": 30, "hands": 2,
			"min_dmg": 26, "max_dmg": 88, "durability": 92, "str_req": 140, "skill_req": 60, "level": 10,
			"crit_chance": 0.2, "crit_multi": 1.55, "speed": 0.45, "range": 130, "parry": false, "block": false,
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
	
