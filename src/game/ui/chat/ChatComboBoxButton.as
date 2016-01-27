package game.ui.chat 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author ...
	 */
	public class ChatComboBoxButton extends MovieClip
	{
		
		public var buttonNameTf:TextField;
		
		public function ChatComboBoxButton()
		{
			FontUtil.setFont(buttonNameTf, Font.ARIAL, true);			
			this.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			this.gotoAndStop("normal");
		}
		
		public function setButtonName(name:String):void
		{
			buttonNameTf.text = name;
		}
		private function onButtonRollOut(e:MouseEvent):void 
		{
			this.gotoAndStop("normal");
			buttonNameTf.textColor = 0xFFFFFF;	
		}
		
		private function onButtonRollOver(e:MouseEvent):void 
		{
			this.gotoAndStop("active");
			buttonNameTf.textColor = 0xFFFF00;
		}
		
	}

}