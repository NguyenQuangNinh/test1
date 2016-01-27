package game.ui.soul_center.gui
{
	import core.display.animation.Animator;
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.data.model.item.ItemFactory;
	import game.data.model.item.SoulItem;
	import game.enum.ItemType;
	//import game.ui.components.ItemSlot;
	import game.ui.soul_center.event.EventSoulCenter;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SellableSoulSlot extends Sprite
	{
		public var bgMov:MovieClip;
		public var getBtn:SimpleButton;
		public var sellBtn:SimpleButton;
		private var soulItem:SoulItem;
		public var itemSlot:Animator;
		
		public function SellableSoulSlot()
		{
			sellBtn.addEventListener(MouseEvent.CLICK, onSell);
			getBtn.addEventListener(MouseEvent.CLICK, onGet);
		
		}
		
		public function getIndex():int
		{
			return soulItem.index;
		}
		
		private function onGet(e:MouseEvent):void
		{
			this.dispatchEvent(new EventSoulCenter(EventSoulCenter.COLLECT_SOUL, soulItem.index, true));
		}
		
		private function onSell(e:MouseEvent):void
		{
			this.dispatchEvent(new EventSoulCenter(EventSoulCenter.SELL_SOUL, soulItem.index, true));
		}
		
		public function setData(soulItem:SoulItem = null):void
		{
			
			this.soulItem = soulItem;
			itemSlot = new Animator();
			
			itemSlot.setCacheEnabled(false);
			if (!itemSlot.hasEventListener(Animator.LOADED))
				itemSlot.addEventListener(Animator.LOADED, onAnimLoaded);
			itemSlot.load(soulItem.soulXML.animURL);
			
			if (soulItem.soulXML.type == ItemType.ITEM_BAD_SOUL)
			{
				getBtn.enabled = false;
				getBtn.visible = false;
			}
			itemSlot.x = 31 - 2;
			itemSlot.y = 28;
			this.addChild(itemSlot);
			
			this.itemSlot.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
			this.itemSlot.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
		}

		public function get isBad():Boolean
		{
			return soulItem && soulItem.soulXML.type == ItemType.ITEM_BAD_SOUL;
		}

		private function onAnimLoaded(e:Event):void
		{
			var index:int = Math.min(itemSlot.getAnimationCount() - 1, soulItem.level - 1)
			itemSlot.play(index);
		}
		
		public function prepairForRemove():void
		{
			
			bgMov.visible = false;
			getBtn.visible = false;
			sellBtn.visible = false;
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		public function reset():void
		{
			this.mouseChildren = true;
			this.mouseEnabled = true;
			if (itemSlot != null)
			{
				itemSlot.scaleX = itemSlot.scaleY = 1;
			}
			
			bgMov.visible = true;
			sellBtn.visible = true;
			
			if (soulItem != null && soulItem.soulXML.type == ItemType.ITEM_BAD_SOUL)
			{
				getBtn.enabled = false;
				getBtn.visible = false;
			}
			else
			{
				getBtn.visible = true;
			}
		}
		
		private function onRollOutHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOverHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SOUL, value: this.soulItem}, true));
		}
	}

}