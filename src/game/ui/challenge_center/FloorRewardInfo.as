package game.ui.challenge_center
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import core.Manager;
	import core.util.FontUtil;
	
	import game.enum.Font;
	import game.ui.components.Reward1;
	
	public class FloorRewardInfo extends MovieClip
	{
		public var txtFloor:TextField;
		public var containerItems:MovieClip;
		
		public function FloorRewardInfo()
		{
			FontUtil.setFont(txtFloor, Font.ARIAL, true);
		}
		
		public function setData(floor:String, items:Array):void
		{
			txtFloor.text = floor;
			while(containerItems.numChildren > 0)
			{
				Manager.pool.push(containerItems.removeChildAt(0), Reward1);
			}
			var currentX:int = 0;
			for(var i:int = 0; i < items.length; ++i)
			{
				var reward:Reward1 = Manager.pool.pop(Reward1) as Reward1;
				reward.setData(items[i]);
				reward.x = currentX;
				currentX += reward.txtQuantity.textWidth + 40;
				containerItems.addChild(reward);
			}
		}
	}
}