package game.net.game
{
	import game.enum.ServerResponseType;
	import game.net.ByteResponsePacket;
	import game.net.ResponsePacket;
	import game.net.game.response.ResponseIngame;
	
	public class GameResponseType extends ServerResponseType
	{
		public static const INIT_PLAYER				:GameResponseType = new GameResponseType(2, ByteResponsePacket);
		public static const PREPARE_NEXT_WAVE		:GameResponseType = new GameResponseType(4, ByteResponsePacket);		
		public static const NEXT_WAVE_READY			:GameResponseType = new GameResponseType(5, ResponsePacket);
		public static const IN_GAME					:GameResponseType = new GameResponseType(1000, ResponseIngame);
		
		public function GameResponseType(ID:int, packetClass:Class, name:String=""):void
		{
			super(ID, packetClass, name);
		}
	}
}