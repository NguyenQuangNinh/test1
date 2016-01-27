package game.data.xml
{
	import core.util.Utility;

	public class ElementData extends XMLData
	{
		public var name:String;
		public var formationSlotImgURL	:String;
		public var characterSlotImgURL	:String;
		public var tooltipImgURL		:String;
		public var levelUpImgURL		:String;
		public var characterTooltipImgURL	:String;
		public var attributeBalance:Array;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			name = xml.Name.toString();
			formationSlotImgURL = xml.FormationSlotURL.toString();
			characterSlotImgURL = xml.CharacterSlotURL.toString();
			tooltipImgURL = xml.TooltipURL.toString();
			levelUpImgURL = xml.LevelUpURL.toString();
			characterTooltipImgURL = xml.CharacterTooltipURL.toString();
			attributeBalance = Utility.toIntArray(xml.AttributeBalance.toString());
		}
	}
}