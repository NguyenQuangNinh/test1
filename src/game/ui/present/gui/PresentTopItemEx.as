package game.ui.present.gui 
{
	import core.display.BitmapEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentTopItemEx extends MovieClip
	{
		public var msgTf:TextField;
		private var itemSlotTemp:TopItem = null;
		public var rewardsMov:MovieClip;
		private const SCALE:Number = 0.6;

		public function PresentTopItemEx() 
		{
			FontUtil.setFont(msgTf, Font.ARIAL);
			rewardsMov.scaleX = SCALE;
			rewardsMov.scaleY = SCALE;
		}
		public function initEx(temp:String, nRewardID:int):void
		{
			msgTf.text = "Hạng từ " + temp;
			buildItem(nRewardID);
		}

		private function buildItem(nRewardID:int):void
		{
			if (nRewardID < 1)
				return;
			var arrReward:Array = GameUtil.getItemRewardsByID(nRewardID);
			for (var i:int = 0; i < arrReward.length; i++)
			{
				var rewardXml:RewardXML = arrReward[i] as RewardXML;
				if (rewardXml != null)
				{
					var itemSlot:TopItem = new TopItem();
					itemSlot.addEventListener(BitmapEx.LOADED, onItemLoadedHdl);
					itemSlot.setConfigInfo(ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID));
					itemSlot.setQuantity(rewardXml.quantity);
				}
			}
		}

		private function onItemLoadedHdl(event:Event):void
		{
			var itemSlot:TopItem = event.currentTarget as TopItem;
			itemSlot.removeEventListener(BitmapEx.LOADED, onItemLoadedHdl);
			itemSlot.x = rewardsMov.width/SCALE;
			itemSlot.y = 0;
//			itemSlot.setScaleItemSlot(0.5);
			rewardsMov.addChild(itemSlot);
		}
	}

}