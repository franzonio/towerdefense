extends Control

@onready var steam_or_enet = $ChooseSteamOrEnet
@onready var use_steam_button = $ChooseSteamOrEnet/UseSteamButton
@onready var use_enet_button = $ChooseSteamOrEnet/UseEnetButton

@onready var name_input = $VBoxContainer/PreJoinOrHostMenu/LineEdit
@onready var player_list = $VBoxContainer/PostJoinOrHostMenu/PlayerList
@onready var host_button = $VBoxContainer/HostContainer/HostButton
@onready var host_container = $VBoxContainer/HostContainer
@onready var join_button = $VBoxContainer/PreJoinOrHostMenu/SelectHostJoinContainer/SelectJoinButton

@onready var start_button = $VBoxContainer/PostJoinOrHostMenu/StartGameButton
#@onready var refresh_button = $VBoxContainer/PostJoinOrHostMenu/Refresh
@onready var post_join_or_host_menu = $VBoxContainer/PostJoinOrHostMenu
@onready var pre_join_or_host_menu = $VBoxContainer/PreJoinOrHostMenu

@onready var select_host_container = $VBoxContainer/PreJoinOrHostMenu/SelectHostJoinContainer
@onready var select_host_button = $VBoxContainer/PreJoinOrHostMenu/SelectHostJoinContainer/SelectHostButton

@onready var add_max_player_button = $VBoxContainer/HostContainer/PlayerCountContainer/PlusMinusContainer/Add
@onready var sub_max_player_button = $VBoxContainer/HostContainer/PlayerCountContainer/PlusMinusContainer/Sub
@onready var max_player_label = $VBoxContainer/HostContainer/PlayerCountContainer/SizeNumber

@export var players := {}
@onready var time = 0
var sec = 0
var prev_sec = 0
var max_players = 2

var using_steam : bool = false

var lobby_id = 0

#var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var LOBBY_NAME = "knepo"
var LOBBY_MODE = "CoOP"

func _ready():
	get_node("GoBack").pressed.connect(func(): go_back())
	add_max_player_button.pressed.connect(_on_add_pressed)
	sub_max_player_button.pressed.connect(_on_sub_pressed)
	select_host_button.pressed.connect(_on_select_host_pressed)
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	start_button.pressed.connect(_on_start_game_pressed)
	NetworkManager_.connect("lobby_created_signal", Callable(self, "on_lobby_created_signal"))
	
	$LobbyContainer.visible = false
	steam_or_enet.visible = true
	pre_join_or_host_menu.visible = false
	host_container.visible = false
	post_join_or_host_menu.visible = false
	max_player_label.text = str(max_players)
	#select_host_container.visible = false
	#print("ready")
	#print()
	#if multiplayer.is_server():
	#	_on_peer_connected(multiplayer.get_unique_id())  # Add self

func _process(delta: float):
	time += delta
	prev_sec = sec
	sec = int(time)
	#print("multiplayer.get_peers(): " + str(multiplayer.get_peers()))
	if sec != prev_sec:
		#print(time)
		print("multiplayer.get_peers(): " + str(multiplayer.get_peers()))
		if using_steam: _update_steam_lobby_player_list()
		else: _update_player_list()
		
		#if multiplayer.is_server(): print("server - players: " + str(players))
		#if !multiplayer.is_server(): print("client - players: " + str(players))

func go_back():
	players = {}
	#Steam.steamShutdown()
	#if !multiplayer.is_server():
		
		#Steam.closeP2PSessionWithUser(Steam.getLobbyOwner(lobby_id))
	Steam.leaveLobby(lobby_id)
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	
	
		#get_tree().set_multiplayer(null)

	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

func _on_add_pressed():
	max_players += 2
	if max_players > 8: max_players = 8
	
	max_player_label.text = str(max_players)
	
func _on_sub_pressed():
	max_players -= 2
	if max_players < 2: max_players = 2
	
	max_player_label.text = str(max_players)

func _on_start_game_pressed():
	#var peers = multiplayer.get_peers()
	#if len(peers) >= 2: multiplayer.disconnect_peer(peers[1])
	#await get_tree().create_timer(1).timeout
	#var connected_players = len(players)
	#print("_on_start_game_pressed: " + str(players))
	#multiplayer.disconnect_peer(0)
	#print("players: " + str(players))
	GameState_.assign_peer_colors(players)
	await get_tree().create_timer(1).timeout
	race_selection.rpc()
	await get_tree().create_timer(1).timeout
	race_selection()

@rpc("authority")
func race_selection():
	get_tree().change_scene_to_file.bind("res://UI/AttributeAllocation.tscn").call_deferred()

@rpc("any_peer")
func register_player_name(id: int, player_name: String):
	players[id] = player_name
	#_update_player_list()

func _on_select_host_pressed(): 
	pre_join_or_host_menu.visible = false
	host_container.visible = true
	post_join_or_host_menu.visible = false
	


func _on_host_pressed():
	if using_steam:
		SteamManager_.initialize_steam()
		NetworkManager_.host_game(max_players)
		#Steam.lobby_created.connect(_on_lobby_created)
		#print("multiplayer.get_unique_id(): " + str(multiplayer.get_unique_id()))
		#await get_tree().create_timer(1).timeout
		#lobby_id = _lobby_id
		register_player_name(multiplayer.get_unique_id(), Steam.getPersonaName())
		GameState_.selected_name = Steam.getPersonaName()
		_update_steam_lobby_player_list()
		
		host_container.visible = false
		$LobbyContainer.visible = false
		select_host_container.visible = false
		pre_join_or_host_menu.visible = false
		post_join_or_host_menu.visible = true
		start_button.visible = true
		start_button.disabled = false

	else:
		NetworkManager_.host_game(max_players)
		pre_join_or_host_menu.visible = false
		host_container.visible = false
		post_join_or_host_menu.visible = true
		#start_button.visible = NetworkManager_.is_host
		if !NetworkManager_.is_host: start_button.disabled = true
		register_player_name(multiplayer.get_unique_id(), name_input.text)  # register self
		GameState_.selected_name = name_input.text

func _on_join_pressed():
	if using_steam:
		SteamManager_.initialize_steam()
		$LobbyContainer.visible = true
		pre_join_or_host_menu.visible = false
		Steam.lobby_match_list.connect(_on_lobby_match_list)
		NetworkManager_.list_lobbies()
	else:
		NetworkManager_.join_game(NetworkManager_.server_ip)
		select_host_container.visible = false
		pre_join_or_host_menu.visible = false
		post_join_or_host_menu.visible = true
		start_button.visible = true#NetworkManager_.is_host
		start_button.disabled = true
		print("⏳ Waiting for connection...")
		await multiplayer.connected_to_server
		print("✅ Client connected with ID:", multiplayer.get_unique_id())
		print("❓ Is server:", multiplayer.is_server())
		
		register_player_name.rpc(multiplayer.get_unique_id(), name_input.text)
		GameState_.selected_name = name_input.text
		
		_update_player_list()#.rpc_id(multiplayer.get_remote_sender_id())
		#get_tree().change_scene_to_file("res://Scenes/AttributeAllocation.tscn")


func _on_lobby_match_list(lobbies: Array): 
	#print(lobbies)
	
	for lobby in $LobbyContainer/Lobbies/Lobbies.get_children():
		lobby.queue_free()
		
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		#var lobby_mode = Steam.getLobbyData(lobby, "mode")
		
		if lobby_name != "": # and lobby_name == "knepo":
			var lobby_button = Button.new()
			lobby_button.set_text(lobby_name)# + " | " + lobby_mode)
			lobby_button.set_size(Vector2(100, 30))
			#lobby_button.add_theme_font_size_override("font_size", 8)
			
			lobby_button.set_name("lobby_" + str(lobby))
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			lobby_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
			
			$LobbyContainer/Lobbies/Lobbies.add_child(lobby_button)

func join_lobby(_lobby_id = 0):
	players = {}
	lobby_id = _lobby_id
	NetworkManager_.join_game(lobby_id)
	
	$LobbyContainer.visible = false
	select_host_container.visible = false
	pre_join_or_host_menu.visible = false
	post_join_or_host_menu.visible = true
	start_button.visible = true
	start_button.disabled = true
	
	#register_player_name.rpc(multiplayer.get_unique_id(), Steam.getPersonaName())
	#GameState_.selected_name = Steam.getPersonaName()

@rpc("any_peer")
func _on_peer_connected(id: int):
	print("peer " + str(id) + " connected")
	if id == 0: return
	#	if multiplayer.is_server(): 
	#		1#multiplayer.multiplayer_peer.disconnect_peer()
		
	print("Player joined: ", id)
	register_player_name.rpc(multiplayer.get_unique_id(), Steam.getPersonaName())
	GameState_.selected_name = Steam.getPersonaName()
	if using_steam: _update_steam_lobby_player_list()
	else: _update_player_list()

@rpc("any_peer")
func _on_peer_disconnected(id: int):
	print("Player left: ", id)
	players.erase(id)
	if using_steam: _update_steam_lobby_player_list()
	else: _update_player_list()
	if id == 1: 
		print("Host left game, closing lobby.")
		go_back()

func _update_steam_lobby_player_list():
	#print("_update_steam_lobby_player_list")
	#if lobby_id == 0: return
	#print("players: " + str(players))
	#print("player_list: " + str(player_list))
	#print("player_list: " + str(player_list))
	player_list.clear()
	if using_steam:
		
		var number_of_players_in_lobby = Steam.getNumLobbyMembers(lobby_id)
		#print("number_of_players_in_lobby: " + str(number_of_players_in_lobby))
		var idx = 0
		#print("Players in lobby: ")
		for i in number_of_players_in_lobby:
			var peer_steam_id = Steam.getLobbyMemberByIndex(lobby_id, idx)
			if peer_steam_id == 0: return
			var peer_name = Steam.getFriendPersonaName(peer_steam_id)
			#print(str(peer_steam_id) + ": " + peer_name)
			player_list.add_item(peer_name)
			idx += 1
		
		#var a = Steam.getAllLobbyData(lobby_id)
		#print(a)

@rpc("any_peer", "call_local")
func _update_player_list():
	player_list.clear()
	for id in players:
		#if id == 1: continue
		#print(players[id])
		player_list.add_item(players[id])
		#print(players[id])


func _on_use_steam_button_pressed():
	using_steam = true
	
	steam_or_enet.visible = false
	pre_join_or_host_menu.visible = true
	host_container.visible = false
	post_join_or_host_menu.visible = false

func _on_use_enet_button_pressed() -> void:
	using_steam = false

	steam_or_enet.visible = false
	pre_join_or_host_menu.visible = true
	host_container.visible = false
	post_join_or_host_menu.visible = false


func _on_refresh_lobbies_pressed():
	NetworkManager_.list_lobbies()

func on_lobby_created_signal(_lobby_id):
	lobby_id = _lobby_id
