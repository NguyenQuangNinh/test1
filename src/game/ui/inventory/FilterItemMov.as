package game.ui.inventory 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	
	import game.enum.Font;
	import game.ui.components.IconElement;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class FilterItemMov extends MovieClip 
	{
		public static const SELECTED	:String = "filter_item_mov_selected";
		public var txtContent			:TextField;
		public var movContainer			:MovieClip;
		public var movHit				:MovieClip;
		
		private var _filterValue				:int;
		private var _type						:int;
		private var _isSelect					:Boolean;
		private var iconElement:IconElement;
		
		public function FilterItemMov(_type:int) {
			FontUtil.setFont(txtContent, Font.ARIAL);
			gotoAndStop(1);
			txtContent.mouseEnabled = false;
			buttonMode = true;
			this._type = _type;
			switch(this._type) {
				case InventoryView.FILTER_BY_STAR:
					var mov:MovieClip = UtilityUI.getComponent(UtilityUI.STAR) as MovieClip;
					if (mov) {
						mov.gotoAndStop(1);
						movContainer.addChild(mov);
					}
					break;
					
				case InventoryView.FILTER_BY_CLASS:
					MovieClipUtils.removeAllChildren(movContainer);
					iconElement = new IconElement();
					movContainer.addChild(iconElement);
					break;
			}
			initHandlers();
			
			_isSelect = false;
		}
		
		public function set textContent(value:String):void {
			if (!value) return;
			txtContent.text = value;
		}
		
		private function initHandlers():void {
			movHit.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movHit.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movHit.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			gotoAndStop(3);
			dispatchEvent(new EventEx(SELECTED, _filterValue, true));
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			if (!_isSelect) {
				gotoAndStop(1);
			}
		}
		
		private function onMouseOverHdl(e:MouseEvent):void 	{
			if (!_isSelect) {
				gotoAndStop(2);
			}
		}
		
		public function set isSelect(value:Boolean):void {
			_isSelect = value;
			if (value) {
				gotoAndStop(3);
			} else {
				gotoAndStop(1);
			}
		}
		
		public function get filterValue():int { return _filterValue; }
		public function set filterValue(value:int):void {
			_filterValue = value;
			if (_filterValue == -1) {
				txtContent.text = "Tất cả";
				MovieClipUtils.removeAllChildren(movContainer);
			}
			else
			{
				var starRangeArr:Array = InventoryView.ARR_FILTER_BY_STAR_IN_RANGE;
				txtContent.text = (int)(starRangeArr[_filterValue] + 1).toString()
					+ "-" + starRangeArr[_filterValue + 1];
			}
			
			if(iconElement != null && _filterValue > -1)
			{
				iconElement.setData(_filterValue);
			}
		}
		
	}

}