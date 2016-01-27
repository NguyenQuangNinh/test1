package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;
	import flash.utils.ByteArray;
	import game.data.vo.challenge.HistoryInfo;
	import game.data.vo.quest_main.QuestInfo;
	import game.data.vo.tuu_lau_chien.ResourceInfo;
	import game.enum.Element;
	import game.Game;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseOwnerResourceInfo extends ResponsePacket
	{		
		public var info:ResourceInfo;
		
		public function ResponseOwnerResourceInfo() 
		{
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			var numAttackPerDay:int = data.readInt();
			var missionID:int = data.readInt();
			info = new ResourceInfo(missionID);
			info.ownerID = Game.database.userdata.userID;
			info.ownerElement = Enum.getEnum(Element, Game.database.userdata.mainCharacter.element) as Element;
			info.ownerName = Game.database.userdata.playerName;
			info.numAttackPerDay = numAttackPerDay;
			
			
			if (missionID > 0)
			{
				var timeOccupied:int = data.readInt();
				var activeBuffed:Boolean = data.readBoolean();
				var activeProtected:Boolean = data.readBoolean();
				var numOccupied:int = data.readInt();				
				var nextTimeCanOccupied:int = data.readInt();
				var resAccumulate:int = data.readInt();
				
				info.timeOccupied = timeOccupied;
				info.activeBuffed = activeBuffed;
				info.activeProtected = activeProtected;
				info.numOccupied = numOccupied;
				info.nextTimeCanOccupied = nextTimeCanOccupied;
				info.resAccumulate = resAccumulate;
			}					
		}
	}

}