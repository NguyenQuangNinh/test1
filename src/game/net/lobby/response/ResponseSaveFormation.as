package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseSaveFormation extends ResponsePacket
	{
		
		public var value:int;
		public var saveType:int;
		
		public function ResponseSaveFormation() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			value = data.readInt();
			saveType = data.readInt();
		}
	}

}