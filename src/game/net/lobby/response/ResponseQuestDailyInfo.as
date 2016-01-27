package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.data.vo.quest_main.QuestInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseQuestDailyInfo extends ResponsePacket
	{
		
		public var quests:Array = [];
		
		public function ResponseQuestDailyInfo() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			var numCurrentQuest:int = data.readInt();
			var quest:QuestInfo;
			for (var i:int = 0; i < numCurrentQuest; i++) {
				var questIndex:int = data.readInt();
				var questID:int = data.readInt();
				quest = new QuestInfo(questID);
				quest.index = questIndex;
				quest.type = data.readInt();
				quest.state = data.readInt();
				quest.numCompleted = data.readInt();
				quest.timeExpire = data.readInt();
				quest.playerLevelReceivedQuest = data.readInt();
				quest.difficulty = data.readInt();
				var numCondition:int = data.readInt();
				for (var j:int = 0; j < numCondition; j++) {
					var id:int = data.readInt();
					var value:int = data.readInt();
					var timeRemain:int = data.readInt();
					quest.updateCondtionByID(id, value, timeRemain);
				}		
				quest.isNew = data.readBoolean();
				quests.push(quest);				
			}
			
		}
	}

}