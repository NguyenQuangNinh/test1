package game.ui.friend
{
	import core.display.layer.Layer;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestFriendList;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.friend.gui.AvatarInfo;
	import game.ui.friend.gui.FriendContainer;
	import game.ui.friend.gui.FriendItem;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class FriendView extends ViewBase
	{
		public static const PAGE_NUM:int = 10;
		
		public var closeBtn:SimpleButton;
		public var avatarInfo:AvatarInfo;
		public var friendContainer:FriendContainer;
		
		public var btnNextLeft:SimpleButton;
		public var btnNextRight:SimpleButton;
		public var btnAddFriend:SimpleButton;

		public var currentPageTf:TextField;
		public var msgTf:TextField;
		
		private var currentPage:int;
		
		public function FriendView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = 902;
				closeBtn.y = 0.2 * closeBtn.height + 91;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			btnNextLeft.addEventListener(MouseEvent.CLICK, onBtnNextLeft);
			btnNextRight.addEventListener(MouseEvent.CLICK, onBtnNextRight);
			btnAddFriend.addEventListener(MouseEvent.CLICK, onBtnAddFriend);
			
			FontUtil.setFont(currentPageTf, Font.ARIAL, true);
			FontUtil.setFont(msgTf, Font.ARIAL, true);
			msgTf.visible = false;
			currentPageTf.text = String(currentPage + 1);
		}
		
		private function onBtnAddFriend(e:Event):void
		{
			Manager.display.showDialog(DialogID.ADD_FRIEND, null, null, null, Layer.BLOCK_BLACK);
		}
		
		private function onBtnNextRight(e:Event):void
		{
			if (!friendContainer.checkOutFriend())
				return;
			currentPage++;
			if (currentPage > 9)
			{
				currentPage = 9;
				return;
			}
			currentPageTf.text = String(currentPage + 1);
			requestFriendList();
		}
		
		private function onBtnNextLeft(e:MouseEvent):void
		{
			currentPage--;
			if (currentPage < 0)
			{
				currentPage = 0;
				return;
			}
			currentPageTf.text = String(currentPage + 1);
			requestFriendList();
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new EventEx(FriendModule.CLOSE_FRIEND_VIEW));
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			currentPage = 0;
			avatarInfo.init();
		}
		
		public function showFriendList(totalFriend:int, arrFriend:Array):void
		{
			var nMaxAddFriend:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_ADD_FRIEND) as int;
			avatarInfo.totalFriendTf.text = "Bạn: " + totalFriend + "/" + nMaxAddFriend;
			updateGiveReceiveAP();

			if (currentPage == 0)
				msgTf.visible = arrFriend.length == 0;
			friendContainer.showFriendList(arrFriend);
		}

		public function notifyReceiveAP(giverID:int):void
		{
			var friend:FriendItem = friendContainer.getFriendItem(giverID);
			if(friend)
			{
				friend.enableReceive(true);
			}
		}

		public function apSuccessHandler(isGive:Boolean = true, playerID:int = 0):void
		{
			var friend:FriendItem = friendContainer.getFriendItem(playerID);
			isGive ? friend.enableGive(false) : friend.enableReceive(false);
			isGive ? Game.database.userdata.giveAPCount++ : Game.database.userdata.receiveAPCount++;
			updateGiveReceiveAP();
		}

		private function updateGiveReceiveAP():void
		{
			var maxGive:int = Game.database.gamedata.getConfigData(202);
			var maxReceive:int = Game.database.gamedata.getConfigData(203);
			var currGive:int = Game.database.userdata.giveAPCount;
			var currReceive:int = Game.database.userdata.receiveAPCount;

			avatarInfo.numOfGiveTf.visible = Game.database.userdata.level >= Game.database.gamedata.getConfigData(201);
			avatarInfo.numOfReceiveTf.visible = Game.database.userdata.level >= Game.database.gamedata.getConfigData(201);

			avatarInfo.numOfGiveTf.text = "Đã tặng thể lực bạn bè: " + currGive + "/" + maxGive;
			avatarInfo.numOfReceiveTf.text = "Đã nhận thể lực bạn bè: " + currReceive + "/" + maxReceive;
		}

		public function requestFriendList():void
		{
			Game.network.lobby.sendPacket(new RequestFriendList(LobbyRequestType.REQUEST_FRIEND_LIST, currentPage * PAGE_NUM, (currentPage + 1) * PAGE_NUM));
		}
	}

}