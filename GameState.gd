extends Node
class_name GameState

#@onready var synchronizer := $MultiplayerSynchronizer

var selected_race: String = ""
var gladiator_attributes: Dictionary = {}
var gladiator_alive: int = 0
var skeleton_alive: int = 0

##
var gladiator_data = {}
var all_gladiators = {}  # peer_id => gladiator_data
##

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

func _ready():
	
	await get_tree().process_frame
	call_deferred("_assign_authority")
	#print("GameState loaded")
	#print("✅ GameState loaded on peer:", multiplayer.get_unique_id())
	#print("🌐 Is server:", multiplayer.is_server())
	#print("🧪 I am authority:", is_multiplayer_authority())
	
#	call_deferred("_check_and_set_authority")
#	if multiplayer.is_server():
#		set_multiplayer_authority(multiplayer.get_unique_id())


func submit_gladiator(data: Dictionary):
	#print("🧾 Host submit_gladiator called")
	#print("✔ GameState authority is:", get_multiplayer_authority())
	#print("✔ My ID is:", multiplayer.get_unique_id())
	gladiator_data = data
	if multiplayer.is_server():
		_store_gladiator(multiplayer.get_unique_id(), data)
	else:
		print("📨 Sending gladiator to host via rpc_id...")
		_submit_gladiator_remote.rpc_id(1, data)
	

@rpc("any_peer")
func _submit_gladiator_remote(data: Dictionary):
	var sender_id = multiplayer.get_remote_sender_id()
	print("✅ Host received gladiator from peer:", sender_id)
	_store_gladiator(sender_id, data)

func _store_gladiator(peer_id: int, data: Dictionary):
	all_gladiators[peer_id] = data
	print(all_gladiators)
	print("🎯 Gladiator stored for peer:", peer_id)
	
	if all_gladiators.size() >= NetworkManager_.max_players + 1:
		_start_game.rpc()
		_start_game()
		
@rpc("authority")
func _start_game():
	print("All gladiators submitted! Starting game...")
	# Example: change scene to duel manager
	get_tree().change_scene_to_file("res://Scenes/MatchManager.tscn")


func _check_and_set_authority():
	if not multiplayer.has_multiplayer_peer():
		print("Multiplayer not ready yet, skipping authority setup.")
		return

	if multiplayer.is_server():
		set_multiplayer_authority(multiplayer.get_unique_id())
		print("Authority set to self for host.")
	else:
		print("Client - no authority to set.")

func _assign_authority():
	if multiplayer.is_server():
		print("🌐 Assigning multiplayer authority on host " + str(multiplayer.get_unique_id()))
		set_multiplayer_authority(multiplayer.get_unique_id())

		# ✅ FORCE this node to participate in Multiplayer
		#set_multiplayer(multiplayer)
		
		print("✅ Authority set to:", get_multiplayer_authority())
	else:
		print("ℹ️ Client does not assign authority")
