package game.ui.quest_daily 
{
	import core.display.BitmapEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.item.ItemXML;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityEffect;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PointReceiveUI extends MovieClip
	{
		//public static const RECEIVE_ACCUMULATE_REWARD:String = "receiveAccumulateRewards";
		
		public var valueTf:TextField;
		public var receivedMov:SimpleButton;
		
		private var _itemSlot:ItemSlot;
		private var _iconImage:BitmapEx;
		private var _itemConfig:IItemConfig;
		private var _itemSlotArr:Array = [];
		
		public function PointReceiveUI() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(valueTf, Font.ARIAL, true);
			
			//add itemslot
			//_itemSlot = new ItemSlot();
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			//_itemSlot.scaleX = _itemSlot.scaleY = 0.7;
			_itemSlot.x = -25;
			_itemSlot.y = valueTf.y + 1.0 * valueTf.height;
			addChild(_itemSlot);
			
			receivedMov.mouseEnabled = false;
			//receivedMov.visible = false;
			//add event
			//receiveBtn.addEventListener(MouseEvent.CLICK, onReceiveClickHdl);
			
			//_iconImage.visible = false;
			/*_iconImage = new BitmapEx();
			_iconImage.load("resource/image/item/icon_xudatau.png");
			_iconImage.addEventListener(BitmapEx.LOADED, onLoadCompletedHdl);			
			addChild(_iconImage);*/
		}
		
		/*private function onLoadCompletedHdl(e:Event):void 
		{
			//_iconImage.x = valueTf.width - _iconImage.width;
			//swap index image and textfield
			_iconImage.x = 2;
			_iconImage.y = 0;
			swapChildren(_iconImage, valueTf);
		}*/
		
		/*private function onReceiveClickHdl(e:MouseEvent):void 
		{
			
		}*/
		
		public function setValue(value:int, reward:RewardXML):void {
			valueTf.text = value > 0 ? value.toString() : "";
			//_iconImage.x = valueTf.textWidth + 2;
			var itemConfig:IItemConfig = ItemFactory.buildItemConfig(reward.type, reward.itemID) as IItemConfig;
			if (itemConfig) {
				_itemConfig = itemConfig;
				_itemSlot.setConfigInfo(itemConfig, TooltipID.ITEM_COMMON);
				_itemSlot.setQuantity(reward.quantity);
			}
		}
		
		public function setReceived(received:Boolean):void {
			receivedMov.visible = received;
			if (received) {
				//gray item
			}
		}
		
		public function destroy():void {
			_itemSlot.reset();
			Manager.pool.push(_itemSlot, ItemSlot);
		}
		
		public function showEffect():void {
			var point:Point = localToGlobal(new Point(_itemSlot.x, _itemSlot.y));
			var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			if (itemSlot) {					
				itemSlot.x = point.x;
				itemSlot.y = point.y;
				itemSlot.setConfigInfo(_itemConfig, "");
				itemSlot.setQuantity(_itemSlot.quantity);
				_itemSlotArr.push(itemSlot);
			}
			UtilityEffect.tweenItemEffect(itemSlot, itemSlot.getItemType(), onShowEffectCompleted);
		}
		
		private function onShowEffectCompleted():void 
		{
			for each(var slot:ItemSlot in _itemSlotArr) {
				slot.reset();
				Manager.pool.push(slot, ItemSlot);
			}
			
			_itemSlotArr = [];
		}
	}

}