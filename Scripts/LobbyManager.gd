extends Control

@onready var name_input = $VBoxContainer/LineEdit
@onready var player_list = $VBoxContainer/PlayerList
@onready var start_button = $VBoxContainer/StartGameButton


var players := {}

func _ready():
	$VBoxContainer/HBoxContainer/HostButton.pressed.connect(_on_host_pressed)
	$VBoxContainer/HBoxContainer/JoinButton.pressed.connect(_on_join_pressed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	start_button.pressed.connect(_on_start_game_pressed)
	start_button.visible = false
	#print("ready")
	print()
	if multiplayer.is_server():
		_on_peer_connected(multiplayer.get_unique_id())  # Add self

func _on_start_game_pressed():
	
	race_selection.rpc()
	race_selection()

@rpc("authority")
func race_selection():
	get_tree().change_scene_to_file("res://UI/RaceSelection.tscn")
	

@rpc("any_peer")
func register_player_name(id: int, name: String):
	players[id] = name
	_update_player_list()

func _on_host_pressed():
	#print("_on_host_pressed")
	NetworkManager_.host_game()
	start_button.visible = NetworkManager_.is_host
	register_player_name(multiplayer.get_unique_id(), name_input.text)  # register self

func _on_join_pressed():
	NetworkManager_.join_game(NetworkManager_.server_ip)
	print("⏳ Waiting for connection...")
	await multiplayer.connected_to_server
	print("✅ Client connected with ID:", multiplayer.get_unique_id())
	print("❓ Is server:", multiplayer.is_server())
	
	register_player_name.rpc(multiplayer.get_unique_id(), name_input.text)
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

@rpc("any_peer")
func _update_player_list():
	player_list.clear()
	for id in players:
		#print(players[id])
		player_list.add_item(players[id])
		#print(players[id])
	
	

func _on_refresh_pressed() -> void:
	print("Refreshed players list")
	#_update_player_list()
	#_update_player_list.rpc_id(multiplayer.get_remote_sender_id())
	#pass # Replace with function body.
