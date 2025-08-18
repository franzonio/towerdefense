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
		"light_axe": {"price": 20, "stock": 250, "type": "weapon", "category": "axe", "weight": 3, "hands": 1, "min_dmg": 4.0,  "max_dmg": 10.0, "durability": 30, 
		"str_req": 30, "skill_req": 30, "level": 3, "crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.25, "range": 150, "parry": true, "block": false, 
		"modifiers": { "attributes":  { "axe_mastery": 5, "avoidance": 5}, "bonuses": {} }},

		############################ TODO AI-GENERATED BELOW, NEEDS TUNING ############################
		"hand_axe": { "min_dmg": 2.0, "max_dmg": 5.0, "weight": 3, "hands": 1, "level": 2, "str_req": 20, "skill_req": 20, "durability": 25, 
		"crit_chance": 0.05, "crit_multi": 1.1, "speed": 0.3, "range": 140, "parry": true, "block": false, "price": 15, "stock": 300, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "quickness": 5, "axe_mastery": 3 }, "bonuses": {} }},
		
		"hunting_axe": { "min_dmg": 2.0, "max_dmg": 6.0, "weight": 5, "hands": 1, "level": 3, "str_req": 25, "skill_req": 25, "durability": 35, 
		"crit_chance": 0.08, "crit_multi": 1.2, "speed": 0.28, "range": 145, "parry": true, "block": false, "price": 25, "stock": 200, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "axe_mastery": 4, "avoidance": 3 }, "bonuses": {} }},
		
		"butcher_axe": { "min_dmg": 7.0, "max_dmg": 14.0, "weight": 14, "hands": 2, "level": 5, "str_req": 45, "skill_req": 35, "durability": 40, 
		"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.2, "range": 160, "parry": false, "block": true, "price": 40, "stock": 150, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 6, "axe_mastery": 6 }, "bonuses": {} }},
		
		"broad_axe": { "min_dmg": 4.0, "max_dmg": 7.0, "weight": 8, "hands": 1, "level": 4, "str_req": 35, "skill_req": 30, "durability": 35, 
		"crit_chance": 0.09, "crit_multi": 1.2, "speed": 0.24, "range": 150, "parry": true, "block": false, "price": 30, "stock": 180, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 4, "axe_mastery": 5 }, "bonuses": {} }},
		
		"cleaver_axe": { "min_dmg": 3.0, "max_dmg": 11.0, "weight": 7, "hands": 1, "level": 4, "str_req": 32, "skill_req": 28, "durability": 32, 
		"crit_chance": 0.1, "crit_multi": 1.25, "speed": 0.26, "range": 150, "parry": true, "block": false, "price": 28, "stock": 190, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "crit_rating": 4, "axe_mastery": 5 }, "bonuses": {} }},
		
		"double_axe": { "min_dmg": 4.0, "max_dmg": 10.0, "weight": 6, "hands": 1, "level": 4, "str_req": 30, "skill_req": 30, "durability": 30, 
		"crit_chance": 0.11, "crit_multi": 1.3, "speed": 0.27, "range": 150, "parry": true, "block": false, "price": 35, "stock": 160, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "quickness": 3, "axe_mastery": 6 }, "bonuses": {} }},
		
		"bearded_axe": { "min_dmg": 10.0, "max_dmg": 19.0, "weight": 15, "hands": 2, "level": 6, "str_req": 50, "skill_req": 40, "durability": 45, 
		"crit_chance": 0.13, "crit_multi": 1.35, "speed": 0.18, "range": 165, "parry": false, "block": true, "price": 50, "stock": 120, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 7, "axe_mastery": 7 }, "bonuses": {} }},
		
		"war_axe": { "min_dmg": 7.0, "max_dmg": 13.0, "weight": 11, "hands": 1, "level": 5, "str_req": 40, "skill_req": 35, "durability": 38, 
		"crit_chance": 0.1, "crit_multi": 1.3, "speed": 0.22, "range": 155, "parry": true, "block": false, "price": 42, "stock": 140, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 5, "axe_mastery": 6 }, "bonuses": {} }},
		
		"small_battle_axe": { "min_dmg": 6.0, "max_dmg": 13.0, "weight": 7, "hands": 1, "level": 4, "str_req": 35, "skill_req": 30, "durability": 36, 
		"crit_chance": 0.09, "crit_multi": 1.25, "speed": 0.25, "range": 150, "parry": true, "block": false, "price": 34, "stock": 170, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "axe_mastery": 5, "avoidance": 2 }, "bonuses": {} }},
		
		"desert_axe": { "min_dmg": 7.0, "max_dmg": 12.0, "weight": 6, "hands": 1, "level": 4, "str_req": 33, "skill_req": 28, "durability": 34, 
		"crit_chance": 0.1, "crit_multi": 1.2, "speed": 0.26, "range": 150, "parry": true, "block": false, "price": 36, "stock": 160, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "quickness": 4, "axe_mastery": 5 }, "bonuses": {} }},
		
		"ornate_broad_axe": { "min_dmg": 8.0, "max_dmg": 11.0, "weight": 10, "hands": 1, "level": 5, "str_req": 38, "skill_req": 32, "durability": 40, 
		"crit_chance": 0.12, "crit_multi": 1.3, "speed": 0.23, "range": 150, "parry": true, "block": false, "price": 45, "stock": 130, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "axe_mastery": 6, "resilience": 2 }, "bonuses": {} }},
		
		"pole_axe": { "min_dmg": 13.0, "max_dmg": 24.0, "weight": 16, "hands": 2, "level": 7, "str_req": 55, "skill_req": 45, "durability": 50, 
		"crit_chance": 0.14, "crit_multi": 1.4, "speed": 0.17, "range": 170, "parry": false, "block": true, "price": 60, "stock": 100, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 8, "axe_mastery": 8 }, "bonuses": {} }},
		
		"mountain_axe": { "min_dmg": 10.0, "max_dmg": 15.0, "weight": 9, "hands": 1, "level": 5, "str_req": 40, "skill_req": 35, "durability": 42, 
		"crit_chance": 0.11, "crit_multi": 1.3, "speed": 0.22, "range": 155, "parry": true, "block": false, "price": 48, "stock": 120, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 6, "axe_mastery": 6 }, "bonuses": {} }},
		
		"sea_axe": { "min_dmg": 11.0, "max_dmg": 15.0, "weight": 6, "hands": 1, "level": 5, "str_req": 38, "skill_req": 32, "durability": 38, 
		"crit_chance": 0.12, "crit_multi": 1.25, "speed": 0.26, "range": 150, "parry": true, "block": false, "price": 46, "stock": 130, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "quickness": 4, "axe_mastery": 5 }, "bonuses": {} }},
		
		"bronze_axe": { "min_dmg": 11.0, "max_dmg": 16.0, "weight": 11, "hands": 1, "level": 6, "str_req": 42, "skill_req": 36, "durability": 45, 
		"crit_chance": 0.13, "crit_multi": 1.3, "speed": 0.23, "range": 155, "parry": true, "block": false, "price": 50, "stock": 110, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 5, "axe_mastery": 6 }, "bonuses": {} }},
		
		"ornate_cleaver_axe": { "min_dmg": 10.0, "max_dmg": 18.0, "weight": 12, "hands": 1, "level": 6, "str_req": 45, "skill_req": 38, "durability": 48, 
		"crit_chance": 0.14, "crit_multi": 1.35, "speed": 0.22, "range": 155, "parry": true, "block": false, "price": 55, "stock": 100, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "crit_rating": 5, "axe_mastery": 7 }, "bonuses": {} }},
		
		"morgul_axe": { "min_dmg": 8.0, "max_dmg": 17.0, "weight": 8, "hands": 1, "level": 5, "str_req": 40, "skill_req": 34, "durability": 40, 
		"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.24, "range": 150, "parry": true, "block": false, "price": 52, "stock": 90, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "crit_rating": 6, "axe_mastery": 6 }, "bonuses": {} }},
		
		"long_axe": { "min_dmg": 8.0, "max_dmg": 20.0, "weight": 13, "hands": 1, "level": 6, "str_req": 48, "skill_req": 40, "durability": 50, 
		"crit_chance": 0.13, "crit_multi": 1.35, "speed": 0.21, "range": 160, "parry": true, "block": false, "price": 58, "stock": 85, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 6, "axe_mastery": 7 }, "bonuses": {} }},
		
		"great_twohanded_axe": { "min_dmg": 18.0, "max_dmg": 33.0, "weight": 20, "hands": 2, "level": 7, "str_req": 60, "skill_req": 45, "durability": 60, 
		"crit_chance": 0.15, "crit_multi": 1.4, "speed": 0.17, "range": 170, "parry": false, "block": true, "price": 70, "stock": 70, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 8, "axe_mastery": 8 }, "bonuses": {} }},
		
		"thunder_wrath": { "min_dmg": 23.0, "max_dmg": 36.0, "weight": 25, "hands": 2, "level": 8, "str_req": 70, "skill_req": 50, 
		"durability": 70, "crit_chance": 0.18, "crit_multi": 1.5, "speed": 0.15, "range": 180, "parry": false, "block": true, "price": 85, "stock": 50, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "strength": 10, "axe_mastery": 10 }, "bonuses": {} }},
		
		"four_edge_bilaxe": { "min_dmg": 10.0, "max_dmg": 18.0, "weight": 8, "hands": 1, "level": 6, "str_req": 42, "skill_req": 36, "durability": 45,
		"crit_chance": 0.14, "crit_multi": 1.35, "speed": 0.24, "range": 155, "parry": true, "block": false, "price": 60, "stock": 95, 
		"type": "weapon", "category": "axe", "modifiers": { "attributes": { "quickness": 5, "axe_mastery": 7 }, "bonuses": {} }}
		
		###############################################################################################
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
	},
	
	"chest": {
		"padded_tunic": {
			"price": 8,
			"stock": 300,
			"type": "armor",
			"category": "chest",
			"weight": 1,
			"absorb": 1,
			"str_req": 10,
			"level": 1,
			"modifiers": {
				"attributes": {
					"quickness": 3,
					"avoidance": 2
				},
				"bonuses": {}
			}
		},
		
		"leather_vest": {
			"price": 10,
			"stock": 250,
			"type": "armor",
			"category": "chest",
			"weight": 1,
			"absorb": 2,
			"str_req": 20,
			"level": 2,
			"modifiers": 
				{
				"attributes": {},
				"bonuses": {}
			}
		},
		
		"reinforced_leather_vest": {
			"price": 18,
			"stock": 200,
			"type": "armor",
			"category": "chest",
			"weight": 2,
			"absorb": 2,
			"str_req": 25,
			"level": 3,
			"modifiers": {
				"attributes": {
					"avoidance": 3,
					"crit_rating": 2
				},
				"bonuses": {}
			}
		},

		"chain_mail_shirt": {
			"price": 35,
			"stock": 150,
			"type": "armor",
			"category": "chest",
			"weight": 5,
			"absorb": 4,
			"str_req": 40,
			"level": 5,
			"modifiers": {
				"attributes": {
					"endurance": 4,
					"resilience": 2
				},
				"bonuses": {}
			}
		},

		"iron_plate": {
			"price": 60,
			"stock": 100,
			"type": "armor",
			"category": "chest",
			"weight": 8,
			"absorb": 6,
			"str_req": 55,
			"level": 7,
			"modifiers": {
				"attributes": {
					"strength": 5,
					"health": 5
				},
				"bonuses": {}
			}
		},

		"obsidian_bulwark": {
			"price": 90,
			"stock": 50,
			"type": "armor",
			"category": "chest",
			"weight": 12,
			"absorb": 9,
			"str_req": 70,
			"level": 9,
			"modifiers": {
				"attributes": {
					"resilience": 6,
					"endurance": 6
				},
				"bonuses": {}
			}
		}
	},
	
	"head": {
		"padded_hood": {
			"price": 6,
			"stock": 300,
			"type": "armor",
			"category": "head",
			"weight": 1,
			"absorb": 1,
			"str_req": 8,
			"level": 1,
			"modifiers": {
				"attributes": {
					"quickness": 2,
					"avoidance": 2
				},
				"bonuses": {}
			}
		},
		"leather_cap": {
			"price": 8,
			"stock": 250,
			"type": "armor",
			"category": "head",
			"weight": 1,
			"absorb": 2,
			"str_req": 20,
			"level": 2,
			"modifiers": 
				{
				"attributes": {},
				"bonuses": {}
			}
		},

		"reinforced_leather_cap": {
			"price": 12,
			"stock": 220,
			"type": "armor",
			"category": "head",
			"weight": 1,
			"absorb": 2,
			"str_req": 18,
			"level": 3,
			"modifiers": {
				"attributes": {
					"crit_rating": 2,
					"avoidance": 2
				},
				"bonuses": {}
			}
		},

		"chain_mail_coif": {
			"price": 22,
			"stock": 180,
			"type": "armor",
			"category": "head",
			"weight": 2,
			"absorb": 2,
			"str_req": 30,
			"level": 5,
			"modifiers": {
				"attributes": {
					"endurance": 3,
					"resilience": 2
				},
				"bonuses": {}
			}
		},

		"iron_helm": {
			"price": 35,
			"stock": 120,
			"type": "armor",
			"category": "head",
			"weight": 4,
			"absorb": 3,
			"str_req": 45,
			"level": 7,
			"modifiers": {
				"attributes": {
					"strength": 3,
					"health": 3
				},
				"bonuses": {}
			}
		},

		"obsidian_mask": {
			"price": 55,
			"stock": 60,
			"type": "armor",
			"category": "head",
			"weight": 6,
			"absorb": 4,
			"str_req": 60,
			"level": 9,
			"modifiers": {
				"attributes": {
					"resilience": 4,
					"endurance": 4
				},
				"bonuses": {}
			}
		}
	},
	
	"shoulders": {
		"padded_wraps": {
			"price": 5,
			"stock": 280,
			"type": "armor",
			"category": "shoulders",
			"weight": 1,
			"absorb": 1,
			"str_req": 6,
			"level": 1,
			"modifiers": {
				"attributes": {
					"quickness": 1,
					"avoidance": 2
				},
				"bonuses": {}
			}
		},
		
		"leather_pads": {
			"price": 7,
			"stock": 250,
			"type": "armor",
			"category": "shoulders",
			"weight": 1,
			"absorb": 2,
			"str_req": 20,
			"level": 2,
			"modifiers": 
				{
				"attributes": {},
				"bonuses": {}
			}
		},

		"reinforced_leather_pads": {
			"price": 11,
			"stock": 200,
			"type": "armor",
			"category": "shoulders",
			"weight": 1,
			"absorb": 2,
			"str_req": 16,
			"level": 3,
			"modifiers": {
				"attributes": {
					"crit_rating": 2,
					"quickness": 4
				},
				"bonuses": {}
			}
		},

		"chain_mail_shoulderguards": {
			"price": 20,
			"stock": 160,
			"type": "armor",
			"category": "shoulders",
			"weight": 3,
			"absorb": 2,
			"str_req": 28,
			"level": 5,
			"modifiers": {
				"attributes": {
					"resilience": 2,
					"endurance": 2
				},
				"bonuses": {}
			}
		},

		"iron_shoulders": {
			"price": 32,
			"stock": 100,
			"type": "armor",
			"category": "shoulders",
			"weight": 4,
			"absorb": 3,
			"str_req": 42,
			"level": 7,
			"modifiers": {
				"attributes": {
					"strength": 5,
					"health": 5
				},
				"bonuses": {}
			}
		},

		"obsidian_spikes": {
			"price": 50,
			"stock": 50,
			"type": "armor",
			"category": "shoulders",
			"weight": 5,
			"absorb": 4,
			"str_req": 58,
			"level": 9,
			"modifiers": {
				"attributes": {
					"resilience": 5,
					"endurance": 5,
					"health": 5
				},
				"bonuses": {}
			}
		}
	}
}
	
