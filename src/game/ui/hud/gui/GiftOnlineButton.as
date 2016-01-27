package game.ui.hud.gui
{
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.ui.hud.HUDButtonID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class GiftOnlineButton extends HUDButton
	{
		public var messageTf:TextField;
		public var notify:MovieClip;
		
		private var _timer:Timer;
		private var _remainCount:int;
		
		public function GiftOnlineButton()
		{
			
			notify.visible = false;
			
			ID = HUDButtonID.GIFT_ONLINE;
			FontUtil.setFont(messageTf, Font.ARIAL, false);
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
			
			messageTf.text = "--:--";
			
			this.startCountDown();
		}
		
		override public function setNotify(val:Boolean, jsonData:Object):void
		{
			super.setNotify(val, jsonData);
			notify.visible = val;
		}
		
		private function onTimerUpdateHdl(e:Event):void
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			messageTf.text = Utility.math.formatTime("M-S", _remainCount);
			
			if (_remainCount == 0)
			{
				_timer.stop();
				this.onCompleteCountDown();
			}
		}
		
		private function onCompleteCountDown():void
		{
			this.setNotify(true, null);
		}
		
		private function stopCountDown():void
		{
			_timer.stop();
		}
		
		public function startCountDown(countDown:int = 0):void
		{
			var nStatusGiftOnline:int = Game.database.userdata.nStatusGiftOnline;
			var arrTimeGiftOnline:Array = Game.database.gamedata.getConfigData(GameConfigID.TIME_GIFT_ONLINE) as Array;
			if (nStatusGiftOnline >= 0 && nStatusGiftOnline < arrTimeGiftOnline.length)
			{
				if (countDown == 0)
				{
					if (arrTimeGiftOnline && nStatusGiftOnline >= 0 && nStatusGiftOnline < arrTimeGiftOnline.length)
					{
						_remainCount = arrTimeGiftOnline[nStatusGiftOnline] * 60 - 5; //delay
					}
				}
				else
					_remainCount = countDown > 0 ? countDown : 0;
				_timer.start();
			}
			else
			{
				messageTf.text = "--:--";
				this.stopCountDown();
			}
		}
	
	}

}