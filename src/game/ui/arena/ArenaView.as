package game.ui.arena 
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import game.ui.message.MessageID;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.Game;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.response.ResponsePVP1vs1MMState;
	import game.ui.arena.MatchingCount;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ArenaView extends ViewBase
	{
		
		private static const OPEN_FINISH:String = "openArenaFinish";
		private static const CLOSE_FINISH:String = "closeArenaFinish";
		
		//public static const LEADER_BOARD:String = "leaderBoard";
		
		public var roomListMov:RoomList;
		public var createRoomMov:CreateRoom;
		public var modeInfoMov:ModeInfo;
		public var modeSelectMov:ModeSelect;
		
		public var backToModeSelectBtn:SimpleButton;		
		public var closeBtn:SimpleButton;
		public var infoBtn:SimpleButton;
		public var rewardBtn:SimpleButton;	
		
		public var topLeaderBoardMov:TopLeaderBoardMov;
		public var topInfoStateMov:TopInfoState;
		public var rewardMov:RewardTopReceive;
		public var matchingCountMov:MatchingCount;

		public var registerMov:RegisterInfo;

		public var rewardModeInfoMov:RewardModeInfo;
		public var modeGuideInfoMov:ModeInfoGuide;		
		
		private var _state:int;
		private var _mode:GameMode;
		private var _roomSelected:LobbyInfo;
		
		private var _timeValid:String = "";
		
		public function ArenaView() 
		{		
			initUI();
		}
		private function initUI(): void
		{
			//Utility.log("arena view is inited");
			infoBtn.visible = false;
			//init events
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			infoBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			rewardBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			backToModeSelectBtn.addEventListener(MouseEvent.CLICK, onClickBackToModeSelectHdl);
			
			addEventListener(ArenaEventName.MODE_SELECTED, onModeSelectedHdl);
			addEventListener(ArenaEventName.MODE_INFO_SELECTED, onModeInfoSelectedHdl);
			addEventListener(ArenaEventName.ROOM_SELECTED, onRoomSelectedHdl);		
			
			modeGuideInfoMov.addEventListener(Event.CLOSE, onCloseInfoHdl);
			rewardModeInfoMov.addEventListener(Event.CLOSE, onCloseInfoHdl);
		}
		
		private function onCloseInfoHdl(e:Event):void 
		{
			enableButtonView(true);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case closeBtn:
					dispatchEvent(new Event(ArenaEventName.CLOSE));	
					break;				
				case infoBtn:
					//modeInfoMov.visible = true;
					//enableButtonView(false);
					modeGuideInfoMov.initGuide(_mode.ID);
					modeGuideInfoMov.visible = true;
					enableButtonView(false);
					break;			
				case rewardBtn:
					//dispatchEvent(new Event(ArenaEventName.SHOW_REWARD_MODE_INFO));						
					rewardModeInfoMov.initReward(_mode.ID);
					rewardModeInfoMov.visible = true;
					enableButtonView(false);
					break;
			}
		}
		
		private function onClickBackToModeSelectHdl(e:MouseEvent):void 
		{
			resetView();
		}
		
		private function onRoomSelectedHdl(e:EventEx):void 
		{
			_roomSelected = e.data as LobbyInfo;
			roomListMov.setRoomSelected(_roomSelected);
		}
		
		private function onModeInfoSelectedHdl(e:EventEx):void 
		{
			var mode:int = e.data as int;
			switch(mode) {
				case ArenaEventName.MODE_INFO_SEARCH:					
					modeInfoMov.changeState(ArenaEventName.ARENA_ROOM_SELECT, _mode, true);
					modeSelectMov.visible = false;		
					createRoomMov.visible = false;
					roomListMov.initUIByMode(_mode);
					roomListMov.visible = true;	
					backToModeSelectBtn.visible = true;
					//send request to get room list
					roomListMov.onGoToNextHdl();					
					_state = ArenaEventName.ARENA_ROOM_SELECT;
					break;
				case ArenaEventName.MODE_INFO_MATCHING:
				case ArenaEventName.MODE_INFO_CREATE_ROOM:
					/*topInfoStateMov.visible = false;
					rewardMov.visible = false;
					modeSelectMov.visible = false;
					modeInfoMov.changeState(ArenaEventName.ARENA_ROOM_CREATE, _mode);
					topLeaderBoardMov.visible = _mode == GameMode.PVP_3vs3_MM || _mode == GameMode.PVP_1vs1_MM;
					dispatchEvent(new EventEx(ArenaEventName.REQUEST_MODE_INFO_LEADER_BOARD, _mode, true));
					createRoomMov.visible = false;
					backToModeSelectBtn.visible = true;
					_state = ArenaEventName.ARENA_ROOM_CREATE;*/
					//send packet request to create lobby
					dispatchEvent(new EventEx(ArenaEventName.ROOM_CREATED, {
										name: createRoomMov.getName(),
										privateLobby: createRoomMov.checkPrivate(),
										mode: createRoomMov.getMode(), 
										modeSelect: createRoomMov.getModeSelect() } ));
					break;	
				case ArenaEventName.MODE_INFO_REFRESH:
					roomListMov.initUIByMode(_mode);						
					//send request to get room list
					roomListMov.onGoToNextHdl();
					break;
				case ArenaEventName.MODE_INFO_REGISTER:
				case ArenaEventName.MODE_INFO_QUICK_JOIN:
					dispatchEvent(new EventEx(ArenaEventName.QUICK_JOIN_GAME, _mode));
					break;					
				case ArenaEventName.MODE_INFO_ENTER_LOBBY:
					//send packet request to create lobby
					/*dispatchEvent(new EventEx(ArenaEventName.ROOM_CREATED, {
										name: createRoomMov.getName(),
										pass: createRoomMov.checkPrivate(),
										mode: createRoomMov.getMode(), 
										modeSelect: createRoomMov.getModeSelect() } ));	*/	
					if (_roomSelected) {
						dispatchEvent(new EventEx(ArenaEventName.JOIN_ROOM, _roomSelected));
					}else {
						Manager.display.showMessageID(MessageID.ARENA_JOIN_FAILED_BY_NOT_SELECT_ROOM);
					}
					break;
				case ArenaEventName.MODE_INFO_JOIN:	
					roomListMov.visible = false;
					roomListMov.initUIByMode(_mode);
					createRoomMov.setMode(_mode);
					modeInfoMov.changeState(ArenaEventName.ARENA_ROOM_CREATE, _mode, true);
					modeSelectMov.visible = false;
					backToModeSelectBtn.visible = true;
					rewardBtn.visible = false;
					rewardMov.visible = false;
					topInfoStateMov.visible = false;
					topLeaderBoardMov.visible = _mode != GameMode.PVP_FREE;
					switch(_mode) {
						case GameMode.PVP_FREE:
							break;
						case GameMode.PVP_3vs3_MM:
							dispatchEvent(new EventEx(ArenaEventName.REQUEST_MODE_INFO_LEADER_BOARD, _mode, true));
							createRoomMov.setMode(_mode);
							createRoomMov.visible = true;
							createRoomMov.y = 213;
							break;
						case GameMode.PVP_1vs1_MM:
						case GameMode.PVP_2vs2_MM:
							dispatchEvent(new EventEx(ArenaEventName.REQUEST_MODE_INFO_LEADER_BOARD, _mode, true));
							registerMov.visible = true;
							break;
					}
					break;	
			}
		}
		
		private function checkModeOpenValid(modeID:int):Boolean {
			var valid:Boolean = false;
			
			//check level + time			
			var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, modeID) as ModeConfigXML;
			var currentLevel:int = Game.database.userdata.level;
			valid = modeXML && currentLevel >= modeXML.nLevelRequirement;
			
			var timeNow:Number = new Date().getTime() + Game.database.userdata.serverTimeDifference;
			var currentDate:Date = new Date();
			currentDate.setTime(timeNow);			
			valid &&= modeXML && modeXML.checkValidTimeRequire(currentDate);
			
			return valid;
		}
		
		private function onModeSelectedHdl(e:EventEx):void 
		{
			//var mode:int = e.data as int;
			var isSelectAnotherMode:Boolean = e.data != _mode;
			_mode = e.data as GameMode;
			rewardMov.setMode(_mode.ID);
			createRoomMov.setMode(_mode);
			createRoomMov.y = 181;

			if(registerMov.countMov.visible && isSelectAnotherMode)
			{
				registerMov.unregisterMatchMaking();
			}

			switch(_mode) {
				case GameMode.PVP_FREE:
					topInfoStateMov.visible = false;
					rewardBtn.visible = false;
					rewardMov.visible = false;
					createRoomMov.visible = true;
					registerMov.visible = false;
					break;
				case GameMode.PVP_2vs2_MM:
				case GameMode.PVP_3vs3_MM:	
				case GameMode.PVP_1vs1_MM:
					//get mode info state, top leaderboard and reward 
					dispatchEvent(new EventEx(ArenaEventName.REQUEST_MODE_INFO_STATE, _mode, true));
					//dispatchEvent(new EventEx(ArenaEventName.REQUEST_MODE_INFO_LEADER_BOARD, _mode, true));
					topInfoStateMov.visible = true;
					rewardBtn.visible = true;
					rewardMov.visible = true;
					createRoomMov.visible = false;
					registerMov.visible = false;
					break;
			}
			var modeValid:Boolean = checkModeOpenValid(_mode.ID);
			modeInfoMov.changeState(ArenaEventName.ARENA_MODE_SELECT, _mode, modeValid);
			registerMov.checkEnable(modeValid);
			//get desc and icon by mode selected and update for mode info
			var modeXMLs:Dictionary = Game.database.gamedata.getTable(DataType.MODE_CONFIG);
			if (modeXMLs) {
				for each (var modeXML:ModeConfigXML in modeXMLs) {
					if (modeXML.type == _mode.ID) {
						modeInfoMov.updateInfo(modeXML);
						break;
					}
				}
			}
		}
		
		override public function transitionIn():void 
		{
			super.transitionIn();
			
			resetView();
		}
		
		public function updateRoomList(data:Array):void {
			if(data) {
				roomListMov.updateRoomList(data);			
			}
		}
		
		public function setTimeValid(time:String): void {
			_timeValid = time;
		}
		
		public function resetView():void {
			_state = ArenaEventName.ARENA_MODE_SELECT;
			var currMode:GameMode = GameMode.PVP_FREE;

			modeInfoMov.changeState(_state, currMode, true);
			
			roomListMov.visible = false;
			createRoomMov.setMode(currMode);
			createRoomMov.visible = true;
			stopMatching();
			matchingCountMov.visible = false;
			topLeaderBoardMov.visible = false;
			//topInfoStateMov.visible = false;
			
			modeGuideInfoMov.visible = false;
			rewardModeInfoMov.visible = false;
			
			rewardMov.visible = false;			
			
			modeInfoMov.visible = true;
			modeSelectMov.visible = true;
			//modeSelectMov.checkModeValid();
			//modeSelectMov.setModeSelected(_mode.ID);			
			modeSelectMov.setModeSelected(currMode);
			//roomListMov.visible = false;
			//createRoomMov.visible = false;
			backToModeSelectBtn.visible = false;
			registerMov.visible = false;
		}
		
		public function updateState(mode:GameMode, numPlayed:int, rank:int, hornorPoint:int, eloPoint:int):void 
		{			
			topInfoStateMov.updateState(mode, numPlayed, rank, hornorPoint, eloPoint);
		}
		
		public function updateTopChampion(index:int, pageNum:int, data:Array, isLastBack:Boolean, isLastNext:Boolean):void 
		{			
			topLeaderBoardMov.updateTopChampion(index, pageNum, data, isLastBack, isLastNext);
		}
		
		public function updateReward(dailyRewardID:int, dailyRewardReceived:Boolean,
						weeklyRewardID:int, weeklyRewardReceived:Boolean, timeRemainDailyReward:int, timeRemainWeeklyReward:int):void
		{
			rewardMov.updateReward(dailyRewardID, dailyRewardReceived,
						weeklyRewardID, weeklyRewardReceived, timeRemainDailyReward, timeRemainWeeklyReward);
		}
		
		public function updatePaging(current:int, total:int):void {
			topLeaderBoardMov.updatePaging(current, total);
		}
		
		public function startMatching():void {
			enableButtonView(false);
			matchingCountMov.visible = true;
			matchingCountMov.startCount();
		}
		
		public function stopMatching():void {
			enableButtonView(true);
			matchingCountMov.visible = false;
			matchingCountMov.stopCount();
		}
		
		public function enableButtonView(enable:Boolean):void {
			closeBtn.mouseEnabled = enable;			
			infoBtn.mouseEnabled = enable;
			backToModeSelectBtn.mouseEnabled = enable;
			
			roomListMov.mouseChildren = enable;
			createRoomMov.mouseChildren = enable;		
			modeInfoMov.mouseChildren = enable;
			modeSelectMov.mouseChildren = enable;
			
			topLeaderBoardMov.mouseChildren = enable;						
			topInfoStateMov.mouseChildren = enable;
			rewardMov.mouseChildren = enable;
		}

		public function registerSuccessHdl():void
		{
			registerMov.registerMatching(_mode);
		}
	}

}