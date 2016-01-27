package game.data.xml
{
	public class XMLData
	{
		public var ID:int;
		
		public function parseXML(xml:XML):void
		{
			ID = parseInt(xml.ID.toString());
		}
		
				
		public function getID(): int {
			return ID;
		}
	}
}