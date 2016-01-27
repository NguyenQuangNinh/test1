package game.ui.arena 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.vo.lobby.LobbyInfo;
	import game.enum.GameMode;
	import game.ui.components.PagingMov;
	import game.ui.components.ScrollBar;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RoomList extends MovieClip
	{
		public static const MAX_ROOM_SHOW_IN_LIST:int = 7;
		private static const DISTANCE_PER_ROOM:int = 40;
		
		public static const REQUEST_ROOM_LIST:String = "requestRoomList";
		
		private static const MODE_SELECT_START_FROM_X:int = 2;	
		private static const MODE_SELECT_START_FROM_Y:int = 5;
		
		public var listMov:MovieClip;
		public var maskMov:MovieClip;
		//public var bgMov:MovieClip;
		//public var titleTf:TextField;
		
		public var filterBgMov:MovieClip;
		public var arrowBtn:SimpleButton;
		
		public var item_1:ModeSelectMov;
		public var item_2:ModeSelectMov;
		public var item_3:ModeSelectMov;
		
		private var _scroll:ScrollBar;		
		private var _paging:PagingMov;
		
		private var _data:Array;
		private var _currentPage:int = 0;
		private var _currentActive:ModeSelectMov;
		//0: stand by
		//1: toward
		//-1: backward
		private var _direction:int = 0;
		private var _mode:GameMode = null;		
		//private var _filterModeMovs:Array = [];
		
		public function RoomList() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);*/	
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}*/
		
		private function initUI():void 
		{
			//init UI
			//FontUtil.setFont(titleTf, Font.ARIAL, true);
			//titleTf.text = "DANH SÁCH PHÒNG";
			listMov.mask = maskMov;
			
			_scroll = new ScrollBar();
			_scroll.x = maskMov.x + maskMov.width;
			_scroll.y = maskMov.y + (maskMov.height - _scroll.height) / 2 + 30;
			addChild(_scroll);
			
			_paging = new PagingMov();
			_paging.x = maskMov.x + (maskMov.width - _paging.width) / 2 + 5;
			_paging.y = maskMov.y + maskMov.height + 5;
			addChild(_paging);
			
			//add events
			addEventListener(PagingMov.GO_TO_NEXT, onGoToNextHdl);
			addEventListener(PagingMov.GO_TO_PREV, onGoToPrevHdl);
			//for filter
			item_1.addEventListener(ModeSelectMov.MODE_SELECTED, onModeSelectedHdl);
			item_2.addEventListener(ModeSelectMov.MODE_SELECTED, onModeSelectedHdl);
			item_3.addEventListener(ModeSelectMov.MODE_SELECTED, onModeSelectedHdl);
			arrowBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			//initFilterMode();
			item_1.updateInfo("x / x" , null);
			//item_2.updateInfo("1 vs 1" , ArenaEventName.PVP_1vs1_FREE);
			//item_3.updateInfo("3 vs 3" , ArenaEventName.PVP_3vs3_FREE);
			//item_2.updateInfo("x / 2" , ModePVPEnum.PVP_1vs1_FREE);
			//item_3.updateInfo("x / 6" , ModePVPEnum.PVP_3vs3_FREE);
			item_2.updateInfo("x / 2" , GameMode.PVP_1vs1_FREE);
			item_3.updateInfo("x / 6" , GameMode.PVP_3vs3_FREE);
			_mode = null;
			_currentActive = item_1;
			item_1.isSelect = true;
		}
		
		private function onModeSelectedHdl(e:EventEx):void 
		{
			filterBgMov.visible = false;
			item_1.visible = filterBgMov.visible;
			item_2.visible = filterBgMov.visible;
			item_3.visible = filterBgMov.visible;
			var data:Object = e.data;
			if (data) {			
				if (data.mode != _currentActive.getMode()) {
					_currentActive.isSelect = false;
					_currentActive = e.target as ModeSelectMov;
					_currentActive.isSelect = true;					
					//filter room
					_currentPage = 0;
					_mode = data.mode;
					onGoToNextHdl(null);
				}
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case arrowBtn:
					filterBgMov.visible = !filterBgMov.visible;
					item_1.visible = filterBgMov.visible;
					item_2.visible = filterBgMov.visible;
					item_3.visible = filterBgMov.visible;
					break;
			}
		}
		
		/*private function initFilterMode():void {
			var modeItem:ModeSelectMov;
			modeItem = new ModeSelectMov();
			modeItem.updateInfo("Tất cả", -1);
			modeItem.x = MODE_SELECT_START_FROM_X;
			modeItem.y = MODE_SELECT_START_FROM_Y;
			filterBgMov.addChild(modeItem);
			
			modeItem.setActive();
			
			modeItem = new ModeSelectMov();
			modeItem.updateInfo("1 vs 1", ArenaEventName.PVP_1vs1_FREE);
			modeItem.x = MODE_SELECT_START_FROM_X;
			modeItem.y += modeItem.hitMov.height + MODE_SELECT_START_FROM_Y;				
			filterBgMov.addChild(modeItem);
			
			
			modeItem = new ModeSelectMov();
			modeItem.updateInfo("3 vs 3", ArenaEventName.PVP_3vs3_FREE);
			modeItem.x = MODE_SELECT_START_FROM_X;
			modeItem.y += modeItem.hitMov.height +  2 * MODE_SELECT_START_FROM_Y;
			filterBgMov.addChild(modeItem);
		}*/
		
		public function onGoToPrevHdl(e:Event = null):void 		
		{
			var fromIndex:int = (_currentPage - 2) * MAX_ROOM_SHOW_IN_LIST;
			var toIndex:int = (_currentPage - 1) * MAX_ROOM_SHOW_IN_LIST - 1;
			_direction = -1;
			dispatchEvent(new EventEx(REQUEST_ROOM_LIST, { from:fromIndex, to:toIndex, mode: _mode }, true));							
		}
		
		public function onGoToNextHdl(e:Event = null):void 
		{	
			var fromIndex:int = _currentPage * MAX_ROOM_SHOW_IN_LIST;
			var toIndex:int = (_currentPage + 1) * MAX_ROOM_SHOW_IN_LIST - 1;
			_direction = 1;
			dispatchEvent(new EventEx(REQUEST_ROOM_LIST, { from:fromIndex, to:toIndex, mode: _mode }, true));			
		}
		
		public function updateRoomList(data:Array):void {
			_data = data;
			if (data) {
				/*data = data.concat(data);
				data = data.concat(data);
				data = data.concat(data);
				data = data.concat(data);
				data = data.concat(data);
				data = data.concat(data);
				data = data.concat(data);*/
				//clear 
				MovieClipUtils.removeAllChildren(listMov);
				
				var room:RoomInfoUI;
				for (var i:int = 0; i < data.length; i++ ) {
					room = new RoomInfoUI();
					room.updateInfo(data[i]);
					room.y = DISTANCE_PER_ROOM * i;					
					listMov.addChild(room);
				}
				if (data.length > 0)
					(listMov.getChildAt(0) as RoomInfoUI).onRoomClickHdl(null);
				
				//update scroll
				_scroll.init(listMov, maskMov, "vertical", true, false, true);	
				updatePaging();
			}
		}		
		
		public function updatePaging():void {
			//update paging
			_currentPage += _direction;
			_paging.update(_currentPage, 0);
		}
		
		public function initUIByMode(mode:GameMode):void {
			_mode = mode;
			_currentPage = 0;
			_direction = 0;
			updateRoomList([]);
			//bgMov.gotoAndStop(mode == ArenaEventName.PVP_FREE ? "free" : "matching");
			//arrowBtn.visible = mode == ArenaEventName.PVP_FREE ? true : false;
			//bgMov.gotoAndStop(mode == ModePVPEnum.PVP_FREE ? "free" : "matching");
			//arrowBtn.visible = mode == ModePVPEnum.PVP_FREE ? true : false;
			arrowBtn.visible = mode == GameMode.PVP_FREE ? true : false;
			filterBgMov.visible = false;
		}
		
		public function setRoomSelected(info:LobbyInfo):void {			
			if (!info) {
				Utility.error("can not set room selected by null info");
				return;
			}
			var index:int = _data.indexOf(info);
			var room:RoomInfoUI;
			for (var i:int = 0 ; i < listMov.numChildren; i++ ) {
				room = listMov.getChildAt(i) as RoomInfoUI;
				room.setSelected(i == index);
				/*if (i == index)
					room.onRoomClickHdl(null);*/
			}
		}
	}

}