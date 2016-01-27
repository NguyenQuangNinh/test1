package game.ui.components 
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.Item;
	import game.data.model.item.ItemFactory;
	import game.data.vo.item.ItemInfo;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class Reward extends MovieClip
	{		
		
		//private static const ICON_START_FROM_X:int = 10;
		//private static const ICON_START_FROM_Y:int = 10;
		//private static const ICON_START_FROM_X:int = 0;
		//private static const ICON_START_FROM_Y:int = 0;
		public static const COMPLETED_REWARD_TIME_COUNT_DOWN:String = "completedRewardTimeCountDown";
		public static const SELECTED:String = "selected";
		private static const glow : GlowFilter = new GlowFilter(0x990000, 1, 6, 6, 5);
		
		public static const NORMAL:int = 1;
		public static const QUEST:int = 2;
		public static const EMPTY:int = 3;
		
		public var countTf:TextField;
		public var movIcon:MovieClip;
		private var _itemSlot:ItemSlot;
		private var _timer:Timer;
		private var _remainCount:int;
		
		private var _enableSelect:Boolean = false;
		private var _itemConfig:IItemConfig;
		private var _quantity:int;
		private var _subInfo:Array = [];
		private var _tooltipType:String = "";
		private var _formatTime:String = "H-M";
		
		public function Reward() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			//_itemSlot.x = ICON_START_FROM_X;
			//_itemSlot.y = ICON_START_FROM_Y;
			
			//_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot = new ItemSlot();
			_itemSlot.addEventListener(ItemSlot.ICON_LOADED, onItemSlotLoadedHdl);
			movIcon.addChild(_itemSlot);
			FontUtil.setFont(countTf, Font.ARIAL, true);
			countTf.mouseEnabled = false;
			
			//init timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
			
			addEventListener(MouseEvent.CLICK, onClickHdl);
		}
		
		private function onItemSlotLoadedHdl(e:Event):void {
			_itemSlot.x = - _itemSlot.width / 2;
			_itemSlot.y = - _itemSlot.height / 2;
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFFFF00); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(_itemSlot.x, _itemSlot.y, _itemSlot.width, _itemSlot.height); // (x spacing, y spacing, width, height)
			Utility.log( "Reward.rectangle : " + _itemSlot.x + " // " + _itemSlot.y + " // " + _itemSlot.width + " // " + _itemSlot.height );
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			var local2Global:Point = localToGlobal(new Point(rectangle.x, rectangle.y));
			rectangle.x = local2Global.x;
			rectangle.y = local2Global.y;
			Manager.display.getStage().addChild(rectangle);*/
		}
		
		private function onClickHdl(e:MouseEvent):void 
		{
			if (_enableSelect)
				dispatchEvent(new Event(SELECTED, true));
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}
		
		private function initUI():void 
		{
			//init bg
			//changeType(NORMAL);
			
			_itemSlot = new ItemSlot();
			_itemSlot.x = ICON_START_FROM_X;
			_itemSlot.y = ICON_START_FROM_Y;
			addChild(_itemSlot);			
		}*/		
		
		public function updateInfo(rewardXML:IItemConfig, quantity:int, tooltipType:String = TooltipID.ITEM_COMMON, timeRemain:int = -1, formatTime:String = "H-M"):void {
		//public function updateInfo(itemInfo:Item):void {
			_itemConfig = rewardXML;
			_tooltipType = tooltipType;
			_quantity = quantity;
			_formatTime = formatTime;
			if(rewardXML) {
				//var itemConfig:IItemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID) as IItemConfig;
				//if(itemConfig) {
					_itemSlot.setConfigInfo(rewardXML, tooltipType);
					//_itemSlot.setConfigInfo(itemConfig, _tooltipType != "" ? _tooltipType :
								//rewardXML.type == ItemType.ITEM_SET ? TooltipID.ITEM_SET : TooltipID.ITEM_COMMON, rewardXML.type);
					//_itemSlot.addSudInfo(_subInfo);			
					_itemSlot.setQuantity(quantity);								
				//}
			}
			
			if (timeRemain > 0) {
				_remainCount = timeRemain;
				//Utility.log("reward count down time start from " + timeRemain);
				startCountDown();
				//setTimeout(startCountDown, Math.random() * 3);
				//setTimeout(startCountDown, Math.random() * 3);
			}
		}
		
		/*public function updateConfig(config:IItemConfig):void {
			if (config) {
				_itemSlot.setConfigInfo(config);
			}			
		}*/
		
		public function changeType(type:int):void {
			switch(type) {
				case NORMAL:
					gotoAndStop("normal");
					break;
				case QUEST:
					gotoAndStop("quest");
					break;
				case EMPTY:
					gotoAndStop("empty");
					break;
			}
		}	
		
		private function onTimerUpdateHdl(e:TimerEvent):void 
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			countTf.text = Utility.math.formatTime(_formatTime, _remainCount);
			//Utility.log("timer on count: " + _remainCount);
			
			if (_remainCount == 0) {
				_timer.stop();
				dispatchEvent(new Event(COMPLETED_REWARD_TIME_COUNT_DOWN, true));
			}
		}
		
		public function stopCountDown():void {
			_timer.stop();
		}
		
		//public function startCountDown(startDelay:int):void {
			//_timer.delay = startDelay;
		public function startCountDown():void {
			_timer.start();
		}
		
		public function enableSelect(select:Boolean):void {
			_enableSelect = select;
			this.buttonMode = select;
		}
		
		public function setSelected(selected:Boolean):void {
			//gotoAndStop(selected ? "selected" : "normal");
			this.filters = selected ? [glow] : [];
		}
		
		//public function getRewardXML():RewardXML {
		public function getItemConfig():IItemConfig {
			return _itemConfig;
		}
		
		public function getQuantity():int {
			return _quantity;
		}
		
		public function getGlobalPos():Point {			
			return localToGlobal(new Point(_itemSlot.x, _itemSlot.y));
		}
		
		public function destroy():void {
			_itemSlot.reset();
			_subInfo = [];
			//Manager.pool.push(_itemSlot, ItemSlot);
		}
		
		/*public function addSubInfo(rewards:Array): void {
			_subInfo = rewards;
		}
		
		public function setTooltipType(type:String): void {
			_tooltipType = type;
		}*/
	}

}