package game.ui.daily_task 
{

	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	import game.Game;
	import game.data.vo.suggestion.SuggestionInfo;
	import game.enum.Font;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class DailyTaskItem extends MovieClip 
	{
		public var txtContent		:TextField;
		private var data			:SuggestionInfo;
		private var timerCount		:int;
		private var timer			:Timer;
		private var isComplete		:Boolean;
		
		public function DailyTaskItem() {
			FontUtil.setFont(txtContent, Font.ARIAL, true);
			addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			timer = new Timer(1000, 0);
			timer.stop();
			isComplete = false;
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			if (!isComplete) {
				GameUtil.moveToSuggestion(data);
				Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.CLICK_DAILY_TASK, id:ID}, true));
			}
		}
		
		public function setData(data:SuggestionInfo, type:int, value1:int, value2:int = -1):void {
			this.data = data;
			isComplete = false;
			if (data) {
				var htmlText:String = "";
				htmlText = data.desc + " ";
				switch(type) {
					case DailyTaskType.COUNT_DOWN:
						isComplete = false;
						if (value1 > 0) {
							htmlText += "<u><font color = '#ff0000'>(" + Utility.math.formatTime("H-M-S", value1) + ")</font></u>";
							timerCount = value1;
							if (!timer.running) {
								if (!timer.hasEventListener(TimerEvent.TIMER)) {
									timer.addEventListener(TimerEvent.TIMER, onTimerEventHdl);
								}
								timer.start();
							}
						} else if (data.ID == 5) {
							htmlText += "<u><font color = '#00ff00'>" + "(Sẵn Sàng)" + "</font></u>";
						}
						break;
						
					case DailyTaskType.INT:
						htmlText += "<u><font color = '#ffff00'>" + "(" + value1 + "/" + value2 + ")" + "</font></u>";
						if (value1 >= value2 && data.moduleID != ModuleID.HEROIC_TOWER) {
							isComplete = true;
						}
						break;
						
					case DailyTaskType.BOOLEAN:
						if (value1) {
							htmlText += "<u><font color = '#00ff00'>" + "(Đang Mở)" + "</font></u>";
						} else {
							htmlText += "<u><font color = '#ff0000'>" + "(Chưa Mở)" + "</font></u>";
							isComplete = true;
						}
						break;
					case DailyTaskType.ACTIVE:
						if (value1) {
							htmlText += "<u><font color = '#00ff00'>" + "(Chưa)" + "</font></u>";
						} else {
							htmlText += "<u><font color = '#ff0000'>" + "(Rồi)" + "</font></u>";
							isComplete = true;
						}
						break;
				}
				
				txtContent.htmlText = htmlText;
				FontUtil.setFont(txtContent, Font.ARIAL, true);
			}
		}
		
		private function onTimerEventHdl(e:TimerEvent):void {
			if (data) {
				if (timerCount > 0) {
					timerCount --;
					txtContent.htmlText = data.desc + " " + "<u><font color = '#ff0000'>" + "(" + Utility.math.formatTime("H-M-S", timerCount) + ")</font></u>";
				} else {
					timer.stop();
					txtContent.htmlText = data.desc + " " + "<u><font color = '#1133ff'>(Xong)</font></u>";
				}
			}
			
			FontUtil.setFont(txtContent, Font.ARIAL, true);
		}

		public function get ID():int
		{
			if(data) return data.ID;
			return -1;
		}
	}

}