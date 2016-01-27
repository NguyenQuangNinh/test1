package game.ui.dialog.dialogs
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import core.util.FontUtil;
	
	import game.data.model.item.Item;
	import game.enum.Font;
	import game.ui.components.IconItemSimple;
	
	public class RewardHeroic extends MovieClip
	{
		public var containerIconItem:MovieClip;
		public var txtQuantity:TextField;
		public var markRandom:MovieClip;
		
		private var iconItem:IconItemSimple;
		
		public function RewardHeroic()
		{
			markRandom.mouseChildren = false;
			markRandom.mouseEnabled = false;
			txtQuantity.mouseEnabled = false;
			FontUtil.setFont(txtQuantity, Font.ARIAL, true);
			
			iconItem = new IconItemSimple();
			containerIconItem.addChild(iconItem);
		}
		
		public function setData(item:Item, random:Boolean):void
		{
			iconItem.setData(item);
			txtQuantity.text = "x" + item.quantity.toString();
			this.markRandom.visible = random;
		}
	}
}