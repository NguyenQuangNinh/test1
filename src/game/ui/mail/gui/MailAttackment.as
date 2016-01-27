package game.ui.mail.gui
{
	import core.Manager;
	import core.util.Enum;
	import core.util.Utility;
	
	import flash.display.MovieClip;
	
	import game.data.model.item.ItemFactory;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class MailAttackment extends MovieClip
	{
		
		private var _itemSlot:ItemSlot;
		
		public function MailAttackment()
		{
		
		}
		
		public function init(id:int, type:int, quantity:int):void
		{
			var itemType:ItemType = Enum.getEnum(ItemType, type) as ItemType;
			
			if (id < 0 || itemType == null || quantity < 0)
				Utility.log("MailAttackment ERROR -> type:" + itemType + " id:" + id + " quantity:" + quantity);
			
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(itemType, id));
			_itemSlot.setQuantity(quantity);
			_itemSlot.x = 5;
			_itemSlot.y = 7;
			this.addChild(_itemSlot);
		}
		
		public function destroy():void
		{
			if (_itemSlot)
			{
				_itemSlot.reset();
				Manager.pool.push(_itemSlot, ItemSlot);
			}
		}
	}

}