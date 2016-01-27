package game.ui.components
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import core.util.FontUtil;
	
	import game.data.model.item.Item;
	import game.enum.Font;
	
	public class Reward1 extends MovieClip
	{
		public var iconItem:IconItemSimple;
		public var iconItemContainer:MovieClip;
		public var txtQuantity:TextField;
		
		public function Reward1()
		{
			FontUtil.setFont(txtQuantity, Font.ARIAL, true);
			
			iconItem = new IconItemSimple();
			iconItem.scaleX = iconItem.scaleY = 0.5;
			iconItemContainer.addChild(iconItem);
		}
		
		public function setData(item:Item):void
		{
			iconItem.setData(item);
			txtQuantity.text = "x" + item.quantity;
			txtQuantity.autoSize = TextFieldAutoSize.LEFT;
		}
	}
}