package game.flow 
{
	import core.event.EventEx;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.enum.FlowActionEnum;
	import game.enum.GameMode;
	import game.ui.ingame.replay.GameReplayManager;
	//import game.enum.FlowActionID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FlowManager extends EventDispatcher
	{		
		//private var _preloadFlow	:PreloadIngameFlow;
		//private var _newRoleInitFlow:NewRoleFlow;
		//private var _initGame		:InitGame;
		//private var _modePvP		:ModePvP;
		
		private var _changeFormation:ChangeFormation;
		private var _gameFlow:GameFlow;
		private var _gotoAction:GoToAction;
		private var _purchaseResource:PurchaseResource;
				
		public static const ACTION_COMPLETED:String = "actionCompleted";
		
		public function FlowManager() 
		{			
			_changeFormation = new ChangeFormation();
			_changeFormation.addEventListener(Event.COMPLETE, onActionCompletedHdl);
				
			_gameFlow = new GameFlow();
			_gameFlow.addEventListener(Event.COMPLETE, onActionCompletedHdl);
			
			_gotoAction = new GoToAction();
			_gotoAction.addEventListener(Event.COMPLETE, onActionCompletedHdl);
			
			_purchaseResource = new PurchaseResource();
			_purchaseResource.addEventListener(Event.COMPLETE, onActionCompletedHdl);
		}
		
		public function lock():void
		{
			_gameFlow.lock();
		}
		
		public function unlock():void
		{
			_gameFlow.unlock();
		}
		
		private function onActionCompletedHdl(e:EventEx):void 
		{
			dispatchEvent(new EventEx(ACTION_COMPLETED, e.data));
		}
		
		public function doAction(actionID:int, data:Object = null): void {
			try {
				switch(actionID) {
					case FlowActionEnum.CHANGE_FORMATION:
						_changeFormation.changeByDrag(data);	
						break;
						
					case FlowActionEnum.INSERT_TO_FORMATION:
						_changeFormation.insertByDClick(data);
						break;
						
					case FlowActionEnum.REMOVE_FROM_FORMATION:
						_changeFormation.removeByDClick(data);
						break;
					
					case FlowActionEnum.START_LOBBY:
						_gameFlow.startLobby();
						break;
						
					case FlowActionEnum.CONTINUE_PLAY_GAME:
						_gameFlow.continuePlayGame();
						break;								
						
					case FlowActionEnum.LEAVE_GAME:
						_gameFlow.leaveGame();
						break;		
						
					case FlowActionEnum.JOIN_LOBBY_BY_ID:
						_gameFlow.joinLobbyByID(data);
						break;	
						
					case FlowActionEnum.QUICK_JOIN:
						_gameFlow.quickJoinLobby(data as LobbyInfo);
						break;
						
					case FlowActionEnum.CREATE_BASIC_LOBBY:
						_gameFlow.createBasicLobby(data as LobbyInfo);
						break;
						
					case FlowActionEnum.GO_TO_ACTION:
						_gotoAction.goTo(data);
						break;
						
					case FlowActionEnum.PURCHASE_RESOURCE:
						_purchaseResource.purchase(data);
						break;
					case FlowActionEnum.START_LOADING_RESOURCE_REPLAY:
						_gameFlow.onStartLoadingResult();
						break;
					case FlowActionEnum.GAME_END_REPLAY:
						GameReplayManager.getInstance().endReplaying();
						_gameFlow.onLeaveGameResult();
						break;
				}
			}catch(e:Error) {
				Utility.error("can not do action by error data " + e.message);
			}
			
		}
		
		public function getCurrentGameMode():GameMode
		{
			return _gameFlow.getCurrentGameMode();
		}
	}

}