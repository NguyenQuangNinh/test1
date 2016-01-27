package game.ui.quest_main 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.enum.Font;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ConditionMainUI extends MovieClip
	{
		
		public static const GO_TO_MAIN_ACTION:String = "go_to_main_action";
		
		public var nameTf:TextField;
		public var countTf:TextField;
		public var startBtn:SimpleButton;
		
		private var _info:ConditionInfo;
		
		public function ConditionMainUI() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(countTf, Font.ARIAL, false);
			
			startBtn.addEventListener(MouseEvent.CLICK, onActionClickHdl);
			startBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			startBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case startBtn:
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "VIP: Tới ngay nơi làm nhiệm vụ."}, true));
					break;
				default: 
			}
		
		}
		
		private function onActionClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(GO_TO_MAIN_ACTION, _info, true));
		}
		
		public function updateInfo(info:ConditionInfo): void {
			_info = info;
			if (_info && _info.xmlData) {
				nameTf.text = _info.xmlData.name;
				countTf.text = _info.value + "/" + _info.xmlData.quantity;
				startBtn.visible = GameUtil.checkGoToActionValid(info.xmlData.type) && _info.value < _info.xmlData.quantity;
			}
		}
	}

}