package game.ui.train.inroom
{
	import com.greensock.TweenMax;
	import components.ExCheckBox;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.Manager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import game.data.model.Character;
	import game.data.vo.chat.ChatInfo;
	import game.data.vo.chat.ChatType;
	import game.enum.Font;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.chat.ChatEvent;
	import game.ui.chat.ChatModule;
	import game.ui.components.dynamicobject.ObjectDirection;
	import game.ui.components.TextCountDown;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.home.CharacterOutGame;
	import game.ui.ModuleID;
	import game.ui.train.data.RoomInfo;
	
	/**
	 * ...
	 * @author vu anh
	 */
	public class TrainInRoom extends MovieClip
	{
		public var remainTimeTf:TextField;
		
		public var inviteBtn:SimpleButton;
		public var announceBtn:SimpleButton;
		public var kickBtn:SimpleButton;
		
		public var rewardMov:MovieClip;
		public var readyMov:MovieClip;
		
		public var leaveBtn:SimpleButton;
		public var startBtn:SimpleButton;
		public var readyBtn:SimpleButton;
		
		private var countDown:TextCountDown;
		
		private var playerCon:Sprite;
		private var hostCharacter:CharacterOutGame;
		private var partnerCharacter:CharacterOutGame;
		
		private var playerCount:int;
		private var isAllPlayerReady:Boolean;
		private var isHost:Boolean;
		
		private var timeCount:int;
		private var startPos:Number;
		private var roomInfo:RoomInfo;
		
		public var partnerId:int;
		public var receivedEXP:int;
		
		public var autoStartChb:ExCheckBox;
		
		public function TrainInRoom()
		{
			
			FontUtil.setFont(remainTimeTf, Font.ARIAL, true);
			FontUtil.setFont(rewardMov.tf, Font.ARIAL, true);
			countDown = new TextCountDown(remainTimeTf);
			countDown.addEventListener(TextCountDown.TEXT_COUNT_DOWN_COMPLETE, countDownCompleteHdl);
			countDown.addEventListener(TextCountDown.TEXT_COUNT_DOWN_TIMER, countDownTimerHdl);
			
			leaveBtn.addEventListener(MouseEvent.CLICK, leaveBtnHdl);
			startBtn.addEventListener(MouseEvent.CLICK, startBtnHdl);
			readyBtn.addEventListener(MouseEvent.CLICK, readyBtnHdl);
			
			kickBtn.addEventListener(MouseEvent.CLICK, kickBtnHdl);
			announceBtn.addEventListener(MouseEvent.CLICK, announceBtnHdl);
			inviteBtn.addEventListener(MouseEvent.CLICK, inviteBtnHdl);
			
			playerCon = new Sprite();
			addChild(playerCon);
			
			hostCharacter = Manager.pool.pop(CharacterOutGame) as CharacterOutGame;
			hostCharacter.movingArea = null;
			hostCharacter.direction = ObjectDirection.RIGHT;
			hostCharacter.x = 545;
			hostCharacter.y = 400;
			playerCon.addChild(hostCharacter);
			
			partnerCharacter = Manager.pool.pop(CharacterOutGame) as CharacterOutGame;
			partnerCharacter.movingArea = null;
			partnerCharacter.x = 726;
			partnerCharacter.y = 400;
			partnerCharacter.direction = ObjectDirection.LEFT;
			playerCon.addChild(partnerCharacter);
			
			autoStartChb.setSelected(false);
		}
		
		private function inviteBtnHdl(e:MouseEvent):void 
		{
			Manager.display.showModule(ModuleID.INVITE_PLAYER, new Point(0, - 50), LayerManager.LAYER_HUD,
							"top_left", Layer.BLOCK_BLACK, {moduleID: ModuleID.KUNGFU_TRAIN});
		}
		
		public function setRoomInfo(inf:RoomInfo):void
		{
			this.roomInfo = inf;
		}
		
		private function announceBtnHdl(e:MouseEvent):void
		{
			Manager.display.showDialog(DialogID.YES_NO, onAcceptShareHdl, null, {title: "THÔNG BÁO", message: "Bạn có muốn thông báo mời vào phòng này lên kênh thế giới?", option: YesNo.YES | YesNo.NO});
		}
		
		private function onAcceptShareHdl(data:Object):void 
		{
			var chatInfo:ChatInfo = new ChatInfo();
			chatInfo.type = ChatType.CHAT_TYPE_SERVER;
			var msg:String = "[train-announce-msg]" + roomInfo.strRoleName + "," + roomInfo.nLevel + "," + roomInfo.roomId;
			chatInfo.mes = msg;
			
			ChatModule(Manager.module.getModuleByID(ModuleID.CHAT)).onSendChat(new EventEx(ChatEvent.SEND_CHAT_GLOBAL, chatInfo));
			
		}
		
		private function kickBtnHdl(e:MouseEvent):void
		{
			if (playerCount < 2) return;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.KICK_LOBBY_PLAYER_SLOT, this.partnerId));
		}
		
		private function readyBtnHdl(e:MouseEvent):void
		{
			readyBtn.visible = false;
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.TRAIN_READY));
		}
		
		private function startBtnHdl(e:MouseEvent = null):void
		{
			if (playerCount < 2)
			{
				Manager.display.showDialog(DialogID.YES_NO, null, null, {title: "THÔNG BÁO", message: "Bạn cần chờ thêm người chơi để bắt đầu chỉ điểm?", option: YesNo.YES});
				return;
			}
			if (!isAllPlayerReady)
			{
				Manager.display.showDialog(DialogID.YES_NO, null, null, {title: "THÔNG BÁO", message: "Người chơi còn lại chưa sẵn sàng?", option: YesNo.YES});
				return;
			}
			startBtn.visible = false;
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.TRAIN_START));
		}
		
		private function leaveBtnHdl(e:MouseEvent):void
		{
			if (countDown.isRunning())
				Manager.display.showDialog(DialogID.YES_NO, onAcceptLeaveHdl, null, {title: "THÔNG BÁO", message: "Chỉ điểm võ công chưa kết thúc, bạn có muốn rời phòng?", option: YesNo.YES | YesNo.NO});
			else
				onAcceptLeaveHdl();
		}
		
		private function onAcceptLeaveHdl(data:Object = null):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LEAVE_GAME));
		}
		
		private function countDownTimerHdl(e:Event):void
		{
			timeCount++;
			if (timeCount == Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_REWARD_DELAY_IN_SECOND))
			{
				timeCount = 0;
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.TRAIN_REWARD));
			}
		}
		
		private function countDownCompleteHdl(e:Event):void
		{
			Manager.display.showDialog(DialogID.YES_NO, receivedEXPHdl, null, { title: "THÔNG BÁO", message: "Chỉ điểm võ công hoàn tất. Bạn đã nhận được tổng cộng " + receivedEXP + " EXP", option: YesNo.YES } );
			var keepedIsHost:Boolean = this.isHost;
			var keepedPlayerCount:int = playerCount;
			reset();
			playerCount = keepedPlayerCount;
			setHost(keepedIsHost);
			
			if (keepedIsHost)
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.TRAIN_STOP));
		}
		
		private function receivedEXPHdl():void 
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
			onAcceptLeaveHdl();
		}
		
		private function setButtonsEnable(enable:Boolean):void
		{
			inviteBtn.mouseEnabled = enable;
			announceBtn.mouseEnabled = enable;
			kickBtn.mouseEnabled = enable;
			
			inviteBtn.visible = enable;
			announceBtn.visible = enable;
			kickBtn.visible = enable;
			
			autoStartChb.visible = enable;
		}
		
		public function startTraining():void
		{
			readyMov.visible = false;
			setButtonsEnable(false);
			timeCount = 0;
			receivedEXP = 0;
			countDown.startCountDown(Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_DURATION_IN_MINUTE) * 60);
		}
		
		public function stopTraining():void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
			reset();
		}
		
		public function pauseAllAnims():void
		{
			hostCharacter.visible = false;
			partnerCharacter.visible = false;
			hostCharacter.animator.pause();
			partnerCharacter.animator.pause();
		}
		
		public function reset():void
		{
			timeCount = 0;
			isAllPlayerReady = false;
			readyMov.visible = false;
			rewardMov.visible = false;
			isHost = false;
			playerCount = 0;
			
			startBtn.visible = false;
			readyBtn.visible = true;
			setButtonsEnable(false);
			
			countDown.stopCountDown();
			countDown.updateTf(Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_DURATION_IN_MINUTE) * 60);
		}
		
		public function playerJoinRoom(charater:Character, pIsHost:Boolean):void
		{
			playerCount++;
			var characterView:CharacterOutGame = pIsHost ? hostCharacter : partnerCharacter;
			characterView.setData(charater);
			characterView.visible = true;
		}
		
		public function playerLeaveRoom(pIsHost:Boolean):void
		{
			playerCount--;
			isAllPlayerReady = false;
			var characterView:CharacterOutGame = pIsHost ? hostCharacter : partnerCharacter;
			characterView.animator.pause();
			characterView.visible = false;
		}
		
		public function partnerReady():void
		{
			isAllPlayerReady = true;
			readyMov.visible = true;
			if (autoStartChb.selected) startBtnHdl();
		}
		
		public function partnerLeft():void
		{
			isAllPlayerReady = false;
			readyMov.visible = false;
		}
		
		public function resetPlayerCount():void
		{
			playerCount = 0;
		}
		
		public function setHost(isHost:Boolean):void
		{
			this.isHost = isHost;
			startBtn.visible = isHost;
			readyBtn.visible = !isHost;
			setButtonsEnable(isHost);
			autoStartChb.visible = isHost;
		}
		
		public function showReward():void
		{
			rewardMov.tf.text = "BẠN ĐÃ NHẬN ĐƯỢC " + (Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_EXP_REWARD) * Game.database.userdata.level) + " EXP";
			receivedEXP += Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_EXP_REWARD) * Game.database.userdata.level;
			rewardMov.alpha = 0;
			rewardMov.visible = true;
			rewardMov.y = 275;
			TweenMax.to(rewardMov, 0.5, {y: rewardMov.y - 20, alpha: 1});
			TweenMax.to(rewardMov, 0.5, {alpha: 0, delay: 2});
		}
	
	}

}