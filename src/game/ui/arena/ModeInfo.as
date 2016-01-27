package game.ui.arena
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.ModeConfigXML;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.Game;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ModeInfo extends MovieClip
	{
		public var searchBtn:SimpleButton;
		public var createRoomBtn:SimpleButton;
		public var refreshBtn:SimpleButton;
		public var joinBtn:SimpleButton;
		public var enterLobbyBtn:SimpleButton;
		public var matchingBtn:SimpleButton
		public var quickJoinBtn:SimpleButton;
		public var descTf:TextField;
		
		public var artWorkMov:MovieClip;
		private var _artWorkBitMap:BitmapEx;
		
		private var _info:ModeConfigXML;
		
		public function ModeInfo()
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
			//set fonts
			descTf.visible = false;
			FontUtil.setFont(descTf, Font.ARIAL, false);
			
			//add events
			searchBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			createRoomBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			joinBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			enterLobbyBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			refreshBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			matchingBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			quickJoinBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			//init icon
			_artWorkBitMap = new BitmapEx();
			artWorkMov.addChild(_artWorkBitMap);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			if (_info && Game.database.userdata.level >= _info.nLevelRequirement)
			{
				switch (e.target)
				{
					case searchBtn: 
						dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_SEARCH, true));
						break;
					case enterLobbyBtn: 
						dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_ENTER_LOBBY, true));
						break;
					case joinBtn: 
						dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_JOIN, true));
						break;
					case createRoomBtn: 
						dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_CREATE_ROOM, true));
						break;
					case refreshBtn: 
						dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_REFRESH, true));
						break;
					case quickJoinBtn: 
						dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_QUICK_JOIN, true));
						break;
					case matchingBtn: 
						dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_MATCHING, true));
						break;
				}
			}
			else
			{
				Manager.display.showMessage("Bạn chưa đủ level " + _info.nLevelRequirement.toString() + " để tham gia chế độ này");
			}
		}
		
		public function updateInfo(data:ModeConfigXML):void
		{
			_info = data;
			if (data)
			{
				trace("data.fullImage === " + data.fullImage);
				_artWorkBitMap.load(data.fullImage);
				descTf.text = data.desc;
			}
		}
		
		public function changeState(state:int, mode:GameMode, valid:Boolean):void
		{
			hideAllBtn();
			switch (mode)
			{
				case GameMode.PVP_FREE: 
					if (state == ArenaEventName.ARENA_MODE_SELECT) {
						createRoomBtn.visible = true;
						searchBtn.visible = true;
					}
					
					if (state == ArenaEventName.ARENA_ROOM_CREATE) {
						enterLobbyBtn.visible = true;
					}
					
					if (state == ArenaEventName.ARENA_ROOM_SELECT) {
						enterLobbyBtn.visible = true;
						refreshBtn.visible = true;
					}
					
					/*createRoomBtn.visible = valid && (state == ArenaEventName.ARENA_MODE_SELECT);
					searchBtn.visible = valid && (state == ArenaEventName.ARENA_MODE_SELECT);
					enterLobbyBtn.visible = valid && (state == ArenaEventName.ARENA_ROOM_CREATE || state == ArenaEventName.ARENA_ROOM_SELECT);
					refreshBtn.visible = valid && (state == ArenaEventName.ARENA_ROOM_SELECT);*/
					break;
				case GameMode.PVP_2vs2_MM:
					if (state == ArenaEventName.ARENA_MODE_SELECT) {
						joinBtn.visible = true;
						if (valid) {
							joinBtn.mouseEnabled = true;
							MovieClipUtils.removeAllFilters(joinBtn);
						}else {
							joinBtn.mouseEnabled = false;
							MovieClipUtils.applyGrayScale(joinBtn);
						}
					}
					else {
						joinBtn.visible = false;
					}
					break;
				case GameMode.PVP_3vs3_MM:
					if (state == ArenaEventName.ARENA_MODE_SELECT) {
						joinBtn.visible = true;
						if (valid) {
							joinBtn.mouseEnabled = true;
							MovieClipUtils.removeAllFilters(joinBtn);
						}else {
							joinBtn.mouseEnabled = false;
							MovieClipUtils.applyGrayScale(joinBtn);
						}
					}
					
					if (state == ArenaEventName.ARENA_ROOM_CREATE) {
						createRoomBtn.visible = true;
						quickJoinBtn.visible = true;
					}
					break;
				case GameMode.PVP_1vs1_MM:
					if (state == ArenaEventName.ARENA_MODE_SELECT) {
						joinBtn.visible = true;
						if (valid) {
							joinBtn.mouseEnabled = true;
							MovieClipUtils.removeAllFilters(joinBtn);
						}else {
							joinBtn.mouseEnabled = false;
							MovieClipUtils.applyGrayScale(joinBtn);
						}
					}
					else {
						joinBtn.visible = false;
					}
					break;
			}
			
			//descTf.visible = state == ArenaEventName.ARENA_MODE_SELECT;
		}
		
		private function hideAllBtn():void
		{
			searchBtn.visible = false;
			createRoomBtn.visible = false;
			refreshBtn.visible = false;
			joinBtn.visible = false;
			enterLobbyBtn.visible = false;
			matchingBtn.visible = false;
			quickJoinBtn.visible = false;
			descTf.visible = false;
		}
	}

}