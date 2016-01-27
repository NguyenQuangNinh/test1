package game.ui.quest_main 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	//import game.data.enum.quest.QuestState;
	import game.data.vo.quest_main.QuestInfo;
	import game.enum.Font;
	import game.enum.QuestState;
	import game.ui.quest_transport.QuestTransportEventName;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestMainUI extends MovieClip
	{
		public var finishMov:MovieClip;
		public var nameTf:TextField;
		public var hitMov:MovieClip;
		public var bgMov:MovieClip;
		
		public static const QUEST_MAIN_SELECTED:String = "questMainSelected";
		
		private var _info:QuestInfo;
		
		public function QuestMainUI() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			gotoAndStop("normal");
			//set fonts
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			nameTf.mouseEnabled = false;
			finishMov.visible = false;	
			
			hitMov.buttonMode = true;
			hitMov.addEventListener(MouseEvent.CLICK, onClickHdl);
			
			//second stop
			var openStopFrame:int = this.totalFrames;
			addFrameScript(openStopFrame - 2, function():void {
				stop();
				//trace("effect call stop 2");
				//dispatchEvent(new Event("openFinish"));
			});
		}
		
		private function onClickHdl(e:MouseEvent = null):void 
		{			
			dispatchEvent(new EventEx(QUEST_MAIN_SELECTED, _info, true));
		}
		
		
		public function updateInfo(quest:QuestInfo):void {
			_info = quest;
			
			if (_info && _info.xmlData) {
				nameTf.text = quest.xmlData.name;
				finishMov.visible = quest.state == QuestState.STATE_FINISHED_SUCCESS ? true : false;
				if (quest.isNew && quest.state != QuestState.STATE_FINISHED_SUCCESS)
					gotoAndPlay("new");
			}
			
		}
		
		public function setSelected(selected:Boolean):void {
			bgMov.gotoAndStop(selected ? "selected" : "normal");
		}
	}

}