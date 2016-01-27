package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestQuestMainClose extends RequestPacket
	{
		
		public var questIndex:int;
		public var rewardIndex:int;
		
		public function RequestQuestMainClose(indexQuest:int, indexReward:int) 
		{
			super(LobbyRequestType.QUEST_MAIN_CLOSE);
			questIndex = indexQuest;
			rewardIndex = indexReward;
		}
		
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(questIndex);
			data.writeInt(rewardIndex);
			return data;
		}
	}

}