package game.data.model.item
{
	import flash.utils.ByteArray;
	import game.data.xml.XMLData;
	import game.enum.ItemType;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class BaseItem
	{
		public var xmlData:XMLData;
		public var index:int;
		
		public function BaseItem()
		{
			
		}
		
		public function init(xmlID:int, type:ItemType):void
		{
		
		}
		
		public function decode(data:ByteArray):void
		{
		
		}
	}

}