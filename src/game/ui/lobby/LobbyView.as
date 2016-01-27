package game.ui.lobby
{

	import core.Manager;
	import core.display.ViewBase;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	import game.Game;
	import game.data.vo.chat.ChatType;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.enum.LobbyEvent;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.ModuleID;
	import game.ui.arena.MatchingCount;
	import game.ui.chat.ChatModule;
	import game.ui.chat.ChatView;
	import game.utility.TimerEx;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LobbyView extends ViewBase
	{

		private static const TEAM_1_START_FROM_X:int = 32;
		private static const TEAM_2_START_FROM_X:int = 830;
		private static const TEAM_START_FROM_Y:int = 94;

		public function LobbyView()
		{
			init();
		}

		public var roomName_Tf:TextField;
		public var startBtn:SimpleButton;
		public var inviteBtn:SimpleButton;
		public var btnBroadcastGlobal:SimpleButton;
		public var vsMov:MovieClip;
		public var matchingMov:MatchingCount;
		public var countingMov:MovieClip;

		private var _btnBack:SimpleButton;
		private var _team_1:LobbyTeamInfoUI;
		private var _team_2:LobbyTeamInfoUI;
		private var _mode:GameMode;
		private var _isHost:Boolean = false;
		private var _playersInRoom:int = 0;
		private var startCountTimes:int = 0;
		private var _kickTimes:int = -1;
		private var timeOutID:int = -1;

		override public function transitionIn():void
		{
			super.transitionIn();

			resetBtnState();

			var chat:ChatView = Manager.module.getModuleByID(ModuleID.CHAT).baseView as ChatView;
			if (chat != null)
			{
				chat.chatBoxMov.update(ChatType.CHAT_TYPE_ROOM, ChatType.CHAT_TYPE_ROOM);
			}
		}

		public function updateLobby(info:Array):void
		{
			Utility.log("LobbyView.updateLobby > info : " + info);
			//clear all beafore update

			_playersInRoom = info.length;

			var playerObj:LobbyPlayerInfo;
			for (var i:int = 0; i < info.length; i++)
			{
				playerObj = info[i] as LobbyPlayerInfo;
				updateTeamInfo(playerObj);
			}

			checkValidStart(info);
			checkStartTimeout(info);
			checkLimitKick();
		}

		private function checkLimitKick():void
		{
			if(_isHost && countingMov.visible)
			{
				if(kickTimes == -1)
				{
					kickTimes = Game.database.gamedata.getConfigData(230);
				}
			}
			else
			{
				kickTimes = -1;
			}
		}

		private function checkStartTimeout(info:Array):void
		{
			if(_isHost && countingMov.visible)
			{
				if(info.length == 3)
				{
					if(timeOutID == -1)
					{//Chua start timer
						startTimeout();
					}
				}
				else
				{//Room chi co chu phong
					TimerEx.stopTimer(timeOutID);
					timeOutID = -1;
				}
			}
			else
			{
				TimerEx.stopTimer(timeOutID);
				timeOutID = -1;
			}
		}

		private function startTimeout():void
		{
			TimerEx.stopTimer(timeOutID);
			startCountTimes = Game.database.gamedata.getConfigData(229);
			timeOutID = TimerEx.startTimer(1000, startCountTimes, updateTime, changeRoomHost);
		}

		private function changeRoomHost():void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.CHANGE_ROOM_HOST));
		}

		private function updateTime():void
		{
			startCountdownTf.text = "Thời gian bắt đầu: " + (startCountTimes--) + " giây.";
		}

		public function updateTeamInfo(info:LobbyPlayerInfo):void
		{
			if (info)
			{
				switch (info.teamIndex)
				{
					case 1:
						_team_1.updatePlayerInfo(info.index, info);
						break;
					case 2:
						_team_2.updatePlayerInfo(info.index, info, true);
						break;
				}
			}
		}

		public function startMatching():void
		{
			enableLobbyBtn(false);
			matchingMov.visible = true;
			matchingMov.startCount();
		}

		public function stopMatching():void
		{
			enableLobbyBtn(true);
			matchingMov.visible = false;
			matchingMov.stopCount();
		}

		public function initUIByMode(mode:GameMode):void
		{
			Utility.log("initUIByMode : " + mode.worldMode.ID);
			_mode = mode;
			_team_1.initUIByMode(_mode);
			_team_2.initUIByMode(_mode);
			_team_1.showAllPlayers(false, false);
			_team_2.showAllPlayers(false, true);
			_team_2.visible = true;

			switch (mode)
			{
				case GameMode.PVP_1vs1_FREE:
					_team_1.showPlayerAtIndex(0, false);
					_team_2.showPlayerAtIndex(0, true);
					this.gotoAndStop("free");
					vsMov.visible = true;
					break;
				case GameMode.PVP_3vs3_FREE:
					_team_1.showAllPlayers(true, false);
					_team_2.showAllPlayers(true, true);
					this.gotoAndStop("free");
					vsMov.visible = true;
					break;
				case GameMode.PVP_3vs3_MM:
					_team_2.visible = false;				
					_team_1.showAllPlayers(true, false);
					this.gotoAndStop("matching");
					vsMov.visible = false;
					break;
				case GameMode.PVP_1vs1_MM:
					_team_1.showPlayerAtIndex(0, false);
					vsMov.visible = false;
					inviteBtn.visible = false;
					break;
			}
		}

		public function initRoomName(name:String):void
		{
			FontUtil.setFont(roomName_Tf, Font.ARIAL, true);
			roomName_Tf.text = name;
		}

		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			//init UI
			FontUtil.setFont(roomName_Tf, Font.ARIAL, true);
			FontUtil.setFont(startCountdownTf, Font.ARIAL, true);
			FontUtil.setFont(kickTf, Font.ARIAL, true);

			_team_1 = new LobbyTeamInfoUI(1);
			_team_1.x = TEAM_1_START_FROM_X;
			_team_1.y = TEAM_START_FROM_Y;
			addChild(_team_1);

			_team_2 = new LobbyTeamInfoUI(2);
			_team_2.x = TEAM_2_START_FROM_X;
			_team_2.y = TEAM_START_FROM_Y;
			addChild(_team_2);
			swapChildren(matchingMov, _team_2);

			//init events
			startBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			inviteBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnBroadcastGlobal.addEventListener(MouseEvent.CLICK, onBtnClickHdl);

			_btnBack = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			var btnBackPoint:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			_btnBack.x = btnBackPoint.x;
			_btnBack.y = btnBackPoint.y;
			addChild(_btnBack);
			_btnBack.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			addEventListener(LobbyEvent.KICK_PLAYER, onKickHdl);
		}

		private function onKickHdl(event:Event):void
		{
			if(_isHost && countingMov.visible)
			{
				kickTimes--;
				if(kickTimes == 0)
				{
					changeRoomHost();
				}
			}
			else
			{
				kickTimes = -1;
			}
		}

		private function broadcastGlobal():void
		{
			var lobbyInfo:LobbyInfo = data as LobbyInfo;

			var nameString:String = "<font color='#ea971b'>[" + modeName + "]</font>";
			var membersStr:String = "<font color='#FFFFFF'>[Thành viên " + _playersInRoom + "/" + maxPlayers + "]</font>";
			var joinLink:String = '[<a href="event:invitePVP,' + lobbyInfo.id + "," + _mode.ID + "," + lobbyInfo.privateLobby.toString() + '"><font color="#00FF00"><u><b>Tham gia ngay</b></u></font></a>]';
			var missionStr:String = ": Đang chiêu mộ Đại Hiệp - " + joinLink;

			var message:String = nameString + "-" + membersStr + "-" + missionStr;

			var chatModule:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;

			if (chatModule)
			{
				chatModule.sendChatGlobal(message);
			}
		}

		private function checkValidStart(info:Array):void
		{
			var myID:int = Game.database.userdata.userID;
			var playerObj:LobbyPlayerInfo;
			for (var i:int = 0; i < info.length; i++)
			{
				playerObj = info[i] as LobbyPlayerInfo;
				if (myID == playerObj.id && playerObj.owner)
				{
					MovieClipUtils.removeAllFilters(startBtn);
					startBtn.mouseEnabled = true;
					_team_1.enableKick(true);
					_team_2.enableKick(true);
					_isHost = true;
					countingMov.visible = (_mode == GameMode.PVP_3vs3_MM);
					return;
				}
			}

			MovieClipUtils.applyGrayScale(startBtn);
			startBtn.mouseEnabled = false;
			countingMov.visible = false;

			_team_1.enableKick(false);
			_team_2.enableKick(false);
		}

		private function enableLobbyBtn(enableFlag:Boolean):void
		{
			startBtn.visible = enableFlag;
			startBtn.mouseEnabled = enableFlag;
			inviteBtn.visible = enableFlag && _mode != GameMode.PVP_1vs1_MM;
			inviteBtn.mouseEnabled = enableFlag && _mode != GameMode.PVP_1vs1_MM;
			btnBroadcastGlobal.visible = enableFlag && _mode != GameMode.PVP_1vs1_MM;
			btnBroadcastGlobal.mouseEnabled = enableFlag && _mode != GameMode.PVP_1vs1_MM;

			_team_1.mouseChildren = enableFlag;
			_team_2.mouseChildren = enableFlag;
		}

		private function resetBtnState():void
		{
			//reset button
			_isHost = false;
			startBtn.visible = true;
			startBtn.mouseEnabled = true;
			inviteBtn.mouseEnabled = true;
		}

		private function onBtnClickHdl(e:MouseEvent):void
		{
			switch (e.target)
			{
				case startBtn:
					dispatchEvent(new Event(LobbyEvent.START_PVP_GAME));
					TimerEx.stopTimer(timeOutID);
					timeOutID = -1;
					break;
				case inviteBtn:
					dispatchEvent(new Event(LobbyEvent.GET_PLAYER_LIST));
					break;
				case btnBroadcastGlobal:
					broadcastGlobal();
					break;
				case _btnBack:
					dispatchEvent(new Event(LobbyEvent.BACK_TO_HOME));
					break;
			}
		}

		private function get maxPlayers():int
		{
			switch (_mode)
			{
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_1vs1_MM:
					return 2;
				case GameMode.PVP_3vs3_FREE:
				case GameMode.PVP_3vs3_MM:
					return 6;
				default :
					return 1;
				break;
			}
		}

		private function get modeName():String
		{
			switch (_mode)
			{
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_3vs3_FREE:
					return "Long Tranh Hổ Đấu";
				case GameMode.PVP_1vs1_MM:
				case GameMode.PVP_3vs3_MM:
					return "Tam Hùng Kỳ Hiệp";
				default :
					return "";
					break;
			}
		}

		private function get kickTimes():int
		{
			return _kickTimes;
		}

		private function set kickTimes(value:int):void
		{
			_kickTimes = value;
			kickTf.text = "Giới hạn Đá: " + _kickTimes;
		}

		private function get kickTf():TextField
		{
			return countingMov.kickTf as TextField;
		}

		private function get startCountdownTf():TextField
		{
			return countingMov.startTf as TextField;
		}

		override protected function transitionOutComplete():void
		{
			super.transitionOutComplete();
			TimerEx.stopTimer(timeOutID);
			timeOutID = -1;
			kickTimes = -1;
		}
	}

}