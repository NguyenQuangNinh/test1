package game.net.lobby.request
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	
	public class RequestCharacterEvolution extends RequestPacket
	{
		public var characterID:int;
		public var quickBuy:Boolean;
		
		public function RequestCharacterEvolution(type:int = LobbyRequestType.LEVEL_UP_STAR):void
		{
			super(type);
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(characterID);
			data.writeBoolean(quickBuy);
			return data;
		}
	}
}