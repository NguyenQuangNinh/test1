package game.ui.dialog.dialogs 
{
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GlobalBossConfirmDialog extends Dialog 
	{
		public var txtMessage		:TextField;
		public var txtReward		:TextField;
		public var movRewards		:MovieClip;
		private var rewards			:Array;
		private var itemSlot		:ItemSlot;
		
		public function GlobalBossConfirmDialog() {
			txtMessage.mouseEnabled = false;
			txtReward.mouseEnabled = false;
			rewards = [];
		}
		
		override public function onShow():void {
			if (data) {
				if (itemSlot && itemSlot.parent) 
				{
					itemSlot.parent.removeChild(itemSlot);
				}
				txtReward.text = "";
				
				txtMessage.htmlText = data.content;
				FontUtil.setFont(txtMessage, Font.ARIAL);
				
				for each (var slot:ItemSlot in rewards) 
				{
					Manager.pool.push(slot, ItemSlot);
					movRewards.removeChild(slot);
				}
				rewards.splice(0);
				
				var rewardXml:RewardXML;
				var itemConfig:IItemConfig;
				
				if (data.rewards) 
				{
					for (var i:int = 0; i < data.rewards.length; i++) 
					{
						rewardXml = data.rewards[i] as RewardXML;
						itemConfig = ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID) as IItemConfig;
						if (itemConfig) 
						{
							slot = Manager.pool.pop(ItemSlot) as ItemSlot;
							slot.setConfigInfo(itemConfig);
							slot.setQuantity(data.rewards[i].quantity);
							slot.x = i * 60;
							rewards.push(slot);
							movRewards.addChild(slot);
						}
					}
				}
			}
		}
	}

}