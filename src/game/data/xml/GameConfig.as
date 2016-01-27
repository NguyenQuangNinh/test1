package game.data.xml
{
	import core.util.Utility;
	import game.enum.GameConfigType;
	public class GameConfig extends XMLData
	{
		public var type:int;
		public var value:*;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			type = parseInt(xml.Type.toString());
			switch(type) {
				case GameConfigType.INT:
					value = parseInt(xml.Value.toString());
					break;
					
				case GameConfigType.STRING:
					value = xml.Value.toString();
					break;
					
				case GameConfigType.ARRAY_INT:
					value = xml.Value.toString().split(",");
					Utility.convertToIntArray(value);
					break;
				case GameConfigType.ARRAY_STRING:
					value = xml.Value.toString().split(",");
					break;
			}
		}
	}
}