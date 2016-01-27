package game.data.xml 
{
	/**
	 * ...
	 * @author anhtinh
	 */
	public class BonusAttributeXML extends XMLData
	{
		public var attributeType : int;
		public var beginValue : int;
		public var valuePerLevel : int;
		public var valueType : int;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			
			attributeType = xml.AttributeType.toString();
			beginValue = xml.BeginValue.toString();
			valuePerLevel = xml.ValuePerLevel.toString();
			valueType = xml.ValueType.toString();
		}
	}

}