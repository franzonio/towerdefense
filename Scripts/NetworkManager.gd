extends Node
class_name NetworkManager

var max_players := 1 # not including host
var port := 12345
var server_ip := "127.0.0.1"
var is_host := false

func host_game(players):
	var peer = ENetMultiplayerPeer.new()
	max_players = players
	peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = peer
	is_host = true
	#multiplayer.set_root_node(get_tree().get_root())
	print("Hosting game on port ", port)

func join_game(ip: String):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	is_host = false
	#multiplayer.set_root_node(get_tree().get_root())
	print("Joining game at ", ip)
	#get_tree().create_timer(2.0).timeout
	
