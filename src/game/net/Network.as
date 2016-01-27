package game.net
{
	import game.net.lobby.LobbyServer;
	import game.net.game.GameServer;

	public class Network
	{
		public var lobby:LobbyServer = new LobbyServer();
		public var game:GameServer = new GameServer();
	}
}