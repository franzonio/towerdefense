extends Node
class_name NetworkManager

var max_players := 1 # not including host
var port := 12345
var server_ip := "127.0.0.1"
var is_host := false
#var _hosted_lobby_id = 0
#var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var LOBBY_NAME = "knepo"
var LOBBY_MODE = "CoOP"
var _lobby_id
signal lobby_created_signal(lobby_id: int)

func _ready():
	print(Steam.steamInitEx(480, true))
	Steam.initRelayNetworkAccess()
	
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	
	
func list_lobbies():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	Steam.requestLobbyList()

func host_game(players):
	print("Hosting Steam lobby")
	Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_PUBLIC, players)
	is_host = true

func join_game(lobby_id):
	Steam.joinLobby(lobby_id)
	print("Joining lobby ", lobby_id)
	
	#var peer := SteamMultiplayerPeer.new()
	#peer.debug_level = SteamMultiplayerPeer.DEBUG_LEVEL_PEER
	#peer.create_client(lobby_id, 0)
	#multiplayer.multiplayer_peer = peer
	
	
func _on_lobby_created(_result: int, lobby_id):
	_lobby_id = lobby_id
	print("On lobby created")
	if _result == Steam.Result.RESULT_OK:
		var peer := SteamMultiplayerPeer.new()
		peer.debug_level = SteamMultiplayerPeer.DEBUG_LEVEL_PEER
		peer.host_with_lobby(_lobby_id)
		multiplayer.multiplayer_peer = peer
		#hosted.emit()
		
		#_hosted_lobby_id = lobby_id
		print("Created lobby: " + str(_lobby_id))
		Steam.setLobbyJoinable(_lobby_id, true)
		Steam.setLobbyData(_lobby_id, "name", LOBBY_NAME)
		Steam.setLobbyData(_lobby_id, "mode", LOBBY_MODE)
		emit_signal("lobby_created_signal", _lobby_id)
	else: print("Failed creating lobby")
	
func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, _response: int) -> void:
	_lobby_id = lobby_id
	#print(str(Steam.getLobbyOwner(lobby_id)))
	if Steam.getLobbyOwner(lobby_id) == Steam.getSteamID():
		# We're probably hosting so we can ignore this
		return
		
	# But if we're joining
	var peer := SteamMultiplayerPeer.new()
	peer.debug_level = SteamMultiplayerPeer.DEBUG_LEVEL_PEER
	peer.connect_to_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer
	print("Joined lobby result: " + str(_response))
	
	
func leave_game():
	Steam.leaveLobby(_lobby_id)
