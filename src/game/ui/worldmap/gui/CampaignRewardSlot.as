package game.ui.worldmap.gui 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.Game;
	import game.data.model.CampaignRewardData;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.CampaignXML;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.item.ItemXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.net.lobby.response.ResponseCampaignInfo;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.worldmap.event.EventWorldMap;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class CampaignRewardSlot extends MovieClip
	{
		
		
		public static const UNGIFT : int = 0;
		public static const GIFT : int = 1;
		public static const GIFTED : int = 2;
		
		public static var currentRewardIndex : int; 
		
		public var numStarTf : TextField;
		
		private var rewardXML : RewardXML;
		private var campaignID : int;
		private var rewardIndex : int;

		private var _state:int = 0;
		private var _itemSlot : ItemSlot;
		
		public function CampaignRewardSlot() 
		{
			FontUtil.setFont(numStarTf, Font.ARIAL);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			this.buttonMode = true;
		}
		
		private function onRollOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
		}
		
		private function onRollOverHdl(e:MouseEvent):void {
			if (rewardXML.type == ItemType.ITEM_SET) {
				var itemChestXML : ItemChestXML = Game.database.gamedata.getData(DataType.ITEMCHEST, rewardXML.itemID) as ItemChestXML;
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.ITEM_SET, value: itemChestXML}, true));
			}else {
				var itemConfig : IItemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID);
				//var itemXML : ItemXML = Game.database.gamedata.getData(DataType.ITEM, rewardXML.itemID) as ItemXML;
				//dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.ITEM_COMMON, value: itemXML}, true));
				//dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.ITEM_COMMON, value: itemConfig}, true));
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.REWARD_TOOLTIP, value: rewardXML}, true));
			}
			
		}
		
		private function buildRewardTooltipEvent(rewardXML : RewardXML) : void {
			/*if (rewardXML.type == 7) {
				var itemChestXML : ItemChestXML = Game.database.gamedata.getData(DataType.ITEMCHEST, rewardXML.itemID) as ItemChestXML;
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.ITEM_SET, value: itemChestXML}, true));
			}else (rewardXML.type == 1){
				var itemXML : ItemXML = Game.database.gamedata.getData(DataType.ITEM, rewardXML.itemID) as ItemXML;
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.ITEM_COMMON, value: itemXML}, true));
			}*/
		}
		
		private function onGetReward(e:MouseEvent):void 
		{
			if (this.buttonMode == true) {
				Utility.log("onGetReward campaignID : " + this.campaignID);
				Utility.log("onGetReward rewardIndex : " + this.rewardIndex);
				
				CampaignRewardSlot.currentRewardIndex  = this.rewardIndex;
				
				this.dispatchEvent(new EventWorldMap(EventWorldMap.GET_CAMPAIGN_REWARD, {"campaignID" : campaignID, "rewardIndex" : rewardIndex }, true));
			}
		}
		
		public function setData(rewardXML : RewardXML, campaignID : int, rewardIndex : int, responseCampaignInfo : ResponseCampaignInfo) :void {
			
			this.addEventListener(MouseEvent.CLICK, onGetReward);
			
			this.rewardXML = rewardXML;
			
			//itemSlot = new ItemSlot();
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(this.rewardXML.type, this.rewardXML.itemID));
			_itemSlot.setQuantity(rewardXML.quantity);
			_itemSlot.x = 33;
			_itemSlot.y = 30;
			_itemSlot.visible = false;
			this.addChild(_itemSlot);
			
			this.campaignID = campaignID;
			this.rewardIndex = rewardIndex;
			
			var totalStar : int = responseCampaignInfo.totalStar;
			var isReceiveGift : Boolean = responseCampaignInfo.receiveRewards.indexOf(rewardIndex) >= 0;
			
			if (isReceiveGift) {
				setState(GIFTED);
			}else if (totalStar >= rewardXML.requirement) {
				setState(GIFT);
			}else {
				setState(UNGIFT);
			}
			numStarTf.text = "" + rewardXML.requirement;
		}
		
		public function setState(state : int = 0) :void {
			_state = state;

			switch (state) 
			{
				case UNGIFT:
					
					this.buttonMode = false;
					this.gotoAndStop("lock");
					break;
					
				case GIFT:
					
					this.buttonMode = true;
					this.gotoAndStop("active");
					break;
					
				case GIFTED:
					
					this.buttonMode = false;
					this.gotoAndStop("got");
					break;
					
				default :
					
					this.buttonMode = false;
					this.gotoAndStop("lock");
			}
		}
		
		public function destroy():void {
			removeChild(_itemSlot);
			_itemSlot.reset();
			Manager.pool.push(_itemSlot, ItemSlot);			
		}
		
		public function get state():int
		{
			return _state;
		}
	}

}