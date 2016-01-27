package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseUpStarAdditionRate extends ResponsePacket 
	{
		public var characterID	:int;
		public var additionValue	:int;
		public var maxAdditionValue	:int;
		
		public function ResponseUpStarAdditionRate() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			if (data) {
				characterID = data.readInt();
				additionValue = data.readInt();
				maxAdditionValue = data.readInt();
			}
		}
		
	}

}