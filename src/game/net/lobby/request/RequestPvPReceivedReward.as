package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestPvPReceivedReward extends RequestPacket
	{
		
		public var topPVPType:int;
		public var rewardIndex:int;		
		
		public function RequestPvPReceivedReward(topType:int, index:int) 
		{
			super(LobbyRequestType.PVP_RECEIVED_REWARD);
			topPVPType = topType;
			rewardIndex = index;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(topPVPType);
			data.writeInt(rewardIndex);
			return data;
		}
		
	}

}