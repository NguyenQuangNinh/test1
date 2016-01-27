package game.main
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ListItem extends Sprite
	{
		public var data:Object;
		public var txtName:TextField;
		
		public function ListItem(name:String, data:Object)
		{
			txtName = new TextField();
			txtName.selectable = false;
			txtName.text = name;
			txtName.autoSize = TextFieldAutoSize.LEFT;
			txtName.width = 200;
			txtName.autoSize = TextFieldAutoSize.NONE;
			txtName.multiline = false;
			addChild(txtName);
			
			this.data = data;
			mouseChildren = false;
		}
	}
}