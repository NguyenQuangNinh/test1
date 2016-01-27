package game.ui.message 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import game.data.vo.chat.ChatType;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SpeakerItem extends MovieClip 
	{
		private static const MAX_TEXT_LENGTH	:int = 256;
		private static const MAX_SIZE		:int = 100;
		private static const SPEED			:int = 2;
		private static const CONTENT_X		:int = 500;
		public var movBackground			:MovieClip;
		public var movContent				:MovieClip;
		public var movMask					:MovieClip;
		private var messageQueue			:Array;
		private var timer					:Timer;
		private var itemType				:int;
		
		public function SpeakerItem() {
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.visible = false;
			txtContent.autoSize = TextFieldAutoSize.LEFT;
			FontUtil.setFont(txtContent, Font.ARIAL);
			
			messageQueue = [];
			timer = new Timer(10, 0);
		}
		
		public function setContent(type:int, userName:String, message:String, highPriority:Boolean, repeat:int):void {
			if (!messageQueue) return;
			
			if (message && message.length > MAX_TEXT_LENGTH) {
				message = message.slice(0, MAX_TEXT_LENGTH);
			}
			
			if (highPriority) {
				messageQueue.unshift({message:message, repeat:repeat, type:type, userName:userName});
			} else if (messageQueue.length < MAX_SIZE) {
				messageQueue.push({message:message, repeat:repeat, type:type, userName:userName});	
			}
			
			if (messageQueue.length == 1) {
				showMessage(messageQueue[0]);
			}
		}
		
		private function formatMessage(value:int, userName:String, message:String):String {
			itemType = value;
			switch(value) {
				case 0: //he thong
					movBackground.gotoAndStop(1);
					message = "<font color = '#cc0000'>" + message + "</font>";
					break;
					
				case 1: //loa thuong
					movBackground.gotoAndStop(2);
					message = "<font color = '#cc9933'>" + message + "</font>";
					break;
					
				case 2: //loa vip
					movBackground.gotoAndStop(3);
					message = "<font color = '#ffff00'>" + message + "</font>";
					break;
			}
			
			if (userName && userName.length > 0) {
				if (message.indexOf(userName) != -1){
					message = message.replace(userName, "<font color = '#00ff00'>" + userName + "</font>");	
				} else {
					message = "<font color = '#00ff00'>" + userName + ": </font>" + message;
				}
			}
			return message;
		}
		
		private function showMessage(value:Object):void {
			this.visible = true;
			var message:String = formatMessage(value.type, value.userName, value.message);
			if (value.repeat > 0) {
				value.repeat --;
				movContent.x = CONTENT_X;
				txtContent.htmlText = message;
				FontUtil.setFont(txtContent, Font.ARIAL);
				if (!timer.hasEventListener(TimerEvent.TIMER)) {
					timer.addEventListener(TimerEvent.TIMER, onTimerEventHdl);
				}
				timer.start();
			} else {
				messageQueue.shift();
				showMessageComplete();
			}
		}
		
		private function onTimerEventHdl(e:TimerEvent):void {
			movContent.x -= SPEED;
			if (movContent.x < -(txtContent.textWidth + 20)) {
				showMessageComplete();
			}
		}
		
		private function showMessageComplete():void {
			if (timer.running) {
				timer.stop();
			}
			if (timer.hasEventListener(TimerEvent.TIMER)) {
				timer.removeEventListener(TimerEvent.TIMER, onTimerEventHdl);
			}
			
			if (messageQueue.length > 0) {
				showMessage(messageQueue[0]);
			} else {
				this.visible = false;
			}
		}
		
		private function get txtContent():TextField {
			return movContent.txtContent;
		}
	}

}