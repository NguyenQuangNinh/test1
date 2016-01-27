package game.ui.ingame
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Bubble extends BaseObject
	{
		public var format:TextFormat;
		
		private var text:TextField;
		private var timeToLive:Number = 1;
		private var currentTime:Number = 0;
		
		public function Bubble()
		{
			text = new TextField();
			format = text.defaultTextFormat;
			format.font = "Arial";
			text.defaultTextFormat = format;
			text.multiline = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			addChild(text);
		}
		
		public function setText(text:String):void
		{
			this.text.defaultTextFormat = format;
			this.text.text = text;
			this.text.cacheAsBitmap = true;
		}
		
		override public function update(delta:Number):void
		{
			y -= delta*30;
			currentTime += delta;
			if(currentTime >= timeToLive) isDead = true;
		}
	}
}