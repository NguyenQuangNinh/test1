package game.data.xml
{
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class FeatureXML extends XMLData
	{
		public static const HUD_BUTTON:int = 0;
		public static const NPC_BUTTON:int = 1;
		
		public var type:int;
		public var name:String;
		public var instanceName:String;
		public var group:String;
		public var levelRequirement:int;
		public var positionIndex:int;
		public var url:String;
		public var posX:int;
		public var posY:int;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			
			type = parseInt(xml.Type.toString());
			name = xml.Name.toString();
			instanceName = xml.InstanceName.toString();
			group = xml.Group.toString();
			levelRequirement = parseInt(xml.LevelRequirement.toString());
			positionIndex = parseInt(xml.PositionIndex.toString());
			url = xml.URL.toString();
			posX = parseInt(xml.X.toString());
			posY = parseInt(xml.Y.toString());
		}
	}

}