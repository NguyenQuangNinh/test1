package game.ui.present.gui
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentButton extends MovieClip
	{
		public static const BTN_PRESENT_MOUSE_CLICK:String = "btnPresentMouseClick";
		
		
		public var notify:MovieClip;
		public var hitMovie:MovieClip;
		public var nameTf:TextField;
		
		
		private var _isSelected:Boolean;
		private var _index:int;
		
		public function PresentButton(name:String, index:int)
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			
			nameTf.text = name.toUpperCase();
			_index = index;
			isSelected = false;
			notify.visible = false;
			notify.mouseChildren = false;
			notify.mouseEnabled = false;
			hitMovie.buttonMode = true;
			hitMovie.visible = true;
			hitMovie.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			isSelected = true;
			this.dispatchEvent(new EventEx(BTN_PRESENT_MOUSE_CLICK, _index, true));
		}
		
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
			if (_isSelected)
			{
				notify.visible = false;
				this.gotoAndStop("active");
			}
			else
				this.gotoAndStop("normal");
		}
		
		public function setNotify(val:Boolean):void
		{
			notify.visible = val;
		}
	}

}