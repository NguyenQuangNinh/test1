package game.ui.tuu_lau_chien
{
	import core.display.ViewBase;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import game.data.vo.tuu_lau_chien.ResourceInfo;
	import game.data.xml.CampaignXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Element;
	import game.enum.Font;
	import game.enum.NotifyType;
	import game.Game;
	import game.ui.components.PagingMov;
	import game.ui.dialog.DialogID;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	import game.utility.GameUtil;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TuuLauChienView extends ViewBase
	{
		public static const ON_REQUEST_HISTORY:String = "requestTuuLauChienHistory";
		
		private static const YELLOW_GLOW:GlowFilter = new GlowFilter(0xFFFF00, 1, 10, 10, 3);
		
		public static const MAX_NODES_PER_PAGE:int = 15;
		
		private static const PAGING_START_FROM_X:int = 583;
		private static const PAGING_START_FROM_Y:int = 603;
		private static const BACK_START_FROM_X:int = 1180;
		private static const BACK_START_FROM_Y:int = 10;
		
		private var backBtn:SimpleButton;
		public var historyBtn:SimpleButton;
		public var notify:MovieClip;
		public var helpBtn:SimpleButton;
		
		private var _paging:PagingMov;
		private var _currentPage:int = 1;
		private var _totalPage:int = 1;
		
		public var infoMov:TuuLauChienInfoMov;
		public var nameTf:TextField;
			
			
		//array of iconMov
		public var iconMov_1:TuuLauChienIconMov;
		public var iconMov_2:TuuLauChienIconMov;
		public var iconMov_3:TuuLauChienIconMov;
		public var iconMov_4:TuuLauChienIconMov;
		public var iconMov_5:TuuLauChienIconMov;
		public var iconMov_6:TuuLauChienIconMov;
		public var iconMov_7:TuuLauChienIconMov;
		public var iconMov_8:TuuLauChienIconMov;
		public var iconMov_9:TuuLauChienIconMov;
		public var iconMov_10:TuuLauChienIconMov;
		public var iconMov_11:TuuLauChienIconMov;
		public var iconMov_12:TuuLauChienIconMov;
		public var iconMov_13:TuuLauChienIconMov;
		public var iconMov_14:TuuLauChienIconMov;
		public var iconMov_15:TuuLauChienIconMov;
		
		private var _iconNodes:Array = [];
		private var _nodesInfoCache:Array = [];
		
		public function TuuLauChienView()
		{
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initUI();
		}
		
		public function initUI():void
		{
			//set font
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			
			//add events
			
			//init UI
			
			//back btn
			backBtn = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			
			if (backBtn != null)
			{
				backBtn.x = BACK_START_FROM_X;
				backBtn.y = BACK_START_FROM_Y;
				addChild(backBtn);
				backBtn.addEventListener(MouseEvent.CLICK, onBackClickHdl);
			}
			helpBtn.addEventListener(MouseEvent.CLICK, onHelpClickHdl);
			historyBtn.addEventListener(MouseEvent.CLICK, onHistoryClickHdl);
			notify.visible = false;
			checkNotifyExist();
			
			//paging
			_paging = new PagingMov();
			_paging.x = PAGING_START_FROM_X;
			_paging.y = PAGING_START_FROM_Y;
			addChild(_paging);
			_paging.addEventListener(PagingMov.GO_TO_NEXT, onIndexChangeHdl);
			_paging.addEventListener(PagingMov.GO_TO_PREV, onIndexChangeHdl);
			
			//list icon nodes
			_iconNodes = [iconMov_1, iconMov_2, iconMov_3, iconMov_4, iconMov_5, iconMov_6, iconMov_7, iconMov_8, iconMov_9, iconMov_10, iconMov_11, iconMov_12, iconMov_13, iconMov_14, iconMov_15];
			var index:int;
			_currentPage = 1;
			for (index = 0; index < MAX_NODES_PER_PAGE; index++)
			{
				var iconMov:TuuLauChienIconMov = _iconNodes[index] as TuuLauChienIconMov;
				iconMov.addEventListener(MouseEvent.CLICK, onIconClickHdl);
				iconMov.index = (_currentPage - 1) * MAX_NODES_PER_PAGE + index; //set index up from 0 base
			}
			
			//init data to display for all list nodes
			var listNodeData:Array = GameUtil.getListTuuLauNode();
			_totalPage = (listNodeData.length / MAX_NODES_PER_PAGE > 1) ? Math.ceil(listNodeData.length / MAX_NODES_PER_PAGE) : 1;
			_paging.update(_currentPage, _totalPage);
			
			updateDisplayAtPage(_currentPage);
		}
		
		private function checkNotifyExist():void 
		{
			var obj:Object = Game.database.userdata.checkNotify(NotifyType.NOTIFY_TUU_LAU_CHIEN.ID);
			if (obj)
			{
				if (obj.byteData && obj.byteData.bytesAvailable > 0)
				{
					notify.visible = true;
				}
			}
		}
		
		private function onHistoryClickHdl(e:MouseEvent):void 
		{
			notify.visible = false;
			Game.database.userdata.dismissNotify(NotifyType.NOTIFY_TUU_LAU_CHIEN.ID);
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.setButtonNotify("tuuLauChienBtn", false, null);
			}
			dispatchEvent(new Event(ON_REQUEST_HISTORY, true));
		}
		
		private function onHelpClickHdl(e:MouseEvent):void 
		{
			Manager.display.showDialog(DialogID.HELP_TUULAU);
		}
		
		public function updateNodesInfo(data:Array):void
		{
			//updateDisplayAtPage(_currentPage);
			//clear all data before
			for (var i:int = 0; i < _iconNodes.length; i++)
			{
				var node:TuuLauChienIconMov = _iconNodes[i] as TuuLauChienIconMov;
				node.updateState(false, Element.NEUTRAL, "");
				node.infoData = null;
			}
			
			//update info for all list nodes --> note data is just only resources occupied
			_nodesInfoCache = data;
			for (var j:int = 0; j < _nodesInfoCache.length; j++)
			{
				var info:ResourceInfo = _nodesInfoCache[j] as ResourceInfo;
				updateResourceInfo(info);
			}
		}
		
		private function onIconClickHdl(e:MouseEvent):void
		{
		
		}				
		
		private function onIndexChangeHdl(e:Event):void
		{
			switch (e.type)
			{
				case PagingMov.GO_TO_NEXT: 
					_currentPage++;
					break;
				case PagingMov.GO_TO_PREV: 
					_currentPage--;
					break;
			}
			
			//update display			
			for (var i:int = 0; i < MAX_NODES_PER_PAGE; i++)
			{
				var iconMov:TuuLauChienIconMov = _iconNodes[i] as TuuLauChienIconMov;
				iconMov.index = (_currentPage - 1) * MAX_NODES_PER_PAGE + i;
			}
			
			/*
			 *	[TODO:]
			 * update num paging
			 * update icon display for next paging
			 * update info icons occupied
			 * when get info of icon --> update again to listNode
			 */
			_paging.update(_currentPage, _totalPage);
			
			updateDisplayAtPage(_currentPage);
		}
		
		/*public function resetDisplay():void
		   {
		   _currentPage = 1;
		   this.updateDisplayAtPage(_currentPage);
		 }*/
		
		private function updateDisplayAtPage(page:int):void
		{
			var listNodeData:Array = GameUtil.getListTuuLauNode();
			
			//update tuu lau name
			if (listNodeData.length > 0)
			{
				var missionXML:MissionXML = listNodeData[0] as MissionXML;
				var campaignXML:CampaignXML = Game.database.gamedata.getData(DataType.CAMPAIGN, missionXML.campaignID) as CampaignXML;
				if (campaignXML)
				{
					nameTf.text = campaignXML.name;
				}
			}
			
			for (var index:int = 0; index < _iconNodes.length; index++)
			{
				var node:TuuLauChienIconMov = _iconNodes[index] as TuuLauChienIconMov;
				if (node && node.index <= listNodeData.length)
				{
					var data:MissionXML = listNodeData[node.index] as MissionXML;
					node.xmlData = data;
				}
				else
				{
					Utility.log("can not get mission data out of bound, need check config again");
				}
			}
			
			updateNodesInfo(_nodesInfoCache);
		}
		
		private function onBackClickHdl(e:MouseEvent):void
		{
			infoMov.stopCountOccupied();
			//close tuu lau chien feature
			dispatchEvent(new Event(Event.CLOSE, true));
		}
		
		public function updateSelfInfo(info:ResourceInfo):void
		{
			//update resource owner self
			infoMov.updateInfo(info);
		}
		
		public function updateResourceInfo(info:ResourceInfo):void
		{
			//update display
			for (var i:int = 0; i < _iconNodes.length; i++)
			{
				var node:TuuLauChienIconMov = _iconNodes[i] as TuuLauChienIconMov;
				if (node && node.xmlData.ID == info.id)
				{
					node.infoData = info;
					node.updateState(info.ownerID > 0, info.ownerElement, info.ownerName);
				}
				node.filters = info && node.xmlData.ID == info.id ? [YELLOW_GLOW] : [];
			}
		}
		
		public function resetResourceSelected():void
		{
			//reset resource selected
			for (var i:int = 0; i < _iconNodes.length; i++)
			{
				var node:TuuLauChienIconMov = _iconNodes[i] as TuuLauChienIconMov;
				node.filters = [];
			}
		}
	
	/*public function updateInfoCache(data:ResourceInfo):void
	   {
	   //update info cache
	   for (var i:int = 0; i < _nodesInfoCache.length; i++)
	   {
	   var info:ResourceInfo = _nodesInfoCache[i] as ResourceInfo;
	   if (info && info.id == data.id)
	   {
	   if (data.ownerID != 0)
	   {
	   info = data;
	   }
	   else
	   {
	   _nodesInfoCache.splice(i, 1);
	   }
	
	   break;
	   }
	   }
	 }*/
	}

}