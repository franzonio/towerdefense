extends Node
class_name NetworkManager

var max_players := 1
var port := 12345
var server_ip := "127.0.0.1"
var is_host := false

func host_game():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = peer
	is_host = true
	print("Hosting game on port ", port)

func join_game(ip: String):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	is_host = false
	print("Joining game at ", ip)
