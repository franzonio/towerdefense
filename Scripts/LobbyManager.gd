extends Control

@onready var steam_or_enet = $ChooseSteamOrEnet
@onready var use_steam_button = $ChooseSteamOrEnet / UseSteamButton
@onready var use_enet_button = $ChooseSteamOrEnet / UseEnetButton

@onready var name_input = $VBoxContainer / PreJoinOrHostMenu / LineEdit
@onready var player_list = $VBoxContainer / PostJoinOrHostMenu / PlayerList
@onready var host_button = $VBoxContainer / HostContainer / HostButton
@onready var host_container = $VBoxContainer / HostContainer
@onready var join_button = $VBoxContainer / PreJoinOrHostMenu / SelectHostJoinContainer / SelectJoinButton

@onready var start_button = $VBoxContainer / PostJoinOrHostMenu / StartGameButton

@onready var post_join_or_host_menu = $VBoxContainer / PostJoinOrHostMenu
@onready var pre_join_or_host_menu = $VBoxContainer / PreJoinOrHostMenu

@onready var select_host_container = $VBoxContainer / PreJoinOrHostMenu / SelectHostJoinContainer
@onready var select_host_button = $VBoxContainer / PreJoinOrHostMenu / SelectHostJoinContainer / SelectHostButton

@onready var add_max_player_button = $VBoxContainer / HostContainer / PlayerCountContainer / PlusMinusContainer / Add
@onready var sub_max_player_button = $VBoxContainer / HostContainer / PlayerCountContainer / PlusMinusContainer / Sub
@onready var max_player_label = $VBoxContainer / HostContainer / PlayerCountContainer / SizeNumber

@export var players: = {}
@onready var time = 0
var sec = 0
var prev_sec = 0
var max_players = 2

var using_steam: bool = false

var lobby_id = 0


var LOBBY_NAME = "knepo"
var LOBBY_MODE = "CoOP"

func _ready():
	get_node("GoBack").pressed.connect( func(): go_back())
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





	using_steam = true

	steam_or_enet.visible = false
	pre_join_or_host_menu.visible = true
	host_container.visible = false
	post_join_or_host_menu.visible = false




func _process(delta: float):
	time += delta
	prev_sec = sec
	sec = int(time)

	if sec != prev_sec:


		if using_steam:
			_update_steam_lobby_player_list()
			NetworkManager_.list_lobbies()
		else:
			_update_player_list()




func go_back():
	players = {}




	Steam.leaveLobby(lobby_id)
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null




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







	GameState_.assign_peer_colors(players)
	await get_tree().create_timer(1).timeout
	race_selection.rpc()
	#await get_tree().create_timer(1).timeout
	race_selection()

@rpc("authority")
func race_selection():
	get_tree().change_scene_to_file.bind("res://UI/AttributeAllocation.tscn").call_deferred()

@rpc("any_peer")
func register_player_name(id: int, player_name: String):
	players[id] = player_name


func _on_select_host_pressed():
	pre_join_or_host_menu.visible = false
	host_container.visible = true
	post_join_or_host_menu.visible = false



func _on_host_pressed():
	if using_steam:
		SteamManager_.initialize_steam()
		NetworkManager_.host_game(max_players)




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

		if !NetworkManager_.is_host: start_button.disabled = true
		register_player_name(multiplayer.get_unique_id(), name_input.text)
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
		start_button.visible = true
		start_button.disabled = true
		print("⏳ Waiting for connection...")
		await multiplayer.connected_to_server
		print("✅ Client connected with ID:", multiplayer.get_unique_id())
		print("❓ Is server:", multiplayer.is_server())

		register_player_name.rpc(multiplayer.get_unique_id(), name_input.text)
		GameState_.selected_name = name_input.text

		_update_player_list()



func _on_lobby_match_list(lobbies: Array):
	for lobby in $LobbyContainer / Lobbies / Lobbies.get_children():
		lobby.queue_free()

	for lobby in lobbies:

		var lobby_name = Steam.getLobbyData(lobby, "name")


		if lobby_name != "":
			var lobby_button = Button.new()
			lobby_button.set_text(lobby_name)
			lobby_button.set_size(Vector2(100, 30))


			lobby_button.set_name("lobby_" + str(lobby))
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			lobby_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))

			$LobbyContainer / Lobbies / Lobbies.add_child(lobby_button)

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




@rpc("any_peer")
func _on_peer_connected(id: int):
	print("peer " + str(id) + " connected")
	if id == 0: return



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





	player_list.clear()
	if using_steam:

		var number_of_players_in_lobby = Steam.getNumLobbyMembers(lobby_id)

		var idx = 0

		for i in number_of_players_in_lobby:
			var peer_steam_id = Steam.getLobbyMemberByIndex(lobby_id, idx)
			if peer_steam_id == 0: return
			var peer_name = Steam.getFriendPersonaName(peer_steam_id)

			player_list.add_item(peer_name)
			idx += 1




@rpc("any_peer", "call_local")
func _update_player_list():
	player_list.clear()
	for id in players:


		player_list.add_item(players[id])



func _on_use_steam_button_pressed():
	using_steam = true

	steam_or_enet.visible = false
	pre_join_or_host_menu.visible = true
	host_container.visible = false
	post_join_or_host_menu.visible = false

func _on_use_enet_button_pressed() -> void :
	using_steam = false

	steam_or_enet.visible = false
	pre_join_or_host_menu.visible = true
	host_container.visible = false
	post_join_or_host_menu.visible = false


func _on_refresh_lobbies_pressed():
	NetworkManager_.list_lobbies()

func on_lobby_created_signal(_lobby_id):
	lobby_id = _lobby_id
