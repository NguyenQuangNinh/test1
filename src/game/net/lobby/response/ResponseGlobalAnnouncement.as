package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseGlobalAnnouncement extends ResponsePacket 
	{
		public var userID		:int;
		public var userName		:String;
		public var highPriority	:Boolean;
		public var annoucementType	:int;
		public var repeat		:int;
		public var message		:String;
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			userID 		= data.readInt();
			userName 	= ByteArrayEx(data).readString();
			highPriority 	= data.readBoolean();
			annoucementType = data.readInt();
			repeat 			= data.readInt();
			message 		= ByteArrayEx(data).readString();
		}
		
	}

}