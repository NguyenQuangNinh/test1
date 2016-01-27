package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RequestGetCampaignReward extends RequestPacket
	{
		public var campaignID : int;
		public var rewardIndex : int;
		
		public function RequestGetCampaignReward() 
		{
			super(LobbyRequestType.GET_CAMPAIGN_REWARD);
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			
			data.writeInt(campaignID);
			data.writeInt(rewardIndex);
			
			return data;
		}
	}

}