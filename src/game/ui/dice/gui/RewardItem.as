/**
 * Created by NINH on 1/12/2015.
 */
package game.ui.dice.gui
{

	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;

	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;

	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;

	public class RewardItem extends MovieClip
	{
		public var quantityTf:TextField;
		private var requirePoint:int;
		private var _itemConfig:IItemConfig;

		public function RewardItem()
		{
			FontUtil.setFont(quantityTf, Font.ARIAL, true);
			addEventListener(MouseEvent.ROLL_OVER, overHdl);
			addEventListener(MouseEvent.ROLL_OUT, outHdl);
		}

		private function outHdl(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}

		private function overHdl(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.ITEM_COMMON, value: _itemConfig, quantity: 0}, true));
		}

		public function setData(rewardID:int, requiredPoint:int):void
		{
			var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD,rewardID) as RewardXML;
			if(rewardXML)
			{
				_itemConfig = rewardXML.getItemInfo();
			}

			this.requirePoint = requiredPoint;
			quantityTf.text = requiredPoint.toString();
		}

		public function checkMilestone(accPoint:int):void
		{
			Utility.setGrayscale(this, (accPoint < requirePoint));
		}
	}
}
