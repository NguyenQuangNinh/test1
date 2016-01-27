package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseHeroicInvitePlayer extends ResponsePacket 
	{
		public var playerName		:String;
		public var roomID			:int;
		public var gameMode			:int;
		public var password			:int;
		public var caveID			:int;
		public var nextMissionID	:int;
		public var hardMode			:int;
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			playerName = ByteArrayEx(data).readString();
			roomID = data.readInt();
			gameMode = data.readInt();
			//password = data.readInt();
			caveID = data.readInt();
			nextMissionID = data.readInt();
			hardMode = data.readInt();
		}
	}

}