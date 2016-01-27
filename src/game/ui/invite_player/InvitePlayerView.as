package game.ui.invite_player 
{	
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	import game.enum.PlayerType;
	import game.ui.components.PagingMov;
	import game.ui.components.PlayerInvite;
	import game.ui.components.ScrollBar;
	import game.ui.components.tab.Tab;
	import game.ui.components.tab.TabButton;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class InvitePlayerView extends ViewBase
	{
		public static const MAX_PLAYER_SHOW_IN_LIST:int = 8;
		private static const DISTANCE_PER_PLAYER:int = 3;
		
		private static const PLAYER_START_FROM_X:int = 5;
		private static const PLAYER_START_FROM_Y:int = 5;
		
		public static const TAB_FRIEND:int = 0;	//1
		public static const TAB_GUIDE:int = 1;	//2
		public static const TAB_SERVER:int = 2;	//0
		
		public var maskMov:MovieClip;
		public var closeBtn:SimpleButton;
		
		private var _players:Array;
		private var _content:MovieClip;
		private var _scroll:ScrollBar;		
		private var _paging:PagingMov;
		
		public var friendMov:MovieClip;
		private var _friendPage:MovieClip;
		public var serverMov:MovieClip;
		private var _serverPage:MovieClip;
		
		public var messageTf:TextField;
		//public var guideMov:MovieClip;
		//private var _guidePage:MovieClip;
		private var _tabManager:Tab;
		
		public function InvitePlayerView() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}*/
		
		private function initUI():void 
		{
			//init UI
			FontUtil.setFont(messageTf, Font.ARIAL, false);
			
			_content = new MovieClip();
			_content.x = maskMov.x;
			_content.y = maskMov.y;
			_content.mask = maskMov;
			addChild(_content);
			
			_scroll = new ScrollBar();
			_scroll.x = maskMov.x + maskMov.width;
			_scroll.y = maskMov.y;
			addChild(_scroll);
			
			_paging = new PagingMov();
			_paging.x = maskMov.x + (maskMov.width - _paging.width) / 2;
			_paging.y = maskMov.y + maskMov.height + 5;
			addChild(_paging);
			
			//init friend page
			_friendPage = new MovieClip();			
			_content.addChild(_friendPage);
			
			//init guide page
			//_guidePage = new MovieClip();			
			//_content.addChild(_guidePage);
			
			//init server page
			_serverPage = new MovieClip();			
			_content.addChild(_serverPage);
			
			_tabManager = new Tab();
			_tabManager.addTab("friend", _friendPage, friendMov);
			_tabManager.addTab("server", _serverPage, serverMov);
			//_tabManager.addTab("guide", _guidePage, guideMov);	
			addChild(_tabManager);

            serverMov.visible = false;

			//add events
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case closeBtn:
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}
		
		public function updatePlayers(data:Array):void {
			if(data) {
				//clear content
				var currentPage:MovieClip;
				switch(_tabManager.activeTabIndex()) {
					case PlayerType.FRIEND_PLAYER.ID:
						currentPage = _friendPage;
						break;
					case PlayerType.SERVER_PLAYER.ID:
						currentPage = _serverPage;
						break;	
					/*case TAB_GUIDE:
						currentPage = _guidePage;
						break;*/
				}
				MovieClipUtils.removeAllChildren(currentPage);				
				var player:PlayerInvite;
				for (var i:int = 0; i < data.length; i++) {
					player = new PlayerInvite();
					player.x = (player.width) * (i % 2);
					player.y = (player.height) * (int) (i / 2);
					
					currentPage.addChild(player);					
					player.update(data[i] as LobbyPlayerInfo, false);
				}
				//update scroll
				//_scroll.init(_content, maskMov, "vertical", true, false, true);	
				if (data.length == 0) {
					messageTf.text = "Hiện không có người chơi nào trong danh sách";
				}else  {
					messageTf.text = "";
				}
				
			}			
		}
		
		public function updatePaging(current:int, total:int):void {
			_paging.visible = current > 0;
			_paging.update(current, total);
		}
		
		override public function transitionIn():void 
		{
			super.transitionIn();
			_tabManager.setActive(PlayerType.FRIEND_PLAYER.ID);
		}
		
		public function updatePlayerSelected(index:int):void {			
			var currentPage:MovieClip;
			switch(_tabManager.activeTabIndex()) {
				case PlayerType.FRIEND_PLAYER.ID:
					currentPage = _friendPage;
					break;
				case PlayerType.SERVER_PLAYER.ID:
					currentPage = _serverPage;
					break;
				/*case TAB_GUIDE:
					currentPage = _guidePage;
					break;*/
			}
			var child:PlayerInvite;
			for (var i:int = 0; i < currentPage.numChildren; i++) {
				child = currentPage.getChildAt(i) as PlayerInvite;
				if (i == index) {
					child.enableCheck(true);
					break;
				}
			}
		}
	}

}