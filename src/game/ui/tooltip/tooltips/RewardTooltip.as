package game.ui.tooltip.tooltips 
{
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipBase;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RewardTooltip extends TooltipBase
	{
		public var background : MovieClip;
		public var nameTf : TextField;
		public var descriptionTf : TextField;
		private var _itemsContainer : Sprite = new Sprite();
		protected var data : RewardXML;
		
		public function RewardTooltip() 
		{
			background.scale9Grid = new Rectangle(50, 60, 50, 60);
			
			FontUtil.setFont(nameTf, Font.ARIAL);
			FontUtil.setFont(descriptionTf, Font.ARIAL);
			this.addChild(_itemsContainer);
		}
		
		public function set content(rewardXML : RewardXML) : void {
			var itemConfig : IItemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID);
			
			nameTf.text = itemConfig.getName();
			descriptionTf.text = itemConfig.getDescription();
			
			while (_itemsContainer.numChildren > 0) 
			{
				var child:ItemSlot = _itemsContainer.removeChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
			}
			//var itemSlot : ItemSlot = new ItemSlot();
			var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;			
			itemSlot.setConfigInfo(itemConfig);
			itemSlot.x = 100;
			itemSlot.y = 70;
			itemSlot.setQuantity(rewardXML.quantity);
			this._itemsContainer.addChild(itemSlot);
		}
	}

}
