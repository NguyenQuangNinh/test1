package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ResponseGetRewardGiftCode extends ResponsePacket
	{
		public var _errorCode:int;
		public var _arrRewardID:Array;
		
		public function ResponseGetRewardGiftCode()
		{
		
		}
		
		override public function decode(data:ByteArray):void
		{
			if (data.bytesAvailable > 0)
			{
				_arrRewardID = [];
				_errorCode = data.readByte();
				if (_errorCode == 0) //success
				{
					var nRewardSize:int = data.readInt();
					for (var i:int = 0; i < nRewardSize; i++)
					{
						var nRewardID:int = data.readInt();
						_arrRewardID.push(nRewardID);
					}
				}
			}
		}
	}

}