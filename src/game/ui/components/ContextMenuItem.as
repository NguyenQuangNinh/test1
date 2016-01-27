package game.ui.components
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ContextMenuItem extends MovieClip
	{
		public static const HEIGHT:int = 20;
		
		public var txtText:TextField;
		
		private var callback:Function;
		
		public function ContextMenuItem()
		{
			mouseChildren = false;
			reset();
		}
		
		public function reset():void
		{
			txtText.text = "";
		}
		
		public function setText(text:String):void
		{
			txtText.text = text;
		}
		
		public function setCallback(callback:Function):void
		{
			this.callback = callback;
		}
		
		public function execute(data:Object):void
		{
			if(callback != null) callback(data);
		}
	}
}