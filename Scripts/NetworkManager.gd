extends Node
class_name NetworkManager

var max_players: = 1
var port: = 12345
var server_ip: = "127.0.0.1"
var is_host: = false

var LOBBY_NAME = "knepo"
var LOBBY_MODE = "CoOP"
var _lobby_id
signal lobby_created_signal(lobby_id: int)

func _ready():
	# Steam init (still used when using_steam = true)
	print(Steam.steamInitEx(480, true))
	Steam.initRelayNetworkAccess()

	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)

func list_lobbies():
	
	Steam.addRequestLobbyListStringFilter("region", "global", Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()

# ---------- STEAM HOST/JOIN ----------

func host_game_steam(players):
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, players)
	is_host = true

func join_game_steam(lobby_id):
	Steam.joinLobby(lobby_id)

func _on_lobby_created(result: int, lobby_id):
	_lobby_id = lobby_id

	if result == Steam.Result.RESULT_OK:
		var peer := SteamMultiplayerPeer.new()
		peer.debug_level = SteamMultiplayerPeer.DEBUG_LEVEL_PEER
		peer.host_with_lobby(_lobby_id)
		multiplayer.multiplayer_peer = peer

		Steam.setLobbyJoinable(_lobby_id, true)
		Steam.setLobbyData(lobby_id, "region", "global")
		Steam.setLobbyData(_lobby_id, "name", LOBBY_NAME)
		Steam.setLobbyData(_lobby_id, "mode", LOBBY_MODE)
		emit_signal("lobby_created_signal", _lobby_id)

func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, _response: int) -> void:
	_lobby_id = lobby_id

	if Steam.getLobbyOwner(lobby_id) == Steam.getSteamID():
		return

	var peer := SteamMultiplayerPeer.new()
	peer.debug_level = SteamMultiplayerPeer.DEBUG_LEVEL_PEER
	peer.connect_to_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer

func leave_game():
	Steam.leaveLobby(_lobby_id)
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null

# ---------- ENET HOST/JOIN ----------

func host_game_enet(players):
	max_players = players
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_server(port, max_players)
	if err != OK:
		push_error("Failed to create ENet server: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	is_host = true

func join_game_enet(ip: String):
	server_ip = ip
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_client(server_ip, port)
	if err != OK:
		push_error("Failed to create ENet client: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	is_host = false
