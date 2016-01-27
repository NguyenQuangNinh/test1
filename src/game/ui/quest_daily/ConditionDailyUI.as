package game.ui.quest_daily 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.ConditionType;
	import game.enum.GameConditionType;
	import game.enum.QuestState;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.utility.GameUtil;
	//import game.data.enum.quest.QuestState;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.enum.Font;
	import game.enum.QuestState;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ConditionDailyUI extends MovieClip
	{
		
		
		
		public var nameTf:TextField;
		public var countTf:TextField;
		public var startBtn:SimpleButton;
		
		private var _info:ConditionInfo;
		
		public function ConditionDailyUI() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(countTf, Font.ARIAL, false);
			
			
		}
		
		
		
		public function updateInfo(info:ConditionInfo/*, questState:int*/): void {
			_info = info;
			if (_info && _info.xmlData) {
				nameTf.text = _info.xmlData.name;
				countTf.text = _info.value + "/" + _info.xmlData.quantity;
				startBtn.visible = GameUtil.checkGoToActionValid(info.xmlData.type) && _info.value < _info.xmlData.quantity;								
			}
		}
	}

}