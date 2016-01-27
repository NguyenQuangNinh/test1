package game.data.model.item 
{
	import game.data.xml.item.ItemXML;
	import game.data.xml.item.MergeItemXML;
	import game.enum.ItemType;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class MergeItem extends BaseItem
	{
		//public var mergeRewards:Array = [];
		
		public function MergeItem() 
		{
			
		}
		
		override public function init(xmlID:int, type:ItemType):void
		{
			super.init(xmlID, type);
			/*xmlData = Game.database.gamedata.getData(DataType.ITEMSOUL, xmlID) as SoulXML;
			if (xmlData == null)
			{
				var soulXML:SoulXML = new SoulXML();
				soulXML.ID = 0;
				soulXML.type = ItemType.EMPTY_SLOT;
				
				xmlData = soulXML;
			}*/
			xmlData = new MergeItemXML();
			xmlData.ID = 0;
			(xmlData as ItemXML).type = ItemType.MERGE_ITEM;
		}
		
		public function addMergeItem(item:ItemXML): void {
			(xmlData as MergeItemXML).addMergeItem(item);
		}
		
	}

}