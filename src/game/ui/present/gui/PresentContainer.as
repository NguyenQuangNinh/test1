package game.ui.present.gui
{
	import core.event.EventEx;
	import flash.display.MovieClip;
	import game.ui.components.ScrollbarEx;
	import game.ui.present.PresentView;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentContainer extends MovieClip
	{
		public static const BTN_TOP_LEVEL:String = "Đua top nhận thưởng";
		public static const BTN_GIFTCODE:String = "GiftCode";
		public static const BTN_REWARD_LEVEL:String = "Thưởng Lên Cấp";
		public static const BTN_NGU_PHAI_DAI_DE_TU:String = "Ngũ Phái Đại Đệ Tử";
		public static const BTN_DE_TU_CHAN_TRUYEN:String = "Đệ Tử Chân Truyền";
		public static const BTN_CAO_THU_NGU_DAI_PHAI:String = "Cao Thủ Ngũ Đại Phái";
		
		public var contentMask:MovieClip;
		public var track:MovieClip;
		public var slider:MovieClip;
		
		private var scrollbar:ScrollbarEx;
		
		private var _contentScrollBar:MovieClip = new MovieClip();
		//private var _arrBtnName:Array = ["quavip", "duatop", "giftcode", "ngamicaothu", "caibangcaothu", "thuonglevel"];
		public var arrBtnName:Array = [BTN_TOP_LEVEL, BTN_REWARD_LEVEL, BTN_DE_TU_CHAN_TRUYEN, BTN_GIFTCODE];
		private var _arrBtn:Array = [];
		private var _previousIndex:int = -1;
		private var _baseView:PresentView = null;
		
		public function PresentContainer()
		{
			contentMask.visible = false;
			scrollbar = new ScrollbarEx();
			
			this.addChild(_contentScrollBar);
			_contentScrollBar.x = 162;
			_contentScrollBar.y = 135;
			this.addEventListener(PresentButton.BTN_PRESENT_MOUSE_CLICK, onPresentMouseClick);
			
			for (var i:int = 0; i < arrBtnName.length; i++)
			{
				var btnTemp:PresentButton = new PresentButton(arrBtnName[i], i);
				btnTemp.x = 7;
				btnTemp.y = i * 65;
				_arrBtn.push(btnTemp);
			}
		}
		
		private function onPresentMouseClick(e:EventEx):void
		{
			var index:int = e.data as int;
			this.setIndex(index);
		}
		
		public function setIndex(index:int):void
		{
			if (_previousIndex == index || index < 0 || index >= arrBtnName.length)
				return;
			
			setButtonStatus(_previousIndex, false);
			_previousIndex = index;
			setButtonStatus(_previousIndex, true);
			
			if (_baseView != null)
				_baseView.previousIndexView = _previousIndex;
		}
		
		private function setButtonStatus(index:int, bSelect:Boolean):void
		{
			if (index >= 0 && index < _arrBtn.length)
			{
				var btn:PresentButton = _arrBtn[index] as PresentButton;
				btn.isSelected = bSelect;
			}
		}
		
		public function init(view:PresentView):void
		{
			_baseView = view;
			_previousIndex = -1;
			
			while (_contentScrollBar.numChildren > 0)
			{
				_contentScrollBar.removeChildAt(0);
			}
			for each (var btnTemp:PresentButton in _arrBtn)
			{
				btnTemp.isSelected = false;
				_contentScrollBar.addChild(btnTemp);
			}
			
			scrollbar.init(_contentScrollBar, contentMask, track, slider);
			scrollbar.verifyHeight();
		}
		
		public function setNotify(btnName:String, val:Boolean):void
		{
			var btnTemp:PresentButton = _arrBtn[arrBtnName.indexOf(btnName)] as PresentButton;
			if (btnTemp)
			{
				btnTemp.setNotify(val);
			}
		}
	}

}