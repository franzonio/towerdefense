extends Node
class_name GameState

#@onready var synchronizer := $MultiplayerSynchronizer
var all_duels_done := true
var selected_race: String = ""
var gladiator_attributes: Dictionary = {}
var gladiator_alive: int = 0
var skeleton_alive: int = 0

##
var gladiator_data = {}
var all_gladiators = {}  # peer_id => gladiator_data

var selected_name = "PlayerName"
##
@onready var spawn_points = {
	"left": [],
	"right": []
}
@onready var meeting_points 

signal gladiator_life_changed(id: int, new_life: int)
signal countdown_updated(time_left: int)

const RACE_MODIFIERS = {
	"Orc": {
		"strength": 1.25,
		"weapon_skill": 1.0,
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
		"strength": 1.0,
		"weapon_skill": 1.15,
		"quickness": 1.1,
		"crit_rating": 1.0,
		"avoidance": 1.1,
		"health": 1.1,
		"resilience": 1.1,
		"endurance": 1.2
	},
	"Troll": {
		"strength": 1.5,
		"weapon_skill": 0.8,
		"quickness": 0.6,
		"crit_rating": 1.0,
		"avoidance": 0.5,
		"health": 1.5,
		"resilience": 1.4,
		"endurance": 0.8
	}
}

func _ready():
	#print("🆔 Peer:", multiplayer.get_unique_id(), " Is server:", multiplayer.is_server())
	await get_tree().process_frame
	#call_deferred("_assign_authority")

@rpc("any_peer", "call_local")
func broadcast_countdown(time_left: int):
	emit_signal("countdown_updated", time_left)


@rpc("any_peer")
func modify_gladiator_life(id: int, life_lost: int):
	if all_gladiators.has(id):
		all_gladiators[id]["player_life"] -= life_lost
		var new_life = all_gladiators[id]["player_life"]
		emit_signal("gladiator_life_changed", id, new_life)

func submit_gladiator(data: Dictionary):
	gladiator_data = data
	print("Submiting gladiator for peer: %d" % [multiplayer.get_unique_id()])
	if multiplayer.get_unique_id() == 1:
		_store_gladiator(multiplayer.get_unique_id(), data)
	else:
		print("📨 Sending gladiator to host via rpc_id...")
		_submit_gladiator_remote.rpc_id(1, data)
	

@rpc("any_peer", "call_local")
func _submit_gladiator_remote(data: Dictionary):
	var sender_id = multiplayer.get_remote_sender_id()
	print("✅ Host received gladiator from peer:", sender_id)
	_store_gladiator(sender_id, data)

func _store_gladiator(peer_id: int, data: Dictionary):
	all_gladiators[peer_id] = data
	print("🎯 Gladiator stored for peer:", peer_id)
	print(all_gladiators)
	if all_gladiators.size() >= NetworkManager_.max_players + 1:
		
		_start_game.rpc()
		_start_game()
		
@rpc("authority")
func _start_game():
	print("All gladiators submitted! Starting game...")
	get_tree().change_scene_to_file("res://main.tscn")

func _assign_authority():
	if multiplayer.is_server():
		print("🌐 Assigning multiplayer authority on host " + str(multiplayer.get_unique_id()))
		set_multiplayer_authority(multiplayer.get_unique_id())
		
		print("✅ Authority set to:", get_multiplayer_authority())
	else:
		print("ℹ️ Client does not assign authority")
