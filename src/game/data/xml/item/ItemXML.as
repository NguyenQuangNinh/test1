package game.data.xml.item 
{
	import core.util.Enum;
	
	import game.data.model.item.IItemConfig;
	import game.data.xml.XMLData;
	import game.enum.ItemType;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemXML extends XMLData implements IItemConfig
	{
		public var type : ItemType;
		public var name : String = "empty";
		public var description : String="";
		public var maxStackQuantity : int;
		public var expirationTime : int;
		public var value : int;
		public var levelRequirement : int;
		public var filterType : int = -1;
		public var iconURL : String = "";
		//public var animURL : String = "";
		
		
		override public function parseXML(xml : XML) : void {
			
			super.parseXML(xml);
			
			type = Enum.getEnum(ItemType, xml.Type.toString()) as ItemType;
			name = xml.Name.toString();
			description = xml.Description.toString();
			maxStackQuantity = xml.MaxStackQuantity.toString();
			expirationTime = xml.ExpirationTime.toString();
			value = xml.Value.toString();
			levelRequirement = xml.LevelRequirement.toString();
			filterType = xml.FilterType.toString();
			iconURL = xml.IconURL.toString();
			
		}
		
		public function getIconURL() : String {
			return iconURL;
		}		
		public function getName() : String {
			return name;
		}
		public function getDescription() : String {
			return description;
		}
		public function getType(): ItemType {
			return type;
		}
		/*public function getAnimURL(): String {
			return animURL;
		}*/
		
	}
}