package game.ui.gift_online.gui
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.TextFieldUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.data.model.item.IItemConfig;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class GiftItem extends Sprite
	{
		
		protected var iconBmp:BitmapEx;
		public var quantityTf:TextField;
		private var isNoContent:Boolean;
		private var itemConfig:IItemConfig;
		private var quantity:int;
		
		public function GiftItem()
		{
			iconBmp = new BitmapEx();
			iconBmp.addEventListener(BitmapEx.LOADED, onBitmapLoaded)
			this.addChild(iconBmp);
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0x000000;
			glow.strength = 4;
			glow.blurX = glow.blurY = 5;
			
			quantityTf = TextFieldUtil.createTextfield(Font.ARIAL, 12, 50, 16, 0xFFFFFF, false, TextFormatAlign.LEFT, [glow]);
			//quantityTf.borderColor = 0xFF0000;
			//quantityTf.border = true;
			this.addChild(quantityTf);
		}
		
		private function onBitmapLoaded(e:Event):void
		{
			quantityTf.x = iconBmp.width;
			quantityTf.y = iconBmp.height / 2;
		}
		
		public function reset():void
		{
			quantityTf.text = "";
		}
		
		public function setConfigInfo(info:IItemConfig):void
		{
			
			if (info != null)
			{
				this.itemConfig = info;
				iconBmp.load(info.getIconURL());
				if (!this.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
				}
				
				if (!this.hasEventListener(MouseEvent.ROLL_OUT))
				{
					this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
				}
			}
			else
			{
				isNoContent = true;
			}
		}
		
		private function onRollOutHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOverHdl(e:MouseEvent):void
		{
			if(itemConfig)
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.ITEM_COMMON, value: itemConfig, quantity:quantity}, true));
		}
		
		public function setQuantity(quantity:int):void
		{
			this.quantity = quantity;
			if (!isNoContent)
			{
				quantityTf.text = "x" + quantity;
				quantityTf.visible = true;
			}
		}
		
		public function setScaleItemSlot(scale:Number):void
		{
			iconBmp.scaleX = iconBmp.scaleY = scale;
			quantityTf.x = iconBmp.width;
			quantityTf.y = iconBmp.height / 2;
		}
	}

}