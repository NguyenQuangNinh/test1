package game.data.xml 
{
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LevelCommonXML extends XMLData
	{			
		public var levelFrom:int;
		public var levelTo:int;
		public var normalUnitCount:int;
		public var legendUnitCount:int;
		public var appPerRegen:int;
		public var skillLevel:int;
		public var formationLevel:int;
			
		public function LevelCommonXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			levelFrom = parseInt(xml.LevelFrom.toString());
			levelTo = parseInt(xml.LevelTo.toString());
			normalUnitCount = parseInt(xml.NormalUnitCount.toString());
			legendUnitCount = parseInt(xml.LegendUnitCount.toString());
			appPerRegen = parseInt(xml.APPerRegen.toString());
			skillLevel = parseInt(xml.SkillLevel.toString());
			formationLevel = parseInt(xml.FormationLevel.toString());
		}
	}

}