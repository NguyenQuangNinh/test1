package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.vo.quest_transport.MissionInfo;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseQuestTransportInfo extends ResponsePacket
	{
		
		public var numQuestCompletedInDay:int;
		public var elapseTimeToNextRandom:int;		
		public var quests:Array = [];
		
		public function ResponseQuestTransportInfo() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			numQuestCompletedInDay = data.readInt();
			elapseTimeToNextRandom = data.readInt();
			
			var numCurrentQuest:int = data.readInt();
			var mission:MissionInfo;
			for (var i:int = 0; i < numCurrentQuest; i++) {
				var missionIndex:int = data.readInt();
				var missionID:int = data.readInt();
				
				mission = new MissionInfo(missionID);
				mission.index = missionIndex;
				mission.type = data.readInt();
				mission.state = data.readInt();				
				
				//don't care 2 of them
				mission.numCompleted = data.readInt();
				mission.timeExpire = data.readInt();
				
				//level receive quest and difficulty
				mission.levelReceived = data.readInt();
				mission.difficulty = data.readInt();
				//time current / total --> notice value is second unit
				mission.timeCurrent = data.readInt();
				mission.timeTotal = data.readInt();	
				//reward id 
				mission.rewardID = data.readInt();
				//size and unit index (-2 / -1 / > 0)
				var numUnit:int = data.readInt();
				for (var j:int = 0; j < numUnit; j++) {
					mission.unitAttend.push(data.readInt());
				}
				
				quests.push(mission);				
			}
			
		}
		
		public function filterQuestsByState(states:Array):Array {
			var result:Array = [];
			if (states && quests) {				
				for (var i:int = 0; i < quests.length; i++) {
					var mission:MissionInfo = quests[i] as MissionInfo;
					if (states.indexOf(mission.state) >= 0) {
						result.push(mission);
					}
				}
			}
			
			return result;
		}
	}

}