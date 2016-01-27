/**
 * Created by NinhNQ on 8/27/2014.
 */
package game.ui.dialog.dialogs {
import components.scroll.VerScroll;

import core.Manager;

import flash.display.MovieClip;

import game.Game;

import game.net.lobby.response.ResponseGetSweepingCampaignReward;


public class SweepRewardList extends MovieClip{

    public var scrollbar:MovieClip;
    public var maskMovie:MovieClip;
    public var contentMovie:MovieClip;
    public var vScroller:VerScroll;
    public var currentSweeping:SweepRewardItem;

    public function SweepRewardList() {
        vScroller = new VerScroll(maskMovie, contentMovie, scrollbar);
        contentMovie.x = maskMovie.x;
        contentMovie.y = maskMovie.y;
    }

    public function setData(packet:ResponseGetSweepingCampaignReward):void
    {
        var randomRewards:Array = [];
        var item:SweepRewardItem;
        var sweepTimes:int = 1;

        reset();

        for (var i:int = 0; i < packet.currentSweepTimes; i++)
        {
            randomRewards = [];
            sweepTimes = i + 1;

            for (var j:int = 0; j < packet.randomRewardTimes.length ; j++)
            {
                var index:int = packet.randomRewardTimes[j] as int; // qua random xuat hien o lan can quet thu index
                if(index == sweepTimes)
                {
                    randomRewards.push(packet.randomReward[j]);
                    break;
                }
            }

            item = Manager.pool.pop(SweepRewardItem) as SweepRewardItem;
            item.setData("Càn quét lần " + sweepTimes, packet.fixReward, randomRewards);
            item.y = i * 204;

            contentMovie.addChild(item);
        }

        if(packet.currentSweepTimes < Game.database.userdata.maxSweepTimes)
        {
            currentSweeping = Manager.pool.pop(SweepRewardItem) as SweepRewardItem;
            currentSweeping.setData("Đang càn quét lần " + (contentMovie.numChildren + 1), [], []);
            currentSweeping.y = contentMovie.numChildren * 204;
            contentMovie.addChild(currentSweeping);
        }

		vScroller.updateScroll(contentMovie.height + 10);
		
        if(contentMovie.height > maskMovie.height)
        {
			var pos:Number = maskMovie.y - (contentMovie.height - maskMovie.height);
            vScroller.setContentPos(maskMovie.y - (contentMovie.height - maskMovie.height), 0);
        }
        else
        {
            vScroller.setContentPos(maskMovie.y, 0);
        }

    }

    public function reset():void {
        while (contentMovie.numChildren > 0)
        {
            var child:SweepRewardItem = contentMovie.getChildAt(0) as SweepRewardItem;
            child.reset();
            Manager.pool.push(child, SweepRewardItem);
            contentMovie.removeChild(child);
        }

        vScroller.updateScroll(contentMovie.height);
    }

    public function setTime(timeStr:String = ""):void
    {
        var child:SweepRewardItem = contentMovie.getChildAt(contentMovie.numChildren - 1) as SweepRewardItem;
        child.titleTf.text = "Đang càn quét lần " + (contentMovie.numChildren) + " ( " + timeStr + " )";
    }
}
}
