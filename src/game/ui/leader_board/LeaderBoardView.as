package game.ui.leader_board 
{
	import core.Manager;
	import core.display.ViewBase;
	import core.display.layer.Layer;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.challenge_center.RankingRecordData;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.LeaderBoardTypeEnum;
	import game.ui.ModuleID;
	import game.ui.components.PagingMov;
	import game.ui.components.ScrollBar;
	import game.ui.components.tab.Tab;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LeaderBoardView extends ViewBase
	{
		public static const MAX_PLAYER_SHOW_IN_LIST:int = 8;
		public static const MAX_PLAYER_TOP_SHOW_IN_LIST:int = 5;
		private static const DISTANCE_PER_PLAYER:int = 29;
		
		private static const OPEN_FINISH:String = "openFinish";
		
		/*public static const TAB_DAMAGE:int = 0;
		public static const TAB_1vs1:int = 1;
		public static const TAB_LEVEL:int = 2;
		public static const TAB_TOP_ELO_1VS1:int = 3;*/
		
		//public var maskMov:MovieClip;
		public var playerInfoMov:LeaderBoardPlayerInfoUI;
		public var playersMov:MovieClip;
		
		//txt
		public var rankTf:TextField;
		public var nameTf:TextField;
		public var valueTf:TextField;
		
		//private var _scroll:ScrollBar;
		private var _btnClose:SimpleButton;
		private var _paging:PagingMov;
		
		public var levelBtn:MovieClip;
		private var _levelPage:MovieClip;
		
		public var damageBtn:MovieClip;
		private var _damagePage:MovieClip;
		
		public var pvp1vs1Btn:MovieClip;
		private var _pvp1vs1Page:MovieClip;
		
		public var pvp1vs1ChallengeBtn:MovieClip;
		private var _pvp1vs1ChallengePage:MovieClip;
		
		//private var guildBtn:MovieClip = new MovieClip();
		//private var _guildPage:MovieClip = new MovieClip();
		
		public var pvp3vs3Btn:MovieClip;
		private var _pvp3vs3Page:MovieClip;
		
		public var heroicTowerBtn:MovieClip;
		private var _heroicTowerPage:MovieClip;				
		
		private var _tabManager:Tab;
		private var _data:Array = [];
		
		private var _playersTopMov:MovieClip;
		
		private static const PLAYERS_TOP_START_FROM_X:int = 570;
		private static const PLAYERS_TOP_START_FROM_Y:int = 140;
		private static const PLAYER_TOP_DISTANCE_DELTA_X:int = 180;
		private static const PLAYER_TOP_DISTANCE_DELTA_Y:int = 5;
		
		private static const PAGING_START_FROM_X:int = 560;
		private static const PAGING_START_FROM_Y:int = 548;
		
		public function LeaderBoardView() 
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
			/*//first stop
			addFrameScript(0, function():void {
				stop();
				//trace("effect call stop 1");
			});
			
			//second stop
			var openStopFrame:int = this.totalFrames;
			addFrameScript(openStopFrame - 2, function():void {
				stop();
				//trace("effect call stop 2");
				dispatchEvent(new Event("openFinish"));
			});*/
			
			//init UI
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			rankTf.text = "Hạng";
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			nameTf.text = "Tên";
			FontUtil.setFont(valueTf, Font.ARIAL, true);
			
			pvp1vs1Btn.buttonMode = true;
			damageBtn.buttonMode = true;
			levelBtn.buttonMode = true;
			pvp1vs1ChallengeBtn.buttonMode = true;
			
			FontUtil.setFont(damageBtn["nameTf"] as TextField, Font.ARIAL, true);
			(damageBtn["nameTf"] as TextField).text = "Lực chiến";
			FontUtil.setFont(pvp1vs1Btn["nameTf"] as TextField, Font.ARIAL, true);
			(pvp1vs1Btn["nameTf"] as TextField).text = "Võ lâm minh chủ";
			FontUtil.setFont(levelBtn["nameTf"] as TextField, Font.ARIAL, true);
			(levelBtn["nameTf"] as TextField).text = "Cấp độ";
			FontUtil.setFont(pvp1vs1ChallengeBtn["nameTf"] as TextField, Font.ARIAL, true);
			(pvp1vs1ChallengeBtn["nameTf"] as TextField).text = "Hoa sơn luận kiếm";
			FontUtil.setFont(pvp3vs3Btn["nameTf"] as TextField, Font.ARIAL, true);
			(pvp3vs3Btn["nameTf"] as TextField).text = "Tam hùng kì hiệp";
			FontUtil.setFont(heroicTowerBtn["nameTf"] as TextField, Font.ARIAL, true);
			(heroicTowerBtn["nameTf"] as TextField).text = "Tháp cao thủ";
			
			//init players top container
			_playersTopMov = new MovieClip();
			_playersTopMov.x = PLAYERS_TOP_START_FROM_X;
			_playersTopMov.y = PLAYERS_TOP_START_FROM_Y;
			var playerTop:LeaderBoardPlayerTop;
			for (var j:int = 0; j < MAX_PLAYER_TOP_SHOW_IN_LIST; j++) {
				playerTop = new LeaderBoardPlayerTop();
				playerTop.x  = PLAYER_TOP_DISTANCE_DELTA_X * ((j % 2 == 0) ? Math.ceil(j/2) : -Math.ceil(j/2));
				playerTop.y  = PLAYER_TOP_DISTANCE_DELTA_Y * Math.ceil(j / 2);
				Utility.log("player top pos is :" + playerTop.x + " // " + playerTop.y);
				_playersTopMov.addChild(playerTop);				
			}
			addChild(_playersTopMov);
			
			
			/*_scroll = new ScrollBar();
			_scroll.x = maskMov.x + maskMov.width;
			_scroll.y = maskMov.y + (maskMov.height - _scroll.height) / 2 + 30;
			addChild(_scroll);*/
			
			_paging = new PagingMov();
			_paging.x = PAGING_START_FROM_X;
			_paging.y = PAGING_START_FROM_Y;
			addChild(_paging);
			
			//init level page
			_levelPage = new MovieClip();			
			playersMov.addChild(_levelPage);			
			
			//init damage page
			_damagePage = new MovieClip();			
			playersMov.addChild(_damagePage);
			
			//init vo lam minh chu page
			_pvp1vs1Page = new MovieClip();			
			playersMov.addChild(_pvp1vs1Page);
			
			//init hoa son luan kiem page
			_pvp1vs1ChallengePage = new MovieClip();
			playersMov.addChild(_pvp1vs1ChallengePage);
			
			//init tam hung ki hiep page
			_pvp3vs3Page = new MovieClip();
			playersMov.addChild(_pvp3vs3Page);
			
			//init thap cao thu page
			_heroicTowerPage = new MovieClip();
			playersMov.addChild(_heroicTowerPage);
			
			/*Cấp độ
			Lực chiến
			Hoa sơn luận kiếm : Lấy trong bảng xếp hạng tính năng ra.
			Tam hung kỳ hiệp : Lấy trong bảng xếp hạng tính năng ra. Tuần cuối.
			Võ lâm minh chủ: Lấy trong bảng xếp hạng tính năng ra. Tuần cuối.
			Tháp cao thủ: Lấy trong bảng xếp hạng tính năng ra.*/
			
			/*public static const TOP_NONE	:int = 0;
			public static const TOP_1vs1_AI	:int = 1;
			public static const TOP_LEVEL	:int = 2;
			public static const TOP_1VS1_MM	:int = 3;
			public static const TOP_GUILD	:int = 4;
			public static const TOP_3VS3_MM	:int = 5;
			public static const HEROIC_TOWER:int = 6;
			public static const TOP_DAMAGE	:int = 7;*/
			
			_tabManager = new Tab();
			_tabManager.addTab("Cấp độ", _levelPage, levelBtn);
			_tabManager.addTab("Lực chiến", _damagePage, damageBtn);
			_tabManager.addTab("Hoa Sơn Luận Kiếm", _pvp1vs1ChallengePage, pvp1vs1ChallengeBtn);
			_tabManager.addTab("Tam Hùng Kì Hiệp", _pvp3vs3Page, pvp3vs3Btn);
			_tabManager.addTab("Võ Lâm Minh Chủ", _pvp1vs1Page, pvp1vs1Btn);
			_tabManager.addTab("Tháp Cao Thủ", _heroicTowerPage, heroicTowerBtn);
			//_tabManager.addTab("Bang hội", _guildPage, guildBtn);
			addChild(_tabManager);
			
			_btnClose = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			_btnClose.x = 1075;
			_btnClose.y =  110;
			//Utility.log( "btnBack : " + _btnBack.x + " // " + _btnBack.y );
			addChild(_btnClose);
			
			//init events
			_btnClose.addEventListener(MouseEvent.CLICK, onCloseClickHdl);
		}
		
		private function onCloseClickHdl(e:MouseEvent):void 
		{			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function updatePlayers(pageNum:int, data:Array):void {
			_data = data;
			if (_data) {
				//clear content
				var page:MovieClip;
				var player:LeaderBoardPlayer;
				
				if(_tabManager.activeTabIndex() == LeaderBoardTypeEnum.HEROIC_TOWER.ID) {
					//prepare data for heroic display
					_data = [];
					for each(var record:RankingRecordData in data) {
						var info:LobbyPlayerInfo = new LobbyPlayerInfo();
						info.id = record.playerID;
						info.name = record.name;
						info.maxFloor = record.maxFloor;
						info.index = record.rank;
						_data.push(info);
					}
				}
				
				switch(_tabManager.activeTabIndex()) {
					case LeaderBoardTypeEnum.TOP_1vs1_AI.ID:
						page = _pvp1vs1ChallengePage;
						valueTf.text = "Cấp độ";											
						break;
					case LeaderBoardTypeEnum.TOP_LEVEL.ID:
						page = _levelPage;
						valueTf.text = "Cấp độ";
						break;
					case LeaderBoardTypeEnum.TOP_DAMAGE.ID:
						page = _damagePage;
						valueTf.text = "Lực chiến";
						break;
					case LeaderBoardTypeEnum.TOP_1VS1_MM.ID:
						page = _pvp1vs1Page;
						valueTf.text = "Uy danh";
						break;
					case LeaderBoardTypeEnum.TOP_3VS3_MM.ID:
						page = _pvp3vs3Page;
						valueTf.text = "Uy danh";
						break;
					case LeaderBoardTypeEnum.HEROIC_TOWER.ID:
						page = _heroicTowerPage;
						valueTf.text = "Tầng";						
						break;
				}
				MovieClipUtils.removeAllChildren(page);		
				var count:int = Math.min(MAX_PLAYER_SHOW_IN_LIST, _data.length);
				var topType:LeaderBoardTypeEnum = Enum.getEnum(LeaderBoardTypeEnum, _tabManager.activeTabIndex()) as LeaderBoardTypeEnum;
				for (var i:int = 0; i < count; i++) {
					player = new LeaderBoardPlayer();
					player.updateInfo(pageNum * MAX_PLAYER_SHOW_IN_LIST + i + 1, _data[i] as LobbyPlayerInfo, topType.type);
					player.y = DISTANCE_PER_PLAYER * i;						
					page.addChild(player);					
				}
				//_scroll.init(playersMov, maskMov, "vertical", true, false, true);				
			}			
		}
		
		public function updatePaging(current:int, total:int):void {
			_paging.visible = current > 0;
			_paging.update(current, total);
		}
		
		override public function transitionIn():void 
		{
			//this.gotoAndPlay("open");
			_tabManager.setActive(LeaderBoardTypeEnum.TOP_LEVEL.ID);
			super.transitionIn();
		}
		
		public function setPlayerSelected(info:LobbyPlayerInfo):void {			
			if (!info) {
				//Utility.error("can not set leader board player selected by null info");
				return;
			}
			
			var currentPage:MovieClip;
				switch(_tabManager.activeTabIndex()) {
					case LeaderBoardTypeEnum.TOP_1vs1_AI.ID:
						currentPage = _pvp1vs1ChallengePage;
						break;
					case LeaderBoardTypeEnum.TOP_LEVEL.ID:
						currentPage = _levelPage;
						break;
					case LeaderBoardTypeEnum.TOP_DAMAGE.ID:
						currentPage = _damagePage;
						break;
					case LeaderBoardTypeEnum.TOP_1VS1_MM.ID:
						currentPage = _pvp1vs1Page;
						break;
					case LeaderBoardTypeEnum.TOP_3VS3_MM.ID:
						currentPage = _pvp3vs3Page;
						break;
					case LeaderBoardTypeEnum.HEROIC_TOWER.ID:
						currentPage = _heroicTowerPage;
						break;
				}
			//MovieClipUtils.removeAllChildren(currentPage);
			var index:int = _data.indexOf(info);
			if (currentPage) {
				var player:LeaderBoardPlayer;
				for (var i:int = 0 ; i < currentPage.numChildren; i++ ) {
					player = currentPage.getChildAt(i) as LeaderBoardPlayer;
					player.setState(i == index ? 1 : 0);
				}
			}
			
			Manager.display.showPopup(ModuleID.PLAYER_PROFILE,  Layer.BLOCK_BLACK, info.id);
		}
		
		public function updatePlayersTop(data:Array): void {
			if (data) {
				var player:LeaderBoardPlayerTop;
				//reset all state
				for (var i:int = 0; i < MAX_PLAYER_TOP_SHOW_IN_LIST; i++) {
					player = _playersTopMov.getChildAt(i) as LeaderBoardPlayerTop;					
					player.updateInfo(i, null);
				}
				//update info
				//for (i = 0; i < data.length - 1; i++) {
				var count:int = data.length < MAX_PLAYER_TOP_SHOW_IN_LIST ? data.length - 1 : MAX_PLAYER_TOP_SHOW_IN_LIST;
				for (i = 0; i < count; i++) {
					player = _playersTopMov.getChildAt(i) as LeaderBoardPlayerTop;					
					player.updateInfo(i, data[i]);
				}
				//update player self
				if(data.length > 0)
					playerInfoMov.updateInfo(data[data.length - 1]);
			}
		}
		
		/*public function updatePlayerInfo(info:LobbyPlayerInfo): void {
			playerInfoMov.updateInfo(info);
		}*/
	}

}