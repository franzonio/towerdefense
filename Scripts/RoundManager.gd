extends Node
class_name RoundManager

var players := []           # List of peer_ids (e.g. [1, 2, 3, 4])
#var round_pairs := []       # List of dueling pairs: [[1, 2], [3, 4]]
var current_pair_index := 0
#var gladiator_scene := preload("res://Player/Gladiator.tscn")
var hud_scene #:= preload("res://UI/HUD.tscn")
@onready var gladiator_spawner = get_parent().get_node("GladiatorSpawner")  # Reference to your MultiplayerSpawner node

var active_gladiators := []

var active_duels: Array = []
var duel_results: Dictionary = {}
var total_duels := 0

var all_pairs: Array[Array] = []
var rounds: Array = []
var current_round
var current_round_index := 0
var global_round_counter = 0

var completed_duels := 0
var player_ids = GameState_.all_gladiators.keys()
var countdown_time := 10
var intermission_timer #:= get_parent().get_node("HUD/IntermissionTimer")
var time_left
var prev_time

var data

func _ready():
	#player_ids.erase(1)
	add_to_group("round_manager")
	GameState_.connect("gladiator_attribute_changed", Callable(self, "_on_gladiator_attribute_changed"))
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	if multiplayer.is_server():
		hud_scene = get_parent().get_node("HUD")
		intermission_timer = get_tree().get_root().get_node("Main/HUD/IntermissionTimer")
		
		await get_tree().create_timer(1.0).timeout
		data = GameState_.all_gladiators
		generate_round_robin_rounds()
		start_next_round()

func _process(_delta):
	if intermission_timer:
		prev_time = time_left
		time_left = ceil(intermission_timer.time_left)
		if time_left != prev_time:
			
			GameState_.broadcast_countdown.rpc(time_left)


'@rpc("authority", "call_local")
func broadcast_countdown(time_left: int):
	GameState_.emit_signal("countdown_updated", time_left)'

@rpc("any_peer", "call_local")
func generate_round_robin_rounds():
	var active_ids = player_ids.duplicate()
	rounds = []

	if active_ids.size() % 2 != 0: active_ids.append(null)  # Add a 'bye'

	var n = active_ids.size()
	var half = n / 2.0

	for round_idx in n - 1:
		var round_pairs: Array = []
		for i in range(half):
			var p1 = active_ids[i]
			var p2 = active_ids[n - 1 - i]
			if p1 != null and p2 != null: round_pairs.append([p1, p2])
			elif p1 != null: round_pairs.append([p1, null])  # p1 gets a free win
			elif p2 != null: round_pairs.append([p2, null])  # p2 gets a free win

		# Rotate
		active_ids = [active_ids[0]] + [active_ids[-1]] + active_ids.slice(1, -1)
		rounds.append(round_pairs)

	return rounds

func regenerate_null_pairs(_current_round: Array) -> Array:
	var valid_pairs := []
	var unmatched_peers := []
	var used_peers := {}
	
	# Collect valid pairs and extract single players from nulls
	for pair in _current_round:
		if pair.size() != 2:
			continue

		var p1 = pair[0]
		var p2 = pair[1]

		if p1 != null and p2 != null:
			valid_pairs.append([p1, p2])
		else:
			if p1 != null:
				unmatched_peers.append(p1)
			if p2 != null:
				unmatched_peers.append(p2)

	# Shuffle unmatched and re-pair
	unmatched_peers.shuffle()
	while unmatched_peers.size() >= 2:
		var p1 = unmatched_peers.pop_back()
		var p2 = unmatched_peers.pop_back()
		valid_pairs.append([p1, p2])
		used_peers[p1] = true
		used_peers[p2] = true

	# Add single leftover if one remains
	if unmatched_peers.size() == 1:
		valid_pairs.append([null, unmatched_peers[0]])

	return valid_pairs



@rpc("any_peer", "call_local")
func start_next_round():
	global_round_counter += 1
	GameState_.add_to_log(get_multiplayer_authority(), "🔄 Preparation...")
	#print("🔄 Preparation...")
	#print("all_gladiators: " + str (GameState_.all_gladiators))
	
	# Get active player IDs (players still in the game)
	var active_players = player_ids
	
	print("active_players: " + str(active_players))

	if active_players.size() <= 1:
		print("🏆 Game over or only one player left.")
		return
	
	# Generate round-robin rounds if not already
	if rounds.is_empty():
		print("🧩 Generating round-robin schedule...")
		rounds = generate_round_robin_rounds()
		current_round_index = 0

	# Make sure we're within bounds
	if current_round_index >= rounds.size():
		print("🔁 All rounds completed, regenerating...")
		rounds = generate_round_robin_rounds()
		current_round_index = 0
	
	#print("⚔️ Starting round:", current_round_index + 1)

	current_round = rounds[current_round_index]
	#print("before: " + str(current_round))
	current_round = regenerate_null_pairs(current_round)
	#print("after: " + str(current_round))
	duel_results.clear()

	# Spawn duels or assign auto-wins
	total_duels = current_round.size()
	#print("total_duels = current_round.size(): " + str(total_duels))
	
	var spawn_index = 0
	for pair in current_round:
		var p1 = pair[0]
		var p2 = pair[1]
		
		if p1 != null and p2 != null:
			spawn_duel_between(p1, p2, spawn_index)
			spawn_index += 1
		elif p1 != null:
			print("✅ %s gets a free win this round (bye)." % p1)
			spawn_duel_between(p1, p2, spawn_index)
			spawn_index += 1
			register_duel_result(p1, -1)
		elif p2 != null:
			print("✅ %s gets a free win this round (bye)." % p2)
			spawn_duel_between(p1, p2, spawn_index)
			spawn_index += 1
			register_duel_result(p2, -1)
		elif p1 == null and p2 == null: total_duels -= 1

	current_round_index += 1
	print("current_round_index: " + str(current_round_index))
	if global_round_counter >= 2: GameState_.reroll_cards_new_round(active_players)
	
	# INTERMISSION PHASE
	if intermission_timer == null:
		intermission_timer = get_parent().get_node("HUD/IntermissionTimer")

	if intermission_timer:
		intermission_timer.start()
	else:
		push_warning("⚠️ IntermissionTimer not found!")
		
	

func too_many_null_duels(_round: Array) -> bool:
	var null_duel_count := 0
	for duel in _round:
		if duel[0] == null or duel[1] == null: null_duel_count += 1
	if null_duel_count > 1: return true
	return false

func register_duel_result(winner_id: int, loser_id: int = -1):
	print("⚔️ Registering result for winner:", winner_id, " loser:", loser_id)
	_on_duel_finished(winner_id, loser_id)


func _on_gladiator_attribute_changed(new_all_gladiators: Dictionary): 
	data = new_all_gladiators
	#print(data)
	#print("signal: " + str(data))

func spawn_duel_between(peer1, peer2, index: int):
	var spawn_point_left = GameState_.spawn_points["left"][index]
	var spawn_point_right = GameState_.spawn_points["right"][index]
	var meeting_point = GameState_.meeting_points[index % 4].global_position
	var glad1
	var glad2
	if peer1 != null and peer2 != null:
		var data1 = data[peer1]
		var data2 = data[peer2]
		glad1 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer1,
			"gladiator_data": data1,
			"opponent_id": peer2,
			"spawn_point": spawn_point_left,
			"meeting_point": meeting_point
		})
		glad2 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer2,
			"gladiator_data": data2,
			"opponent_id": peer1,
			"spawn_point": spawn_point_right,
			"meeting_point": meeting_point
		})
	elif peer1 != null and peer2 == null:
		var data1 = GameState_.all_gladiators[peer1]
		glad1 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer1,
			"gladiator_data": data1,
			"opponent_id": peer2,
			"spawn_point": spawn_point_left,
			"meeting_point": meeting_point
		})
	elif peer1 == null and peer2 != null:
		var data2 = GameState_.all_gladiators[peer2]
		glad2 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer2,
			"gladiator_data": data2,
			"opponent_id": peer1,
			"spawn_point": spawn_point_right,
			"meeting_point": meeting_point
		})
		
	#if glad1 and peer1 and peer2: glad1.died.connect(func(): _on_duel_finished(peer2, peer1))
	#if glad2 and peer1 and peer2: glad2.died.connect(func(): _on_duel_finished(peer1, peer2))

	glad1.died.connect(func(): _on_duel_finished(peer2, peer1))
	glad2.died.connect(func(): _on_duel_finished(peer1, peer2))

func _on_duel_finished(winner_id: int, loser_id: int): #yes
	await get_tree().process_frame
	print("winner_id: " + str(winner_id))
	if duel_results.has(winner_id): return  # Already processed
	if winner_id == -1 or loser_id == -1: return
	
	duel_results[winner_id] = true
	duel_results[loser_id] = false
	
	print("duel_results: " + str(duel_results))
	
	var base_gold = 3
	#var winner_current_streak = GameState_.all_gladiators[winner_id]["streak"]
	#var loser_current_streak = GameState_.all_gladiators[loser_id]["streak"]
	
	GameState_.grant_gold_for_peer(winner_id, base_gold, loser_id, true)
	GameState_.grant_gold_for_peer(loser_id, base_gold, winner_id, false)
	
	GameState_.modify_streak(winner_id, true)
	GameState_.modify_streak(loser_id, false)
	
	GameState_.grant_exp_for_peer(winner_id, 4, 0)
	GameState_.grant_exp_for_peer(loser_id, 4, 0)
	
	var ids_to_eliminate = []
	if multiplayer.is_server(): 
		if loser_id != -1:
			
			#print("player_ids: " + str(player_ids))
			#print("all_gladiators: " + str (GameState_.all_gladiators))
			for id in player_ids: 
				print("life for " + str(id) + ": " + str(GameState_.all_gladiators[id]["player_life"]))
				if id != null:
					if GameState_.all_gladiators[id]["player_life"] <= 0:
						ids_to_eliminate.append(id)

			#print("ids_to_eliminate: " + str(ids_to_eliminate))
			for id in ids_to_eliminate:
				var _name = GameState_.all_gladiators[id]["name"]
				var color = GameState_.all_gladiators[id]["color"].to_html()
				var formatted = "[color=%s]%s[/color]" % [color, _name]
				GameState_.add_to_log(get_multiplayer_authority(), "❌" + formatted + " is eliminated!❌")
				#GameState_.all_gladiators.erase(id)
				player_ids.erase(id)
				remove_eliminated_from_rounds(id)
				#await get_tree().process_frame
				#await get_tree().process_frame
				#await get_tree().process_frame
			print("all_gladiators after erase: " + str (GameState_.all_gladiators))
				
	#if multiplayer.is_server():
		print("len(player_ids): " + str(len(player_ids)) + " " + str(player_ids))
		if duel_results.size() >= len(player_ids)/2.0: #total_duels*2:
			#GameState_.add_to_log(get_multiplayer_authority(), "✅ All duels finished")
			print("duel_results.size(): " + str(duel_results.size()))
			await get_tree().create_timer(4.0).timeout  # Short break
			print("after wait 4s")
			despawn_all_gladiators()
			print("after despawn_all_gladiators()")
			duel_results.clear()
			total_duels = 0
			await get_tree().create_timer(4.0).timeout
			print("after wait 4s, #2")
			if player_ids.size() >= 2: 
				start_next_round()
			if player_ids.size() == 1: 
				var _name = GameState_.all_gladiators[player_ids[0]]["name"]
				var color = GameState_.all_gladiators[player_ids[0]]["color"].to_html()
				var formatted = "[color=%s]%s[/color]" % [color, _name]
				#GameState_.add_to_log(get_multiplayer_authority(), "⭐ " + formatted + " WON THE GAME! ⭐")
				#print("⭐ " + formatted + " WON THE GAME! ⭐")
				
				if multiplayer.is_server():
					GameState_.add_to_log(multiplayer.get_unique_id(), "⭐ " + formatted + " WON THE GAME! ⭐")
				else:
					GameState_.rpc("add_to_log", multiplayer.get_unique_id(), "⭐ " + formatted + " WON THE GAME! ⭐")

func remove_eliminated_from_rounds(eliminated_id: int):
	for _round in rounds:
		for pair in _round:
			if pair[0] == eliminated_id: pair[0] = null
			if pair[1] == eliminated_id: pair[1] = null


#@rpc("authority")
func despawn_all_gladiators():  #yes
	print("✅ Removing all gladiators from map")
	var sync1 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator/MultiplayerSynchronizer")
	var sync2 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator8/MultiplayerSynchronizer")
	var sync3 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator2/MultiplayerSynchronizer")
	var sync4 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator3/MultiplayerSynchronizer")
	var sync5 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator4/MultiplayerSynchronizer")
	var sync6 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator5/MultiplayerSynchronizer")
	var sync7 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator6/MultiplayerSynchronizer")
	var sync8 = get_node_or_null("/root/Main/GladiatorSpawner/Gladiator7/MultiplayerSynchronizer")
	
	if sync1 != null: sync1.public_visibility = false
	if sync2 != null: sync2.public_visibility = false
	if sync3 != null: sync3.public_visibility = false
	if sync4 != null: sync4.public_visibility = false
	if sync5 != null: sync5.public_visibility = false
	if sync6 != null: sync6.public_visibility = false
	if sync7 != null: sync7.public_visibility = false
	if sync8 != null: sync8.public_visibility = false
	
	if not is_multiplayer_authority():
		#await get_tree().create_timer(0.2).timeout
		return  # Only the host should do this
	
	
	#await get_tree().create_timer(0.1).timeout
	for g in get_tree().get_nodes_in_group("gladiators"):
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(g): 
			g.queue_free() 
			print(str(g) + " was removed from map.")

@rpc("any_peer")
func _on_peer_disconnected(id: int):
	print("Player disconnected: ", id)
	var _name = GameState_.all_gladiators[id].get("name", "")
	if _name == "": 
		return
	var color = GameState_.all_gladiators[id]["color"].to_html()
	var formatted = "[color=%s]%s[/color]" % [color, _name]
	GameState_.kill_peer(id)
	GameState_.add_to_log(get_multiplayer_authority(), "❌" + formatted + " disconnected!❌")
	#GameState_.all_gladiators.erase(id)
	multiplayer.disconnect_peer(id)
	player_ids.erase(id)
	remove_eliminated_from_rounds(id)
	#_update_player_list()
