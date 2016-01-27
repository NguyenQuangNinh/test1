package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;
	import flash.utils.ByteArray;
	import game.data.vo.quest_main.QuestInfo;
	import game.data.vo.tuu_lau_chien.ResourceInfo;
	import game.enum.Element;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseResourceInfo extends ResponsePacket
	{		
		public var info:ResourceInfo;
		
		public function ResponseResourceInfo() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			var missionID:int = data.readInt();
			info = new ResourceInfo(missionID);
			
			var playerID:int = data.readInt();
			var isLocked:Boolean = data.readBoolean();
			info.ownerID = playerID;
			info.isLocked = isLocked;			
			
			if (playerID > 0)
			{
				var timeOccupied:int = data.readInt();
				var activeBuffed:Boolean = data.readBoolean();
				var activeProtected:Boolean = data.readBoolean();
				var numOccupied:int = data.readInt();				
				var nextTimeCanOccupied:int = data.readInt();				
				var playerName:String = ByteArrayEx(data).readString();				
				var playerElement:int = data.readInt();
				var resAccumulate:int = data.readInt();
				
				info.timeOccupied = timeOccupied;
				info.activeBuffed = activeBuffed;
				info.activeProtected = activeProtected;
				info.numOccupied = numOccupied;
				info.nextTimeCanOccupied = nextTimeCanOccupied;				
				info.resAccumulate = resAccumulate;
				
				info.ownerName = playerName;				
				info.ownerElement = Enum.getEnum(Element, playerElement) as Element;
			}
		}
	}

}