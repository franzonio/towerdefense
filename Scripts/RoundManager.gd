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

var completed_duels := 0
var player_ids = GameState_.all_gladiators.keys()
var countdown_time := 10
var intermission_timer #:= get_parent().get_node("HUD/IntermissionTimer")

var data

func _ready():
	add_to_group("round_manager")
	GameState_.connect("gladiator_attribute_changed", Callable(self, "_on_gladiator_attribute_changed"))
	if multiplayer.is_server():
		hud_scene = get_parent().get_node("HUD")
		intermission_timer = get_tree().get_root().get_node("Main/HUD/IntermissionTimer")
		
		await get_tree().create_timer(1.0).timeout
		data = GameState_.all_gladiators
		generate_round_robin_rounds()
		start_next_round()

func _process(_delta):
	if intermission_timer:
		var time_left = ceil(intermission_timer.time_left)
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
	print("🔄 Starting next round...")
	
	# Get active player IDs (players still in the game)
	var active_players = player_ids

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
	
	print("⚔️ Starting round:", current_round_index + 1)

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
	print(data)
	#print("signal: " + str(data))

func spawn_duel_between(peer1, peer2, index: int):
	var spawn_point_left = GameState_.spawn_points["left"][index]
	var spawn_point_right = GameState_.spawn_points["right"][index]
	var meeting_point = GameState_.meeting_points[index % 4].global_position
	
	if peer1 != null and peer2 != null:
		var data1 = data[peer1]
		var data2 = data[peer2]
		#print(data1)
		#print(data2)
		var glad1 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer1,
			"gladiator_data": data1,
			"opponent_id": peer2,
			"spawn_point": spawn_point_left,
			"meeting_point": meeting_point
		})
		var glad2 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer2,
			"gladiator_data": data2,
			"opponent_id": peer1,
			"spawn_point": spawn_point_right,
			"meeting_point": meeting_point
		})
		
		glad1.died.connect(func(): _on_duel_finished(peer2, peer1))
		glad2.died.connect(func(): _on_duel_finished(peer1, peer2))
	if peer1 != null and peer2 == null:
		var data1 = GameState_.all_gladiators[peer1]
		var glad1 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer1,
			"gladiator_data": data1,
			"opponent_id": peer2,
			"spawn_point": spawn_point_left,
			"meeting_point": meeting_point
		})
		glad1.died.connect(func(): _on_duel_finished(peer2, peer1))
	if peer1 == null and peer2 != null:
		var data2 = GameState_.all_gladiators[peer2]
		var glad2 = gladiator_spawner.spawn({
			"scene": "res://Player/Gladiator.tscn",
			"peer_id": peer2,
			"gladiator_data": data2,
			"opponent_id": peer1,
			"spawn_point": spawn_point_right,
			"meeting_point": meeting_point
		})
		glad2.died.connect(func(): _on_duel_finished(peer1, peer2))


	#active_duels.append([glad1, glad2])

func _on_duel_finished(winner_id: int, loser_id: int): #yes
	if duel_results.has(winner_id): return  # Already processed
	
	duel_results[winner_id] = true
	duel_results[loser_id] = false
	
	if multiplayer.is_server(): 
		if loser_id != -1:
			
			for id in player_ids: 
				if id != null:
					if GameState_.all_gladiators[id]["player_life"] <= 0:
						print("❌" + GameState_.all_gladiators[id]["name"] + " is eliminated!❌")
						GameState_.all_gladiators.erase(id)
						player_ids.erase(id)
						remove_eliminated_from_rounds(id)
						
	if multiplayer.is_server():
		if duel_results.size() >= total_duels*2:
			print("✅ All duels finished")
			await get_tree().create_timer(4.0).timeout  # Short break
			despawn_all_gladiators()
			duel_results.clear()
			total_duels = 0
			await get_tree().create_timer(4.0).timeout
			if multiplayer.is_server() and player_ids.size() >= 2: start_next_round()
			if multiplayer.is_server() and player_ids.size() == 1: print("⭐ " + GameState_.all_gladiators[player_ids[0]]["name"] + " WON THE GAME! ⭐")

func remove_eliminated_from_rounds(eliminated_id: int):
	for _round in rounds:
		for pair in _round:
			if pair[0] == eliminated_id: pair[0] = null
			if pair[1] == eliminated_id: pair[1] = null


#@rpc("authority")
func despawn_all_gladiators():  #yes
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
	
	print("✅ Removing all gladiators from map")
	#await get_tree().create_timer(0.1).timeout
	for g in get_tree().get_nodes_in_group("gladiators"):
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(g): 
			g.queue_free() 
