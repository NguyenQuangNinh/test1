package game.ui.heroic.world_map 
{
	import game.data.xml.CampaignXML;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CampaignData 
	{
		public var campaignID	:int = -1;
		public var name			:String = "";
		public var posX			:int = -1;
		public var posY			:int = -1;
		public var missionIDs			:Array = [];
		public var freePlayingTimes		:int = -1;
		public var freeMax				:int = -1;
		public var premiumPlayingTimes	:int = -1;
		public var premiumMax			:int = -1;
		public var playingCost			:int = -1;
		public var playingBought		:int = -1;
		public var APRequired			:int = -1;
		public var levelRequired		:int = -1;
	}

}