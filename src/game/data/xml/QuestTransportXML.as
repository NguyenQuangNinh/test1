package game.data.xml 
{
	import core.util.Utility;
	import game.data.model.item.Item;
	import game.data.model.item.ItemFactory;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.xml.item.ItemXML;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestTransportXML extends XMLData	
	{
		public var type:int;
		public var name:String;
		public var desc:String;
		
		public var difficulty:int;
		public var maxUnit:int;
		public var bonusClass:int;
		public var bonusHonor:int;
		
		public var xuRent:int;
		public var xuSkip:int;
		
		public function QuestTransportXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			type = parseInt(xml.Type.toString());	
			name = xml.Name.toString();
			desc = xml.Desc.toString();
			
			difficulty = parseInt(xml.Difficulty.toString());
			maxUnit = parseInt(xml.MaxUnit.toString());
			bonusClass = parseInt(xml.BonusClass.toString());
			bonusHonor = parseInt(xml.BonusHonor.toString());
			
			xuRent = parseInt(xml.XuRent.toString());
			xuSkip = parseInt(xml.XuSkip.toString());
		}
		
	}

}