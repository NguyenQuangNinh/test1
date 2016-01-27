package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseRequestFriendList extends ResponsePacket
	{
		public var _totalFriend : int;
		public var _arrFriend : Array;
		
		public function ResponseRequestFriendList()
		{
			_arrFriend = [];
		}
		
		override public function decode(data:ByteArray):void 
		{
			_arrFriend = [];
			_totalFriend = data.readInt();
			while (data.bytesAvailable > 0)
			{
				var obj:Object = { };
				obj.id = data.readInt();
				obj.name = ByteArrayEx( data).readString();
				obj.level = data.readInt();
				obj.online = data.readBoolean();
				obj.canGive = data.readBoolean();
				obj.canReceive = data.readBoolean();
				_arrFriend.push(obj);
			}
		}	
	}

}