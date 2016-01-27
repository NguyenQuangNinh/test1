package game.ui.tooltip.tooltips 
{
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.vo.item.ItemChestInfo;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.item.ItemXML;
	import game.enum.Font;
	import game.ui.components.ItemSlot;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemSetTooltip extends ItemTooltip
	{
		private static const ITEM_WIDTH : uint = 64;
		
		private var _container : Sprite = new Sprite();
		
		
		public function ItemSetTooltip() 
		{
			
			super();
			this.addChild(_container);
			
		}
		
		override public function setData(itemConfig : IItemConfig) : void {
			
			if (! (itemConfig is ItemChestXML)) {
				Utility.error("Set invalid data type, need ItemChestXML data type");
				return ;
			}
			if ( this.data == itemConfig) {
				return;				
			}
			this.data = itemConfig;
			
			var itemChestXML : ItemChestXML = itemConfig as ItemChestXML;
			
			while (_container.numChildren > 0) 
			{
				//container.removeChildAt(0);
				var child:ItemSlot = _container.getChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
				_container.removeChild(child);
			}
			
			nameTf.text = itemChestXML.name;
			descriptionTf.text = itemChestXML.description;
			
			var numItems : int = itemChestXML.items.length
			background.height = 90 + Math.ceil(numItems / 3) * ITEM_WIDTH;
			
			var index: int = 0;
			for each (var itemChestInfo:ItemChestInfo in itemChestXML.items) 
			{
				//var itemSlot : ItemSlot = new ItemSlot();
				var itemSlot : ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				itemSlot.setConfigInfo(ItemFactory.buildItemConfig(itemChestInfo.type, itemChestInfo.id));
				itemSlot.setQuantity(itemChestInfo.quantity);
				
				itemSlot.x = (index % 3) * ITEM_WIDTH + 5;
				itemSlot.y = Math.floor(index / 3) * ITEM_WIDTH + 30;
				
				this._container.addChild(itemSlot);
				
				index++;
			}
			
			var containerWidth : int = Math.min(3, numItems) * ITEM_WIDTH;
			//_container.x = (background.width - containerWidth) / 2;
			//_container.y = 40;
			_container.x = 10;
			_container.y = 20;
			
			descriptionTf.y = 52 +  Math.ceil(numItems / 3) * ITEM_WIDTH;
		}
	}

}