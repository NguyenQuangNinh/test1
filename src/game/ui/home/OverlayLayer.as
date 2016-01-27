package game.ui.home 
{
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.enum.Font;
	import game.net.lobby.response.ResponseQuestTransportState;
	import game.ui.home.event.EventHome;
	import game.ui.home.gui.MiniMapUI;
	import game.ui.home.gui.PlayerInfoUI;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class OverlayLayer extends Sprite
	{
		public var worldMapBtn : SimpleButton;		
		public var playerInfoUI : PlayerInfoUI;
		//public var miniMapUI : MiniMapUI;
		
		//public var joinRoomPvPBtn: SimpleButton;
		//public var roomName_Tf: TextField;		
		//public var challengeMov:MovieClip;
		public var arenaBtn: SimpleButton;	
		
		public var inventoryBtn 		: SimpleButton;
		public var changeFormationBtn 	: SimpleButton;
		public var powerTransferBtn		: SimpleButton;
		public var upgradeSkillBtn		: SimpleButton;
		public var formationTypeBtn		: SimpleButton;
		public var soulBtn				: SimpleButton;
		public var btnQuestTransport	: SimpleButton;
		public var numTf				: TextField;
		
		private var _timer:Timer;
		private var _remainCount:int;
		
		public function OverlayLayer() 
		{
			//init UI
			FontUtil.setFont(numTf, Font.ARIAL, true);
			
			initEvent();
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onUpdateTimerHdl);
		}
		
		private function onUpdateTimerHdl(e:TimerEvent):void 
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			numTf.text = Utility.math.formatTime("M-S", _remainCount);
			
			if (_remainCount == 0) {
				_timer.reset();
				_timer.stop();
			}
			
		}
		
		private function initEvent() : void {
			worldMapBtn.addEventListener(MouseEvent.CLICK, workMapHandler);
			inventoryBtn.addEventListener(MouseEvent.CLICK, openInventoryHandler);
			formationTypeBtn.addEventListener(MouseEvent.CLICK, openFormationTypeHandler);
			soulBtn.addEventListener(MouseEvent.CLICK, openSoulCenterHandler);
			
			changeFormationBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			powerTransferBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			upgradeSkillBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnQuestTransport.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			arenaBtn.addEventListener(MouseEvent.CLICK, onArenaClickHdl);			
		}
		
		private function openSoulCenterHandler(e:MouseEvent):void 
		{
			Utility.log("openSoulCenterHandler ");
			this.dispatchEvent(new EventHome(EventHome.OPEN_SOUL_CENTER, null, true));
		}
		
		private function openFormationTypeHandler(e:MouseEvent):void 
		{
			Utility.log("openFormationTypeHandler ");
			this.dispatchEvent(new EventHome(EventHome.OPEN_FORMATION_TYPE, null, true));
		}
		
		private function openInventoryHandler(e:MouseEvent):void 
		{
			Utility.log("openInventoryHandler ");
			this.dispatchEvent(new EventHome(EventHome.OPEN_INVENTORY, null, true));
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 	{
			switch(e.target) {
				case powerTransferBtn:
					dispatchEvent(new EventHome(EventHome.SHOW_POWER_TRANSFER, null, true));
					break;
				case changeFormationBtn:
					dispatchEvent(new EventHome(EventHome.SHOW_CHANGE_FORMATION, null, true));
					break;
				case upgradeSkillBtn:
					dispatchEvent(new EventHome(EventHome.SHOW_UPGRADE_SKILL, null, true));
					break;
				case btnQuestTransport:
					dispatchEvent(new EventHome(EventHome.SHOW_QUEST_TRANSPORT, null, true));
					break;
			}
		}
		
		private function onArenaClickHdl(e:MouseEvent):void 
		{
			Utility.log("on show mode arena ");
			this.dispatchEvent(new EventHome(EventHome.SHOW_ARENA_MODE, null, true));
		}
		
		private function workMapHandler(e:MouseEvent):void 
		{
			Utility.log("workMapHandler");
			this.dispatchEvent(new EventHome(EventHome.SHOW_WORLD_MAP_POPUP, null, true));
			
		}
		
		public function updateQuestState(packet:ResponseQuestTransportState): void {
			var state:int = packet.state;
			//Utility.log("receive quest state with errorCode: " + state);
			switch(state) {
				case 0:
					//error 
					numTf.text = "";
					break;
				case 1:
					//has quest but has no completed
					numTf.text = packet.remainQuest.toString();
					break;
				case 2:
					//waiting for the next random
					_remainCount = packet.elapseTimeToNextRandom;
					_timer.start();
					break;
				case 3:
					//out of quests in day
					numTf.text = "";
					btnQuestTransport.visible = false;					
					break;
				case 4:
					//has quest completed but not confirm
					numTf.text = "bingo";
					break;				
			}
		}
	}

}