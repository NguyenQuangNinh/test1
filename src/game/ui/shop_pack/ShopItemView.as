package game.ui.shop_pack
{
	import core.display.ModulesManager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import game.data.xml.DataType;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.enum.ShopID;
	import game.Game;
	import game.ui.components.PagingMov;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ShopItemView extends ViewBase
	{
		private static const SERVER_RESET_AT_HOUR:int = 5;
		
		private static const PAGING_START_FROM_X:int = 530;
		private static const PAGING_START_FROM_Y:int = 505;
		
		private static const ITEM_PACK_START_FROM_X:int = 235;
		private static const ITEM_PACK_START_FROM_Y:int = 210;
		
		private static const MAX_ITEM_PER_ROW:int = 3;
		private static const MAX_ITEM_PER_COL:int = 2;
		
		private static const DISTANCE_ITEM_PER_COL:int = 0 + 242;
		private static const DISTANCE_ITEM_PER_ROW:int = 25 + 105;
		
		public static const UPDATE_NEW_ITEM_BOUGHT:String = "update_new_item_bought";
		
		public var timeTf:TextField;
		public var closeBtn:SimpleButton;
		
		private var _paging:PagingMov;
		private var _itemPacks:Array = [];
		private var _currentPage:int = 1;
		private var _totalPage:int = 1;
		
		private var _timer:Timer;
		private var _remainCount:int;
		private var _itemsContainer:MovieClip;
		private var shopId:int;
		
		public function ShopItemView()
		{
			initUI();
		}
		
		private function initUI():void
		{
			FontUtil.setFont(timeTf, Font.ARIAL, false);
			
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			_itemsContainer = new MovieClip();
			addChild(_itemsContainer);
			
			_paging = new PagingMov();
			_paging.x = PAGING_START_FROM_X;
			_paging.y = PAGING_START_FROM_Y;
			addChild(_paging);
			_paging.addEventListener(PagingMov.GO_TO_NEXT, onIndexChangeHdl);
			_paging.addEventListener(PagingMov.GO_TO_PREV, onIndexChangeHdl);
			
			//init timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
			
			timeTf.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			timeTf.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			switch (e.target)
			{
				case timeTf: 
					dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
					break;
				
				default: 
			}
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case timeTf: 
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Thời gian còn lại để mua vật phẩm"}, true));
					break;
				default: 
					break;
			}
		}
		
		public function updateItemDisplay(shopId:int):void
		{
			this.shopId = shopId;
			//check need reset 
			if (checkNeedUpdate() || (_itemPacks.length == 0 && _itemsContainer.numChildren == 0))
			{
				//load item pack and display
				var itemPacks:Array = Game.database.gamedata.getShopByShopID(shopId);
				
				//sort by priority
				itemPacks.sortOn("itemPriority", Array.NUMERIC | Array.DESCENDING);
				
				var count:int = 0;
				MovieClipUtils.removeAllChildren(_itemsContainer);
				_itemPacks = [];
				for each (var itemPack:ShopXML in itemPacks)
				{
					if(checkSellable(itemPack))
					{
						var item:ItemPackMov = new ItemPackMov();
						item.updateInfo(itemPack, itemPack.levelRequire == Game.database.userdata.level);
						item.x = ITEM_PACK_START_FROM_X + DISTANCE_ITEM_PER_COL * (count % MAX_ITEM_PER_ROW);
						item.y = ITEM_PACK_START_FROM_Y + DISTANCE_ITEM_PER_ROW * (((int)(count / MAX_ITEM_PER_ROW)) % MAX_ITEM_PER_COL);
						_itemsContainer.addChild(item);
						//Utility.log( "updateItemDisplay : " + item.x + " // " + item.y );
						_itemPacks.push(item);
						count++;
					}
				}
				_currentPage = 1;
				_totalPage = Math.ceil(count / (MAX_ITEM_PER_COL * MAX_ITEM_PER_ROW));
			}
			
			_paging.update(_currentPage, _totalPage);
			updateDisplay();
		}

		//Hot fix cho truong hop ban Khuu Xu Co trong Shop Bang Hoi 1 lan duy nhat. Can Server implement tinh nang nay xong se bo doan hot fix nay.
		private function checkSellable(info:ShopXML):Boolean
		{
			if(info.type == ItemType.UNIT)
			{
				if(info.itemID == 351 || info.itemID == 368)// Khuu Xu Co || Hoàng Dung
				{
					if(Game.database.userdata.haveCharacterWithXMLID(info.itemID))
					{
						return false;
					}
				}
			}
			return true;
		}

		private function checkNeedUpdate():Boolean
		{
			var result:Boolean = false;
			//load item pack and display
			var itemPacks:Array = Game.database.gamedata.getShopByShopID(shopId);
			for each (var itemPack:ShopXML in itemPacks)
			{
				var checkExist:Boolean = false;
				for each (var pack:ItemPackMov in _itemPacks)
				{
					if (pack.getItemID() == itemPack.ID)
					{
						checkExist = true;
						break;
					}
				}
				if (!checkExist && _itemPacks.length > 0)
				{
					result = true;
					break;
				}
			}
			//Utility.log("shop check need update new item " + result);
			if(result)
				dispatchEvent(new Event(UPDATE_NEW_ITEM_BOUGHT));
				
			return result;
		}
		
		private function onTimerUpdateHdl(e:TimerEvent):void
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			timeTf.text = Utility.math.formatTime("H-M-S", _remainCount);
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			
			if (_remainCount == 0)
			{
				_timer.stop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function stopCountDown():void
		{
			_timer.stop();
		}
		
		public function startCountDown():void
		{
			_timer.start();
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
			updateDisplay();
		}
		
		private function updateDisplay():void
		{
			//update display
			var count:int = 0;
			for each (var item:ItemPackMov in _itemPacks)
			{
				item.visible = MAX_ITEM_PER_COL * MAX_ITEM_PER_ROW * (_currentPage - 1) <= count && count < MAX_ITEM_PER_ROW * MAX_ITEM_PER_COL * _currentPage;
				count++;
			}
			_paging.update(_currentPage, _totalPage);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE, true));
		}
		
		public function updateListItemBought(info:Array):void
		{
			for (var i:int = 0; i < info.length; i++)
			{
				var obj:Object = info[i];
				for (var j:int = 0; j < _itemPacks.length; j++)
				{
					var item:ItemPackMov = _itemPacks[j];
					if (item.getItemID() == obj.ID)
						item.updateQuantityBought(obj.numBought);
				}
			}
		}
		
		/*public function updateValidBuy():void {
		   for (var i:int = 0; i < _itemPacks.length; i++) {
		   var item:ItemPackMov = _itemPacks[i] as ItemPackMov;
		   item.updateValidBuy();
		   }
		 }*/
		
		public function setTimeCountDown(timeStr:String):void
		{
			//var timeStr:String = packet.value;
			var year:int = parseInt(timeStr.substr(0, 4));
			var month:int = parseInt(timeStr.substr(4, 2));
			var day:int = parseInt(timeStr.substr(6, 2));
			var hour:int = parseInt(timeStr.substr(9, 2));
			var minute:int = parseInt(timeStr.substr(11, 2));
			var second:int = parseInt(timeStr.substr(13, 2));
			
			_remainCount = new Date(year, month - 1, day, 24 - hour + SERVER_RESET_AT_HOUR, 60 - minute, 60 - second).getTime() / 1000;
			timeTf.text = Utility.math.formatTime("H-M-S", _remainCount);
			startCountDown();
		}
	}

}