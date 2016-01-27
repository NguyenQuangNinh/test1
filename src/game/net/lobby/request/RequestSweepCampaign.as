package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestSweepCampaign extends RequestPacket
	{
		public var missonID:int;
		public var numOfSweep:int;
		
		public function RequestSweepCampaign(missonID: int, numOfSweep:int)
		{
			super(LobbyRequestType.SWEEP_CAMPAIGN);
			this.missonID = missonID;
			this.numOfSweep = numOfSweep;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(missonID);
			data.writeInt(numOfSweep);
			return data;			
		}
		
	}

}