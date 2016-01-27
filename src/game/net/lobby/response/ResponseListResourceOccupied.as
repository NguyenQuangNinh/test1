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
	public class ResponseListResourceOccupied extends ResponsePacket
	{		
		public var info:Array = [];
		
		public function ResponseListResourceOccupied() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
				
			while (data.bytesAvailable)
			{
				var missionID:int = data.readInt();
				var ownerID:int = data.readInt();
				var ownerName:String = ByteArrayEx(data).readString();
				var ownerElement:int = data.readInt();
				
				var resource:ResourceInfo = new ResourceInfo(missionID);
				resource.ownerID = ownerID;
				resource.ownerName = ownerName;
				resource.ownerElement = Enum.getEnum(Element, ownerElement) as Element;		
				
				info.push(resource);
			}
			
		}
	}

}