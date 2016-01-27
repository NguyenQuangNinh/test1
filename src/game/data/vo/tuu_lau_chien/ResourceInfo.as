package game.data.vo.tuu_lau_chien 
{
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Element;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResourceInfo 
	{
		
		//static info
		public var id:int;
		public var type:int;
		
		//dynamic info
		public var ownerID:int;
		public var ownerElement:Element = Element.NEUTRAL;
		public var ownerName:String = "";
		public var timeOccupied:int;
		public var nextTimeCanOccupied:int;
		public var activeProtected:Boolean = false;
		public var activeBuffed:Boolean = false;
		public var numOccupied:int;
		public var numAttackPerDay:int;
		public var isLocked:Boolean = false;
		
		//num resource accumulate
		public var resAccumulate:int;
		
		//history occupied
		//public var historyInfo:Array = [];
		
		//for action request: true --> want to occupy // false --> want to attack
		public var requestAction:Boolean = true;
		
		public function ResourceInfo(missionID:int) 
		{
			id = missionID;			
		}			
	}
}