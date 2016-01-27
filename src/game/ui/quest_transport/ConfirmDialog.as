package game.ui.quest_transport 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ConfirmDialog extends MovieClip
	{
		public static const CONFIRM_SELECTED:String = "confirmSelected";
		public static const CONFIRM_TIME_OUT:String = "confirmTimeOut";
		public static const CLOSE_CONFIRM_DIALOG:String = "closeConfirmDialog";
		
		public static const CONFIRM_FOR_RENT:int = 1;
		public static const CONFIRM_FOR_SKIP:int = 2;
		public static const CONFIRM_FOR_REFRESH:int = 3;
		public static const CONFIRM_FOR_ALL_COMPLETED:int = 4;
		
		public var messageTf:TextField;
		public var timeTf:TextField;
		public var payTf:TextField;
		public var confirmBtn:SimpleButton;
		public var closeBtn:SimpleButton;
		public var xuMov:MovieClip;
		
		private var _type:int;		
		private var _index:int;
		private var _price:int;
		private var _slotIndex:int; 
		
		private var _timer:Timer;
		private var _remainCount:int;
		private var _totalTime:int;
		
		public function ConfirmDialog() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(messageTf, Font.ARIAL, true);
			FontUtil.setFont(timeTf, Font.ARIAL, true);
			FontUtil.setFont(payTf, Font.ARIAL, true);
			
			//add events
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);		
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			//init timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
		}
		
		private function onTimerUpdateHdl(e:TimerEvent):void 
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			timeTf.text = Utility.math.formatTime("M-S", _remainCount);
			//updatePrice();
			//Utility.log("mission on update timer from confirmDialog: " + timeTf.text);
			if (_remainCount == 0) {
				_timer.stop();
				//dispatch event to get new mission ???
				dispatchEvent(new EventEx(CONFIRM_TIME_OUT, { type: _type, index: _index, slotIndex: _slotIndex }, true));
				this.visible = false;
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case confirmBtn:
					_timer.stop();
					dispatchEvent(new EventEx(CONFIRM_SELECTED, { type: _type, index: _index, slotIndex: _slotIndex }, true));					
					break;
				case closeBtn:
					//_timer.stop();
					//_timer.reset();					
					dispatchEvent(new EventEx(CLOSE_CONFIRM_DIALOG, null, true));
					break;
			}
			this.visible = false;
		}
		
		public function update(info:Object): void {
			if (info) {				
				//stop timer if is running
				_timer.stop();				
				
				_type = info.type;
				_index = info.index;
				_price = info.price;
				_remainCount = info.remain;	
				
				//reset text 
				messageTf.text = "";
				payTf.text = "";
				timeTf.text = "";
				
				switch(_type) {
					case CONFIRM_FOR_REFRESH:
						messageTf.text = "Đang tìm nhiệm vụ mới \n\n Nhận ngay 5 nhiệm vụ mới ";	
						payTf.text = _price.toString();
						timeTf.text = Utility.math.formatTime("M-S", _remainCount);
						startCountDown();
						break;
					case CONFIRM_FOR_RENT:
						_slotIndex = info.slotIndex;
						messageTf.text = "Trả tiển để thuê bảo tiêu làm nhiệm vụ? \n \n \n \n Thuê bảo tiêu: ";
						//timeTf.text = "time:";
						payTf.text = _price.toString();
						break;
					case CONFIRM_FOR_SKIP:
						messageTf.text = "Trả tiển để bỏ qua thời gian chờ không? \n \n \n \n Tua nhanh:";
						//timeTf.text = "time";
						_totalTime = info.total;
						payTf.text = _price.toString();
						//startCountDown();
						break;
					case CONFIRM_FOR_ALL_COMPLETED:
						messageTf.text = "Đã hoàn thành tất cả các nhiệm vụ trong ngày \n Quay trở lại vào ngày hôm sau để nhận thêm nhiệm vụ mới";
						break;
				}
				confirmBtn.visible = !(_type == CONFIRM_FOR_ALL_COMPLETED);
				closeBtn.visible = !(_type == CONFIRM_FOR_REFRESH);
				xuMov.visible = !(_type == CONFIRM_FOR_ALL_COMPLETED);
			}
		}
		
		public function startCountDown():void {
			Utility.log( "ConfirmDialog.startCountDown " + _remainCount);
			_timer.start();
		}
		
		private function updatePrice():void {
			/*var priceBase:Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_PRICE_BASE) as Array;
			var timeRefreshBase:int = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_TIME_REFRESH) as int;
			if(priceBase && priceBase[0] && priceBase[1])
				obj.price = Math.ceil((packetState.elapseTimeToNextRandom / 60) / priceBase[0]) * priceBase[1] ;*/
			switch(_type) {
				case CONFIRM_FOR_REFRESH:
					var prices:Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_PRICE_REFRESH) as Array;
					
					var refreshTime:int = Game.database.userdata.nTransportRefresh;
					var price:int = refreshTime < prices.length ? prices[refreshTime] : prices[prices.length - 1];
					
					//if(priceBase && priceBase[0] && priceBase[1])
						//price = Math.ceil((_remainCount / 60) / priceBase[0]) * priceBase[1] ;
					payTf.text = price.toString();
					break;
				case CONFIRM_FOR_SKIP:
					//priceBase = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_PRICE_BASE) as Array;
					//if(priceBase && priceBase[0] && priceBase[1])
						//price = Math.ceil((_remainCount / _totalTime) / priceBase[0]) * priceBase[1] ;
					//payTf.text = price.toString();	
					break;
			}
				
		}
	}

}