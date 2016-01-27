package game.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class Button extends Sprite
	{
		private var textfield:TextField;
		
		public function Button(text:String)
		{
			textfield = new TextField();
			textfield.text = text;
			textfield.autoSize = TextFieldAutoSize.CENTER;
			textfield.selectable = false;
			textfield.border = true;
			textfield.x = 0;
			textfield.y = 0;
			addChild(textfield);
		}
	}
}