package game.data.xml 
{
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GameConditionXML extends XMLData 
	{
		public var name		:String = "";
		public var type		:int = -1;
		public var itemID	:int = -1;
		public var itemType	:int = 1;
		public var quantity	:int = -1;
		public var operationType:int = 1;
		public var destination:int = -1;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			name = xml.Name.toString();
			type = parseInt(xml.Type.toString());
			itemID = parseInt(xml.ItemID.toString());
			destination = parseInt(xml.Destination.toString());
			itemType = parseInt(xml.ItemType.toString());			
			quantity = parseInt(xml.Quantity.toString());
			operationType = parseInt(xml.OperatorType.toString());
			
		}
	}

}