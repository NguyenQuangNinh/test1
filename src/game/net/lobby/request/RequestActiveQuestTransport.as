package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestActiveQuestTransport extends RequestPacket
	{
		public var questIndex: int;
		public var arrCharacterIndex: Array;
		
		public function RequestActiveQuestTransport(index: int, arrIndex:Array) 
		{
			super(LobbyRequestType.QUEST_TRANSPORT_ACTIVE);
			this.questIndex = index;
			this.arrCharacterIndex = arrIndex;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(questIndex);
			for (var i:int = 0; i < arrCharacterIndex.length; i++) {
				data.writeInt(arrCharacterIndex[i]);
			}
			return data;
		}
	}

}