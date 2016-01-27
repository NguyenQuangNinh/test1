/**
 * Created by NinhNQ on 8/27/2014.
 */
package game.ui.dialog.dialogs {
import core.Manager;
import core.util.FontUtil;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

import game.data.vo.reward.RewardInfo;

import game.enum.Font;
import game.ui.components.ItemSlot;


public class SweepRewardItem extends MovieClip
{
    public var titleTf:TextField;
    public var fixReward:Sprite = new Sprite();
    public var randomReward:Sprite = new Sprite();

    public function SweepRewardItem()
    {
        FontUtil.setFont(titleTf, Font.ARIAL, true);

        fixReward.x = 10;
        fixReward.y = 50;

        randomReward.x = 10;
        randomReward.y = 140;

        addChild(fixReward);
        addChild(randomReward);
    }

    public function setData(title:String, fixRewards:Array, randomReward:Array):void
    {
        titleTf.text = title;

        for (var i:int = 0; i < fixRewards.length; i++) {
            var info:RewardInfo = fixRewards[i] as RewardInfo;
            var rewardSlot: ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
            rewardSlot.x = (i % 5) * 65;
            rewardSlot.y = Math.floor(i /5) * 65;
            rewardSlot.setConfigInfo(info.itemConfig);
            rewardSlot.setQuantity(info.quantity);
            fixReward.addChild(rewardSlot);
        }

        for (var j:int = 0; j < randomReward.length; j++) {
            info = randomReward[j] as RewardInfo;
            rewardSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
            rewardSlot.x = (j % 5) * 65;
            rewardSlot.y = Math.floor(j /5) * 65;
            rewardSlot.setConfigInfo(info.itemConfig);
            rewardSlot.setQuantity(info.quantity);
            this.randomReward.addChild(rewardSlot);
        }
    }

    public function reset():void
    {
        while (fixReward.numChildren > 0)
        {
            var child:ItemSlot = fixReward.getChildAt(0) as ItemSlot;
            child.reset();
            Manager.pool.push(child, ItemSlot);
            fixReward.removeChild(child);
        }

        while (randomReward.numChildren > 0)
        {
            child = randomReward.getChildAt(0) as ItemSlot;
            child.reset();
            Manager.pool.push(child, ItemSlot);
            randomReward.removeChild(child);
        }
    }
}
}
