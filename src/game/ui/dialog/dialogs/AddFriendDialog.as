package game.ui.dialog.dialogs
{
	import core.display.layer.Layer;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.FriendManager;
	import game.Game;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class AddFriendDialog extends Dialog
	{
		public var nameTf:TextField;
		public var btnAddFriend:SimpleButton;
		public var closeBtn:SimpleButton;
		
		public function AddFriendDialog()
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			btnAddFriend.addEventListener(MouseEvent.CLICK, btnAddFriendClick);
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseClickHdl);
		}
		
		private function onCloseClickHdl(e:MouseEvent):void
		{
			close();
		}
		
		private function btnAddFriendClick(e:Event):void
		{
			var roleName:String = nameTf.text;
			if (roleName != "")
			{
				Game.friend.addFriendByRoleName(roleName);
			}
		}
		
		override public function onShow():void 
		{
			super.onShow();
			nameTf.text = "";
		}
	}

}