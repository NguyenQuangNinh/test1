package game.ui.attendance
{
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import game.enum.Font;

	/**
	 * ...
	 * @author anhpnh2
	 */
	public class AttendanceTap extends MovieClip
	{
		public function AttendanceTap()
		{
			super();
			FontUtil.setFont(tabName, Font.ARIAL);
			tabName.mouseEnabled = false;
		}

		public var tabName:TextField;

		private var _info:AttendendTapInfo;

		public function set info(info:AttendendTapInfo):void
		{
			_info = info;
			tabName.text = _info.index + " lần";
		}

		public function get arrReward():Array
		{
			return _info.arrReward;
		}

		public function get index():int
		{
			return _info.index;
		}
	}

}