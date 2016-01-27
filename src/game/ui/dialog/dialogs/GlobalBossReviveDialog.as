package game.ui.dialog.dialogs 
{
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.data.model.item.ItemFactory;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GlobalBossReviveDialog extends Dialog 
	{
		public var txtMessage			:TextField;
		public var txtPrice				:TextField;
		private var timerCompleteFunc	:Function;
		private var timer				:Timer;
		private var remainTime			:int;
		private var itemSlot			:ItemSlot;
		
		public function GlobalBossReviveDialog() {
			timer = new Timer(1000, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHandler);
			timer.stop();
			
			FontUtil.setFont(txtMessage, Font.ARIAL);
			FontUtil.setFont(txtPrice, Font.ARIAL);
		}
		
		override public function onShow():void {
			if (data) {
				remainTime = data.remainTime;
				txtMessage.htmlText = (String)(data.content).replace("?", remainTime.toString());
				FontUtil.setFont(txtMessage, Font.ARIAL);
				
				var paymentType:int = data.paymentType;
				if (data.txtPrice && paymentType) {
					txtPrice.y = txtMessage.y + txtMessage.textHeight + 20;
					var itemType:ItemType = Enum.getEnum(ItemType, paymentType) as ItemType;
					if (itemType) {
						txtPrice.text = data.txtPrice;
						if (!itemSlot) itemSlot = new ItemSlot();
						itemSlot.setConfigInfo(ItemFactory.buildItemConfig(itemType, -1), "", false);
						itemSlot.x = txtPrice.x + (txtPrice.width + txtPrice.textWidth) / 2 + 20;
						itemSlot.y = txtPrice.y - 20;
						addChild(itemSlot);
					}
				} else {
					if (itemSlot && itemSlot.parent) {
						itemSlot.parent.removeChild(itemSlot);
					}
				}
				
				if (!timer.hasEventListener(TimerEvent.TIMER)) {
					timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHandler);	
				}
				timer.start();
			}
		}
		
		override public function onHide():void {
			super.onHide();
			if (timer.running) {
				timer.stop();
			}
			if (timer.hasEventListener(TimerEvent.TIMER)) {
				timer.removeEventListener(TimerEvent.TIMER, onTimerUpdateHandler);
			}
		}
		
		override public function get data():Object {
			return super.data;
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			timerCompleteFunc = data.timerCompleteFunc;
		}
		
		override protected function onCancel(event:Event = null):void {
			if (data) {
				data.remainTimeCountdown = remainTime;
			}
			if (timer.running) {
				timer.stop();
			}
			if (timer.hasEventListener(TimerEvent.TIMER)) {
				timer.removeEventListener(TimerEvent.TIMER, onTimerUpdateHandler);
			}
			super.onCancel(event);
		}
		
		private function onTimerUpdateHandler(e:TimerEvent):void {
			if (remainTime > 0) {
				remainTime --;
				
				txtMessage.htmlText = (String)(data.content).replace("?", remainTime.toString());
				FontUtil.setFont(txtMessage, Font.ARIAL);
			} else {
				timer.stop();
				if (timerCompleteFunc != null) {
					timerCompleteFunc();
				}
				timer.removeEventListener(TimerEvent.TIMER, onTimerUpdateHandler);
			}
		}
		
	}

}