package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestRentQuestTransport extends RequestPacket
	{
		
		public var index:int;
		public var slotIndex:int
		
		public function RequestRentQuestTransport(m_Index:int, m_SlotIndex:int) 
		{
			super(LobbyRequestType.QUEST_TRANSPORT_RENT);
			index = m_Index;
			slotIndex = m_SlotIndex;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(index);
			data.writeInt(slotIndex);
			return data;
		}
		
	}

}