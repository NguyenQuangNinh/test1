package game.data.xml 
{
	import core.util.Utility;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LevelQuestTransportXML extends XMLData
	{
		/*<ID><![CDATA[2]]></ID>
		<LevelFrom><![CDATA[25]]></LevelFrom>
		<LevelTo><![CDATA[32]]></LevelTo>
		<XuLeasedTransporter><![CDATA[10]]></XuLeasedTransporter>
		< ArrRewardTransporter > < ![CDATA[0, 245, 246, 247, 248, 249]]></ArrRewardTransporter>*/
		
		public var levelFrom:int;
		public var levelTo:int;
		public var xuLease:int;
		public var arrReward:Array = [];
		
		
		public function LevelQuestTransportXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			levelFrom = parseInt(xml.LevelFrom.toString());
			levelTo = parseInt(xml.LevelTo.toString());
			xuLease = parseInt(xml.XuLeasedTransporter.toString());
			arrReward = Utility.parseToIntArray(xml.ArrRewardTransporter.toString());
		}
	}

}