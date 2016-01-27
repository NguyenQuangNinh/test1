package game.data.xml 
{
	/**
	 * ...
	 * @author anhtinh
	 */
	public class BonusAttrNameMappingXML extends XMLData
	{
		
		public var name : String;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
						
			name = xml.Name.toString();			
		}
	}

}