package game.data.xml 
{
	import flash.utils.Dictionary;
	import game.enum.FeatureEnumType;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LevelFeatureXML extends XMLData
	{
		public var name:String;
		public var levelDictionary: Dictionary = new Dictionary();
		
		public function LevelFeatureXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			ID = parseInt(xml.FeatureID.toString());
			name = xml.Name.toString();
			
			var numLevels:int = xml.Levels[0].Level.length();
			for (var i:int = 0; i < numLevels; i++) {
				var levelXML:XMLData = FeatureEnumType.createXMLByType(ID);
				levelXML.parseXML(xml.Levels[0].Level[i]);		
				levelDictionary[levelXML.ID] = levelXML;
			}
		}	
		
	}

}