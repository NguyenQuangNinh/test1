package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestLevelUpEnhancement extends RequestPacket 
	{
		public var IDs	:Array = [];
		public function RequestLevelUpEnhancement() 
		{
			super(LobbyRequestType.LEVEL_UP_ENHANCEMENT);
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			for(var i:int = 0; i < IDs.length; ++i)
			{
				data.writeInt(IDs[i]);
			}
			return data;
		}
	}

}