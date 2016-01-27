package game.ui.guild.popups 
{
	import components.popups.OKCancelPopup;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.guild.popups.join_request.JoinRequestList;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ViewJoinRequestPopup extends OKCancelPopup
	{
		public var list:JoinRequestList;
		
		public function ViewJoinRequestPopup() 
		{
			
		}
		
		override public function show(callback:Function = null, title:String = "", msg:String = "", data:Object = null, isHideCancelBtn:Boolean = false):void
		{
			super.show(callback, title, msg, data);
			list.getRequestList();
		}
		
	}

}