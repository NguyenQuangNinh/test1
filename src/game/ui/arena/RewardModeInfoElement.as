package game.ui.arena 
{
	import core.display.BitmapEx;
	import core.Manager;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.data.model.item.IItemConfig;
	import game.enum.Font;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RewardModeInfoElement extends Sprite
	{
		
		private static const ICON_LOADED:String = "icon_loaded";
		
		private var itemSlot	:ItemSlot;
		private var quantityTf  :TextField;
		private var itemConfig:IItemConfig;
		
		public function RewardModeInfoElement() 
		{
			itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			itemSlot.reset();
			itemSlot.x = itemSlot.y = 0;
			itemSlot.scaleX = itemSlot.scaleY = 0.5;
			addChild(itemSlot);
			
			var glow : GlowFilter = new GlowFilter();
			glow.color = 0x000000;
			glow.strength = 2;
			glow.blurX = glow.blurY = 2;
			
			quantityTf = TextFieldUtil.createTextfield(Font.ARIAL, 11, 50, 20, 0xFFFFFF, true, TextFormatAlign.LEFT, [glow]);
			quantityTf.y = 3;
			quantityTf.x = 20;
			this.addChild(quantityTf);
		}
		
		public function reset():void {
			itemSlot.reset();
			Manager.pool.push(itemSlot, ItemSlot);
			quantityTf = null;
			itemConfig = null;
		}
		
		public function setConfigInfo(info : IItemConfig) : void {
			
			if (info != null) {
				this.itemConfig = info;
				itemSlot.setConfigInfo(info, TooltipID.ITEM_COMMON, true);
			}
		}
		
		public function setQuantity(quantity : int) : void {
			quantityTf.text = quantity > 0 ? "x" + quantity.toString() : "";
			itemSlot.setQuantity(quantity, false);
		}		
		
		public function getQuantity(): int {
			return parseInt(quantityTf.text.split("x")[1]);
		}
		
	}

}