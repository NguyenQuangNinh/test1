package game.ui.challenge 
{
	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.ui.arena.RewardModeInfo;
	import game.ui.components.FormationSlot;
	import game.ui.formation.FormationView;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.enum.PVPRankEnum;
	import game.Game;
	import game.net.lobby.response.ResponsePVP1vs1AIState;
	import game.ui.components.PagingMov;
	import game.ui.components.PlayerInvite;
	import game.ui.components.ScrollBar;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author ...
	 */
	public class ChallengeView extends ViewBase
	{
		//private static const OPEN_FINISH:String = "openFinish";
		
		public static const SHOW_LEADER_BOARD:String = "showLeaderBoard";
		public static const SHOW_CHANGE_FORMATION_CHALLENGE:String = "showChangeFormationChallenge";
		public static const REFRESH_TIME_COUNT_DOWN:String = "refreshTimeCountDown";
		public static const COMPLETED_TIME_COUNT_DOWN:String = "completedTimeCountDown";
		
		public static const MAX_PLAYER_SHOW_IN_LIST:int = 8;
		private static const DISTANCE_X_PER_PLAYER:int = 270;
		private static const DISTANCE_Y_PER_PLAYER:int = 77;
		
		//public var maskMov:MovieClip;
		//public var closeBtn:SimpleButton;
		public var rankTf:TextField;
		public var numPlayedTf:TextField;
		public var timeTf:TextField;
		public var timeRankTf:TextField;
		public var timeGroupTf:TextField;
		//public var guideTf:TextField;
		public var playersMov:MovieClip;
		public var refreshBtn:SimpleButton;
		public var closeBtn:SimpleButton;
		
		public var rewardBtn:SimpleButton;
		public var rewardModeInfoMov:RewardModeInfo;
		public var groupRankMov:MovieClip;
		
		private var _players:Array;
		//private var _scroll:ScrollBar;
		
		public var historyMov:HistoryContainer;
		//public var historyTf:TextField;
		public var rewardMov:RewardContainer;
		//public var rewardTf:TextField;
		//public var leaderBoardBtn:SimpleButton;
		public var changeFormationBtn:SimpleButton;
		
		private var _timer:Timer;
		private var _remainCount:int;		
		private var _numCompleted:int;
		private var _currentGroupRank:int = -1;
		private var _maxFreePlay:int;
		
		private var _formationUI:FormationView;
		private var _effectGroupLevelUp:Animator;
		
		public function ChallengeView() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);*/	
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
			
			//set fonts
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			FontUtil.setFont(timeTf, Font.ARIAL, true);
			FontUtil.setFont(numPlayedTf, Font.ARIAL, true);
			//FontUtil.setFont(rewardTf, Font.ARIAL, true);
			//FontUtil.setFont(historyTf, Font.ARIAL, true);
			//FontUtil.setFont(guideTf, Font.ARIAL, true);
			//historyTf.text = "LỊCH SỬ";
			//rewardTf.text = "PHẦN THƯỞNG";
			
			//init UI			
			//playersMov.mask = maskMov;
			
			/*_scroll = new ScrollBar();
			_scroll.x = maskMov.x + maskMov.width;
			_scroll.y = maskMov.y + (maskMov.height - _scroll.height) / 2;
			_scroll.visible = false;
			addChild(_scroll);*/
			rewardModeInfoMov.visible = false;
			
			//init events
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			//leaderBoardBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			refreshBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			changeFormationBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			rewardBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			//addEventListener(OPEN_FINISH, onArenaTweenHdl);
			
			//init timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
			
			_effectGroupLevelUp = new Animator();
			_effectGroupLevelUp.visible = false;
			_effectGroupLevelUp.x = groupRankMov.x + groupRankMov.width / 2;
			_effectGroupLevelUp.y = groupRankMov.y + groupRankMov.height * 2 / 3;
			_effectGroupLevelUp.load("resource/anim/ui/fx_nhomthidau.banim");
			_effectGroupLevelUp.addEventListener(Event.COMPLETE, onEffectPlayCompletedHdl);
			addChild(_effectGroupLevelUp);
			
			refreshBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			refreshBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			timeTf.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			timeTf.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			numPlayedTf.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			numPlayedTf.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			rankTf.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			rankTf.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			groupRankMov.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			groupRankMov.addEventListener(MouseEvent.ROLL_OUT, onRollOut);			
		}
		
		private function onRequestAddCharacterHdl(e:Event):void 
		{
			changeFormationBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			switch (e.target)
			{
				case groupRankMov:
				case rankTf:
				case numPlayedTf:
				case timeTf:
				case refreshBtn: 
					dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
					break;
				
				default: 
			}
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case refreshBtn: 
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Bỏ qua thời gian chờ"}, true));
					break;
				case timeTf:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Thời gian chờ để có thể tiếp tục thách đấu"}, true));
					break;
				case numPlayedTf:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Số trận thách đấu tối đa trong ngày"}, true));
					break;
				case groupRankMov:
				case rankTf:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Có 3 nhóm thi đấu: Sơ nhập giang hồ, thiếu hiệp, đại hiệp. Khi đánh đủ số trận sẽ được lên nhóm tiếp theo. \nKhi tới nhóm đại hiệp sẽ được xếp hạng."}, true));
					break;
				default: 
			}
		}
		
		private function onEffectPlayCompletedHdl(e:Event):void 
		{
			Utility.log( "ChallengeView.onEffectPlayCompletedHdl > e : ");
			_effectGroupLevelUp.visible = false;
			//dispatchEvent(new Event(RECEIVE_ACCUMULATE_REWARD, true));
		}
		
		private function onTimerUpdateHdl(e:TimerEvent):void 
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			timeTf.text = Utility.math.formatTime("M-S", _remainCount);
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			
			if (_remainCount == 0) {
				_timer.stop();
				dispatchEvent(new EventEx(COMPLETED_TIME_COUNT_DOWN, true));
				refreshBtn.visible = false;
			}
		}	
		
		public function stopCountDown():void {
			_timer.stop();
		}
		
		public function startCountDown():void {
			_timer.start();
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			//Utility.log( "ChallengeView.onBtnClickHdl > e : " + e );
			switch(e.target) {
				case closeBtn:
					dispatchEvent(new Event(Event.CLOSE));
					break;
				case refreshBtn:
					dispatchEvent(new Event(REFRESH_TIME_COUNT_DOWN));
					break;
				//case leaderBoardBtn:
					//dispatchEvent(new Event(SHOW_LEADER_BOARD));
					//break;
				case changeFormationBtn:
					dispatchEvent(new Event(SHOW_CHANGE_FORMATION_CHALLENGE));
					break;
				case rewardBtn:
					rewardModeInfoMov.initReward(GameMode.PVP_1vs1_AI.ID);
					rewardModeInfoMov.visible = true;
					//enableButtonView(false);
					break;					
			}
		}
		
		/*private function enableButtonView(enable:Boolean):void {			
			closeBtn.mouseEnabled = enable;			
			refreshBtn.mouseEnabled = enable;
			rewardBtn.mouseEnabled = enable;
			leaderBoardBtn.mouseEnabled = enable;
			changeFormationBtn.mouseEnabled = enable;
			
			historyMov.mouseChildren = enable;		
			rewardMov.mouseChildren = enable;
			playersMov.mouseChildren = enable;
		}*/
		
		public function updatePlayers(data:Array):void {
			//Utility.log( "ChallengeView.updatePlayers > data : " + data );
			if(data) {
				//clear content
				MovieClipUtils.removeAllChildren(playersMov);
				var player:PlayerInvite;
				//data = data.concat(data);
				for (var i:int = 0; i < data.length; i++) {
					player = new PlayerInvite();
					player.x = DISTANCE_X_PER_PLAYER * (i % 2);
					player.y = DISTANCE_Y_PER_PLAYER * (int) (i / 2);					
					playersMov.addChild(player);
					player.update(data[i] as LobbyPlayerInfo, true);
				}	
			}	
		}
		
		public function updateHistorys(data:Array):void {
			//Utility.log( "ChallengeView.updateHistorys > data : " + data );
			historyMov.updateInfo(data);
		}			
		
		public function updateState(state:ResponsePVP1vs1AIState):void {			
			//Utility.log( "ChallengeView.updateState > state : " + state );
			//update num match played and time remain to refresh
			_numCompleted = state.numMatchFreePlayed + state.numMatchPaid;
			_maxFreePlay = state.maxMatchFreePlay;
			_remainCount = state.timeRemain > 0 ? state.timeRemain : 0;			
			//state.groupRank++;
			
			numPlayedTf.text = _numCompleted + "/" + _maxFreePlay;
			timeTf.text = Utility.math.formatTime("M-S", _remainCount);
			if(_remainCount > 0) {
				startCountDown();
			}
			refreshBtn.visible = _remainCount > 0;	
			
			if (_currentGroupRank != state.groupRank) {
				_currentGroupRank = state.groupRank;
				_effectGroupLevelUp.visible = true;
				_effectGroupLevelUp.play(0, 1);
			}
			groupRankMov.gotoAndStop(state.groupRank + 1);			
			/*switch(state.groupRank) {
				case PVPRankEnum.NEW_BIE:
				case PVPRankEnum.AMATEUR:
				case PVPRankEnum.PROFESSIONAL:
					rankTf.text =  (modeXML ? modeXML.getGroupReward()[state.groupRank].name : "");
					break;
				case PVPRankEnum.WORLD_CLASS:
					rankTf.text = groupRank.name + " , hiện tại hạng: " + state.rank;
					break;
			}*/
			//update num play to be next rank
			var nextGroupInfo:Object = getGroupRankByID(state.groupRank);
			rankTf.text = (nextGroupInfo.count > 0 ?
						state.numMatchPlayedInWeek.toString() + "/" + nextGroupInfo.count.toString() : "");
			//guide 					
				
			//init for reward container
			rewardMov.updateRewards(state.rewardRankDaily, state.receivedRewardRankDaily, state.timeRemainDaily,
									state.rewardRankWeekly, state.receivedRewardRankWeekly,
									state.rewardGroupWeekly/*, state.receivedRewardGroupWeekly*/, state.timeRemainWeekly);
		}
		
		private function getGroupRankByID(id:int):Object {
			//rank				
			var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_1vs1_AI.ID) as ModeConfigXML;
			var groupArray:Array = modeXML ? modeXML.getGroupReward() : [];
			var groupRank:Object = {};
			for each(var group:Object in groupArray) {
				if (group && group.id == id) {
					groupRank = group;
					break;
				}
			}
			return groupRank;
		}
		
		public function isCoolDown():Boolean {
			return _remainCount != 0;
		}
		
		public function isOutOfFreePlay():Boolean {
			return _numCompleted >= _maxFreePlay;			
		}
		
		public function getMaxMatchPlay():int {
			return _maxFreePlay;
		}
		
		public function addFormationView(view:FormationView):void {
			_formationUI = view;
			_formationUI.addEventListener(FormationSlot.ADD_CHARACTER_CLICK, onRequestAddCharacterHdl);
			addChildAt(_formationUI, this.numChildren - 2);
		}
	}

}