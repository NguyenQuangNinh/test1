package game.ui.effect.gui
{
	import core.display.animation.Animator;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.data.model.item.ItemFactory;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ItemSlotEffect extends MovieClip
	{		
		public function ItemSlotEffect()
		{
			/*_effectAnim = new Animator();
			_effectAnim.setCacheEnabled(false);
			_effectAnim.x = 20;
			_effectAnim.y = 20;
			_effectAnim.load("resource/anim/ui/hieuung_nhanthuong.banim");*/
			
		}
		
		public function init(itemSlot:ItemSlot, bonusText:String = ""):void
		{
			//if (itemSlot.getItemType() != ItemType.EXP && itemSlot.getItemType() != ItemType.GOLD && itemSlot.getItemType() != ItemType.HONOR)
				//this.addChild(_effectAnim);			
			this.x = itemSlot.x;
			this.y = itemSlot.y;			
			itemSlot.x = 0;
			itemSlot.y = 0;
			this.addChild(itemSlot);
		}
	}

}