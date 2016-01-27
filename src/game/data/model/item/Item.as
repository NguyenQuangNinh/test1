package game.data.model.item
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemXML;
	import game.enum.ItemType;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class Item extends BaseItem
	{
		//protected var xmlData : ItemXML;
		public var quantity:int;
		public var expireTime:int;
		
		public function Item()
		{
			
		}
		override public function init(xmlID:int, type:ItemType):void
		{
			if(type == ItemType.EMPTY_SLOT) return;
			
			super.init(xmlID, type);
			
			if (type == ItemType.LUCKY_CHEST)
				xmlData = Game.database.gamedata.getData(DataType.ITEMCHEST, xmlID) as ItemXML;
			else
				xmlData = Game.database.gamedata.getData(type.dataType, xmlID) as ItemXML;
				
			
			if (xmlData == null)
			{
				//Utility.warning("Can not create xmlData for DataType.ITEM with ID : " + xmlID + ", so will create an empty xmlData with ID = 0 && type = 0");
				//create empty xmlData :
				var itemXML:ItemXML = new ItemXML();
				itemXML.ID = 0;
				itemXML.type = ItemType.EMPTY_SLOT;
				
				xmlData = itemXML;
			}
		}
		
		public function setXMLID(ID:int):void
		{
			xmlData = Game.database.gamedata.getData(DataType.ITEM, ID) as ItemXML;
		}
		
		public function setXMLByType(type:ItemType):void
		{
			var xmlTable:Dictionary = Game.database.gamedata.getTable(DataType.ITEM);
			if (xmlTable)
			{
				for each (var itemXML:ItemXML in xmlTable)
				{
					if (itemXML && itemXML.type == type)
					{
						xmlData = itemXML;
						break;
					}
				}
			}
		}
		
		public function get itemXML():ItemXML
		{
			return xmlData as ItemXML;
		}
		
		public function set itemXML(value:ItemXML):void { xmlData = value; }
		
		public function get isExpired():Boolean
		{
			if (expireTime > 0 || expireTime == -1)
			{
				return false;
			}
			
			return true;
		}
		
		override public function decode(data:ByteArray):void
		{
			
			quantity = data.readInt();
			expireTime = data.readInt();		
		}
	}

}