package game.net.lobby.response 
{
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseRequestLuckyGift extends ResponsePacket
	{
		public var _errorCode : int;
		public var _indexRewardIDs : Array;
	
		override public function decode(data:ByteArray):void 
		{
			_errorCode = data.readInt();
			_indexRewardIDs = new Array();
			
            var size:int = data.readInt();
            for (var i:int = 0; i < size; i++)
            {
                _indexRewardIDs.push(data.readInt());
            }
			
		}
		
	}

}