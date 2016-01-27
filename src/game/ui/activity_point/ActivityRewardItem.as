package game.ui.activity_point 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.RewardXML;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.enum.Font;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ActivityRewardItem extends MovieClip
	{
		private var slot:ItemSlot;
		private var itemConfig:IItemConfig;
		public var rewardId:int;
		public var scoreTf:TextField;
		public var arrow:MovieClip;
		public var index:int;
		public var isLocked:Boolean;
		
		public function ActivityRewardItem() 
		{
			this.gotoAndStop("lock");
			FontUtil.setFont(scoreTf, Font.ARIAL, true);
			isLocked = true;
		}
		
		public function lock():void
		{
			this.buttonMode = false;
			this.gotoAndStop("lock");
			isLocked = true;
		}
		
		public function unlock():void
		{
			this.buttonMode = true;
			this.gotoAndStop("unlock");
			isLocked = false;
		}
		
		public function setOpenned():void
		{
			this.buttonMode = false;
			this.gotoAndStop("openned");
			isLocked = true;
		}
		
		public function initReward(score:int, rewardId:int):void
		{
			this.rewardId = rewardId;
			scoreTf.text = score.toString() + " Điểm";
			var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardId) as RewardXML;
			itemConfig = ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID) as IItemConfig;
			
			/*
			var itemConfig:IItemConfig = ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID) as IItemConfig;
			if (itemConfig) 
			{
				slot = new ItemSlot();
				slot.x = 12;
				slot.y = 6;
				slot.setConfigInfo(itemConfig);
				slot.setQuantity(rewardXml.quantity);
				addChild(slot);
			}*/
			
			if (!this.hasEventListener(MouseEvent.MOUSE_OVER)) this.addEventListener(MouseEvent.MOUSE_OVER, onRollOverHdl);
			if (!this.hasEventListener(MouseEvent.MOUSE_OUT)) this.addEventListener(MouseEvent.MOUSE_OUT, onRollOutHdl);
		}
		
		private function onRollOutHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
		}
		
		private function onRollOverHdl(e:MouseEvent):void 
		{
			if (itemConfig) dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.ITEM_COMMON, value: itemConfig}, true));
		}
		
	}

}