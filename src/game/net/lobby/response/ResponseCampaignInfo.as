package game.net.lobby.response 
{
	import core.Manager;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.Game;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseCampaignInfo extends ResponsePacket
	{
		public var campaignID : int;
		public var totalStar : int;
		public var receiveRewards : Array;
		
		override public function decode(data:ByteArray):void 
		{
			campaignID = data.readInt();
			totalStar = data.readInt();
			//Utility.log("@@@@ totalStar : " + totalStar);
			receiveRewards = [];
			var numReceiveReward : int = data.readInt();
			//Utility.log("@@@@ numReceiveReward : " + numReceiveReward);
			for (var j:int = 0; j < numReceiveReward; j++) 
			{
				receiveRewards.push(data.readInt());
				//Utility.log("@@@@ ReceiveReward ID: " + receiveRewards[j]);
			}
			
			var numMission : int = data.readInt();
			//Utility.log("@@@@ numMission : " + numMission);
			Game.database.userdata.finishedMissions = new Dictionary();
			
			var missionID : int;
			for (var i:int = 0; i < numMission; i++) 
			{
				missionID = data.readInt();
				Game.database.userdata.finishedMissions[missionID] = data.readInt();
				//Utility.log("@@@@ missionID : " + missionID);
				//Utility.log("@@@@ star : " + Game.database.userdata.finishedMissions[missionID]);
			}
		}
		
	}

}