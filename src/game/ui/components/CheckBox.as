package game.ui.components
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class CheckBox extends MovieClip
	{
		public static const CHANGED:String = "changed";

		public static const BACKGROUND_STYLE_SQUARE:int = 1;
		public static const BACKGROUND_STYLE_ROUND:int = 2;

		public var tick:MovieClip;
		public var background:MovieClip;
		private var enableToggle:Boolean;

		public function CheckBox()
		{
			tick.mouseEnabled = false;
			enableToggle = true;
			setBackgroundStype(BACKGROUND_STYLE_SQUARE);
			addEventListener(MouseEvent.CLICK, onClicked);
		}

		public function setEnableToogle(value:Boolean):void
		{
			enableToggle = value;
		}

		public function setLabel(tf:TextField):void
		{
			if(tf)
			{
				addChild(tf);
				tf.x = background.x + background.width;
				tf.y = background.y - tf.height / 2;
			}
		}

		protected function onClicked(event:MouseEvent):void
		{
			if (enableToggle)
			{
				setChecked(!isChecked());
			}
			else
			{
				if (!isChecked())
				{
					setChecked(!isChecked());
				}
			}
		}

		public function setBackgroundStype(styleID:int):void
		{
			background.gotoAndStop(styleID);
		}

		public function isChecked():Boolean { return tick.visible; }

		public function setChecked(value:Boolean):void
		{
			tick.visible = value;
			dispatchEvent(new Event(CHANGED));
		}
	}
}