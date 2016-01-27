package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;
	
	import flash.utils.ByteArray;
	
	import game.enum.GameMode;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseRequestToPlayGame extends ResponsePacket
	{		
		public var roomID:int;
		public var nameInvite:String;
		public var mode:GameMode;
		public var heroicCampaignID:int;
		public var heroicCampaignStep:int;
		public var heroicCampaignDifficultyLevel:int;
		//public var pass:Boolean;		
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			nameInvite = ByteArrayEx(data).readString();
			roomID = data.readInt();
			mode = Enum.getEnum(GameMode, data.readInt()) as GameMode;
			heroicCampaignID = data.readInt();
			heroicCampaignStep = data.readInt();
			heroicCampaignDifficultyLevel = data.readInt();
			//pass = data.readInt();
		}
		
	}

}