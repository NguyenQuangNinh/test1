/**
 * Created by NINH on 1/23/2015.
 */
package game.ui.vip_promotion.gui
{

	import com.greensock.TweenMax;

	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;
	import game.data.vo.item.ItemInfo;

	import game.data.xml.VIPDiscountXML;

	import game.enum.Font;
	import game.ui.vip_promotion.VIPPromotionView;

	public class ListItem extends MovieClip
	{
		public static const SPACE:int = 6;
		public static const HEIGHT:int = 71;

		public var vipTf:TextField;
		public var orgPriceTf:TextField;
		public var curPriceTf:TextField;
		public var buyTimes:TextField;
		public var prevBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		public var buyBtn:SimpleButton;
		public var rewardMov:MovieClip;
		public var masker:MovieClip;

		private var data:VIPDiscountXML;

		public function ListItem()
		{
			FontUtil.setFont(vipTf, Font.ARIAL, true);
			FontUtil.setFont(orgPriceTf, Font.ARIAL, true);
			FontUtil.setFont(curPriceTf, Font.ARIAL, true);
			FontUtil.setFont(buyTimes, Font.ARIAL, true);

			prevBtn.addEventListener(MouseEvent.CLICK, nav_clickHandler);
			nextBtn.addEventListener(MouseEvent.CLICK, nav_clickHandler);
			buyBtn.addEventListener(MouseEvent.CLICK, buyBtn_clickHandler);

			rewardMov.mask = masker;
			masker.x = rewardMov.x;
		}

		public function setData(data:VIPDiscountXML, isBought:Boolean):void
		{
			this.data = data;

			orgPriceTf.text = data.orgPrice.toString();
			curPriceTf.text = data.discountedPrice.toString();
			vipTf.text = "VIP " + data.ID.toString();

			buyTimes.text = isBought ? "1/1" : "0/1";
			buyBtn.visible = !isBought && Game.database.userdata.vip >= data.ID;

			for (var i:int = 0; i < data.items.length; i++)
			{
				var info:ItemInfo = data.items[i] as ItemInfo;
				var rewardItem:RewardItem = new RewardItem();
				rewardItem.setData(info);
				rewardItem.x = i*(RewardItem.WIDTH + RewardItem.SPACE);
				rewardMov.addChild(rewardItem);
			}
		}

		public function reset():void
		{
			while(rewardMov.numChildren > 0)
			{
				var rewardItem:RewardItem = rewardMov.removeChildAt(0) as RewardItem;
				rewardItem.reset();
			}

			prevBtn.removeEventListener(MouseEvent.CLICK, nav_clickHandler);
			nextBtn.removeEventListener(MouseEvent.CLICK, nav_clickHandler);
		}

		private function nav_clickHandler(event:MouseEvent):void
		{
			var delta:int = (event.currentTarget == nextBtn) ? -RewardItem.WIDTH : RewardItem.WIDTH;
			move(delta);
		}

		private function move(delta:int):void
		{
			TweenMax.killAll(true);

			var lastPos:int = rewardMov.x + rewardMov.numChildren * RewardItem.WIDTH;
			var upperBound:int = masker.x + masker.width;

			if ((delta < 0) && (lastPos <= upperBound)) return;
			if ((delta > 0) && (rewardMov.x >= masker.x)) return;

			if (rewardMov.width > masker.width)
			{
				var newX:int = rewardMov.x + delta;
				TweenMax.to(rewardMov, 0.3, {x: newX});
			}
		}

		private function buyBtn_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(VIPPromotionView.BUY, data.ID, true));

		}
	}
}
