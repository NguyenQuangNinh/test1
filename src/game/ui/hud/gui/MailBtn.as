package game.ui.hud.gui
{
	import com.greensock.TweenMax;
	
	import core.util.FontUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import game.enum.Font;
	import game.ui.hud.HUDButtonID;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class MailBtn extends HUDButton
	{
		public var notify:MovieClip;
		public var newMailTf:TextField;
		
		public function MailBtn()
		{
			FontUtil.setFont(newMailTf, Font.ARIAL, true);
			newMailTf.text = "";
			notify.visible = false;
			ID = HUDButtonID.MAIL;
		}
		
		override public function setNotify(val:Boolean, jsonData:Object):void
		{
			super.setNotify(val, jsonData);
			notify.visible = val;
			if (jsonData)
				newMailTf.text = jsonData.newmail;
			else
				newMailTf.text = "";
		}
	}

}