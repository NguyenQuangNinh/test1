package game.data.xml
{
	import core.util.Utility;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class LevelRewardRequireLevelXML extends XMLData
	{
		
		public var nLevelRequire:int;
		public var arrRewardLevel:Array = [];
		
		public function LevelRewardRequireLevelXML()
		{
		
		}
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			nLevelRequire = parseInt(xml.LevelRequire.toString());
			arrRewardLevel = Utility.parseToIntArray(xml.ArrRewardLevel.toString());
		}
	}

}