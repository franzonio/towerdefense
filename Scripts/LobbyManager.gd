extends Control

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
	pre_join_or_host_menu.visible = true
	host_container.visible = false
	post_join_or_host_menu.visible = false
	max_player_label.text = str(max_players)
	#select_host_container.visible = false
	#print("ready")
	#print()
	if multiplayer.is_server():
		_on_peer_connected(multiplayer.get_unique_id())  # Add self

func _process(delta: float):
	time += delta
	prev_sec = sec
	sec = int(time)
	if sec != prev_sec:
		#print(time)
		_update_player_list()
		#if multiplayer.is_server(): print("server - players: " + str(players))
		#if !multiplayer.is_server(): print("client - players: " + str(players))

func go_back():
	if !multiplayer.is_server():
		multiplayer.multiplayer_peer.close()
		get_tree().set_multiplayer(null)

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
	var connected_players = len(players)
	print(connected_players)
	GameState_.assign_peer_colors(players)
	race_selection.rpc()
	race_selection()

@rpc("authority")
func race_selection():
	get_tree().change_scene_to_file("res://UI/AttributeAllocation.tscn")
	

@rpc("any_peer")
func register_player_name(id: int, player_name: String):
	players[id] = player_name
	_update_player_list()

func _on_select_host_pressed(): 
	pre_join_or_host_menu.visible = false
	host_container.visible = true
	post_join_or_host_menu.visible = false
	

func _on_host_pressed():
	NetworkManager_.host_game(max_players)
	pre_join_or_host_menu.visible = false
	host_container.visible = false
	post_join_or_host_menu.visible = true
	#start_button.visible = NetworkManager_.is_host
	if !NetworkManager_.is_host: start_button.disabled
	register_player_name(multiplayer.get_unique_id(), name_input.text)  # register self
	GameState_.selected_name = name_input.text

func _on_join_pressed():
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


@rpc("any_peer")
func _on_peer_connected(id: int):
	print("Player joined: ", id)
	_update_player_list()

@rpc("any_peer")
func _on_peer_disconnected(id: int):
	print("Player left: ", id)
	players.erase(id)
	_update_player_list()

@rpc("any_peer", "call_local")
func _update_player_list():
	#print("players: " + str(players))
	#print("player_list: " + str(player_list))
	player_list.clear()
	for id in players:
		if id == 1: continue
		#print(players[id])
		player_list.add_item(players[id])
		#print(players[id])
	
	

func _on_refresh_pressed() -> void:
	#print("Refreshed players list")
	#_update_player_list()
	_update_player_list()#.rpc_id(multiplayer.get_remote_sender_id())
	#pass # Replace with function body.
