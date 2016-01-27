package game.data.xml.item 
{
	import game.data.model.item.IItemConfig;
	import game.data.xml.XMLData;
	import game.enum.ItemType;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class MergeItemXML extends ItemXML
	{
		
		private var mergeItems:Array = [];
		
		public function MergeItemXML() 
		{
			
		}
		
		public function setIconURL(url:String): void {
			iconURL = url;
		}
		public function setName(itemName:String): void {
			name = itemName;
		}
		public function setDescription(desc:String): void {
			description = desc;
		}
		public function setType(itemType:ItemType): void {
			type = itemType;
		}
		
		public function addMergeItem(item:XMLData):void {
			mergeItems.push(item);
		}		
		
		public function getMergeItem():Array {
			return mergeItems;
		}
	}

}