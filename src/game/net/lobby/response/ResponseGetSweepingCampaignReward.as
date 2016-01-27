package game.net.lobby.response 
{
import core.util.Enum;
import core.util.Utility;

import flash.utils.ByteArray;

import game.data.model.item.ItemFactory;

import game.data.vo.reward.RewardInfo;
import game.enum.ItemType;
import game.net.ResponsePacket;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseGetSweepingCampaignReward extends ResponsePacket
	{
		public var result:int = 0;
		public var currentSweepTimes : int = 0;
		public var fixReward : Array = [];
		public var randomReward : Array = [];
        public var randomRewardTimes:Array = []; //luu index cua luot ma phan thuong random xuat hien.
		
		
		override public function decode(data : ByteArray) : void
		{
            result = data.readInt();
            currentSweepTimes = data.readInt();

            if(result > 0) return;

            var itemData : RewardInfo;
            var numFixReward : int = data.readInt();
            for (var i:int = 0; i < numFixReward; i++)
            {

                itemData = new RewardInfo();
                itemData.itemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
                itemData.itemID = data.readInt();
                itemData.quantity = data.readInt();
                itemData.itemConfig =  ItemFactory.buildItemConfig( itemData.itemType, itemData.itemID);

                fixReward.push(itemData);
            }

            var numRandomReward : int = data.readInt();
            for (var j:int = 0; j < numRandomReward; j++)
            {
                itemData = new RewardInfo();
                itemData.itemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
                itemData.itemID = data.readInt();
                itemData.quantity = data.readInt();
                itemData.itemConfig =  ItemFactory.buildItemConfig( itemData.itemType, itemData.itemID);

                randomReward.push(itemData);
                randomRewardTimes.push(data.readInt());
            }

            randomRewardTimes.sort();
            Utility.log(" ---currentSweepTimes: " + currentSweepTimes);
            Utility.log(" ---fix reward: " + fixReward);
            Utility.log(" ---random reward: " + randomReward);
            Utility.log(" ---index reward: " + randomRewardTimes);
		}
		
	}

}