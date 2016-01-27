package game.ui.chat 
{
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.enum.Font;
	/**
	 * ...
	 * @author ...
	 */
	public class ChatChanelButton extends MovieClip
	{
		public static const NORMAL:String = "normal";
		public static const ACTIVE:String = "active";
		
		public var buttonNameTf:TextField;
		private var selected:Boolean;
		
		public function ChatChanelButton() 
		{
			FontUtil.setFont(buttonNameTf, Font.ARIAL, true);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			buttonNameTf.mouseEnabled = false;
			selected = false;
			this.buttonMode = true;
		}
		
		public function setButtonName(buttonName:String, color:int = -1): void
		{
			buttonNameTf.text = buttonName;
			if (color != -1)
			{
				buttonNameTf.textColor = color;
			}
		}
		
		public function setSelected(value:Boolean):void
		{
			selected = value;
			if (selected)
			{				
				this.gotoAndStop(ACTIVE);
				buttonNameTf.textColor = 0xFFFF00;
			}
			else
			{
				this.gotoAndStop(NORMAL);
				buttonNameTf.textColor = 0xFFFFFF;
			}
			
		}
		
		public function getButtonName():String
		{
			return buttonNameTf.text;
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			if (!selected)
			{
				this.gotoAndStop(NORMAL);
				buttonNameTf.textColor = 0xFFFFFF;
			}			
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			this.gotoAndStop(ACTIVE);
			buttonNameTf.textColor = 0xFFFF00;
		}
		
	}

}