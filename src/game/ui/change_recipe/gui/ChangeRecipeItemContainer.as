package game.ui.change_recipe.gui
{
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.Inventory;
	import game.data.model.item.Item;
	import game.data.model.item.ItemFactory;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChangeRecipeItemContainer extends MovieClip
	{
		public var bgMovie:MovieClip;
		public var msgTf:TextField;
		
		private var _arrItemSlots:Array = [];
		
		private var _posWidth:int = 0;
		private var _posHeight:int = 0;
		
		public function ChangeRecipeItemContainer()
		{
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			_posWidth = bgMovie.width;
			_posHeight = bgMovie.height;
			
		}
		
		public function init(itemType:ItemType):void
		{
			if (itemType)
			{
				reset();
				
				//get item inventory
				var arrItems:Array = [];
				var arrItemsTemp:Array = [];
				if (itemType == ItemType.FORMATION_TYPE_SCROLL)
				{
					arrItemsTemp = Game.database.inventory.getItemsByType(itemType);
				}
				else if (itemType == ItemType.SKILL_SCROLL || itemType == ItemType.SKILL_SCROLL_FIRE ||
						itemType == ItemType.SKILL_SCROLL_EARTH || itemType == ItemType.SKILL_SCROLL_METAL ||
						itemType == ItemType.SKILL_SCROLL_WATER || itemType == ItemType.SKILL_SCROLL_WOOD)
				{
					var arrType:Array = [ItemType.SKILL_SCROLL_FIRE, ItemType.SKILL_SCROLL_EARTH, ItemType.SKILL_SCROLL_METAL, ItemType.SKILL_SCROLL_WATER, ItemType.SKILL_SCROLL_WOOD];
					arrItemsTemp = Game.database.inventory.getItemsByArrayType(arrType);
				}
				else if (itemType == ItemType.MASTER_INVITATION_CHEST)
				{
					var ls:Array = Game.database.inventory.getItemsByType(itemType);
					for each (var data:Item in ls)
					{
						//Filter thiep cao nhan So Cap
						if(data.xmlData.ID == 128)
						{
							arrItemsTemp.push(data);
						}
					}
				}
				
				//group
				
				for each (var itemTemp:Item in arrItemsTemp)
				{
					var flag:Boolean = true;
					for each(var itemTemp1:Item in arrItems)
					{
						if (itemTemp && itemTemp.itemXML 
						&& itemTemp.itemXML.type == itemTemp1.itemXML.type 
						&&  itemTemp.itemXML.value == itemTemp1.itemXML.value)
						{
							itemTemp1.quantity += itemTemp.quantity;
							flag = false;
							break;
						}
					}
					if (flag)
					{
						var itemX:Item = new Item();
						itemX.itemXML = itemTemp.itemXML;
						itemX.quantity = itemTemp.quantity;
						arrItems.push(itemX);
					}
				}
				arrItemsTemp = [];
				
				msgTf.visible = arrItems.length == 0;
				
				if (arrItems.length > 0)
				{
					var indexWidth:int = 0;
					var indexHieght:int = 0;
					
					var num:int = 4;
					bgMovie.width = (arrItems.length >= num ? num : arrItems.length) * 60 + 20;
					bgMovie.height = Math.round((arrItems.length / num) + 0.5) * 60 + 20;
					
					for each (var item:Item in arrItems)
					{
						if (item)
						{
							if (indexWidth >= num)
							{
								indexWidth = 0;
								indexHieght++;
							}
							var itemSlot:ChangeRecipeItem = new ChangeRecipeItem();
							itemSlot.x = 15 + 60 * indexWidth++;
							itemSlot.y = 15 + indexHieght * 60;
							itemSlot.init(item.itemXML.ID, item.itemXML.type, item.quantity);
							_arrItemSlots.push(itemSlot);
							this.addChild(itemSlot);
						}
					}
				}
				else
				{
					bgMovie.width = _posWidth;
					bgMovie.height = _posHeight;
					msgTf.text = "Bạn không có " + itemType.name + " trong Hành Trang";
				}
			}
		}
		
		public function reset():void
		{
			for each (var itemSlot:ChangeRecipeItem in _arrItemSlots)
			{
				if (itemSlot)
				{
					itemSlot.destroy();
					this.removeChild(itemSlot);
				}
			}
			_arrItemSlots = [];
		}
	}

}