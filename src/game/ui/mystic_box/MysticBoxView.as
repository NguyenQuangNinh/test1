package game.ui.mystic_box
{

	import com.facebook.facebook_internal;

	import core.Manager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;

	import game.Game;
	import game.data.model.item.ItemFactory;
	import game.data.vo.change_recipe.ExchangeInvitationVO;
	import game.data.vo.mystic_box.ExchangeMysticBoxLogVO;

	import game.data.vo.suggestion.SuggestionInfo;

	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.enum.SuggestionEnum;
	import game.ui.components.ItemSlot;
	import game.ui.components.ProgressBar;
	import game.ui.mystic_box.gui.ExchangeItem;
	import game.ui.mystic_box.gui.RewardLog;
	import game.ui.suggestion.gui.SuggestItem;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityEffect;

	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author
	 */
	public class MysticBoxView extends ViewBase
	{
		public static const BUY_EXTRA_USE:String = "mystic_buy_extra_use";

		public var rewardLog:RewardLog;
		public var container:MovieClip;
		public var timeTf:TextField;
		public var useTf:TextField;
		public var luckPointTf:TextField;
		public var activatedTf:TextField;
		public var priceMov:MovieClip;
		public var buyBtn:SimpleButton;
		public var progress:ProgressBar;
		private var closeBtn:SimpleButton;
		private var boxIDs:Array = [];
		private var items:Array = [];
		private var itemSlot:ItemSlot;
		private var logRowCount:int = 0;

		public function MysticBoxView()
		{
			FontUtil.setFont(timeTf, Font.ARIAL, true);
			FontUtil.setFont(useTf, Font.ARIAL, true);
			FontUtil.setFont(luckPointTf, Font.ARIAL, true);
			FontUtil.setFont(activatedTf, Font.ARIAL, true);
			FontUtil.setFont(priceTf, Font.ARIAL, true);

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 1006;
				closeBtn.y = 110;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			progress.progressTf.visible = false;
			activatedTf.visible = false;

			boxIDs = Game.database.gamedata.getConfigData(243);
			for (var i:int = 1; i < boxIDs.length; i++)
			{
				var item:ExchangeItem = new ExchangeItem();
				item.setData(boxIDs[i], i);
				item.y = i* item.height - item.height;
				container.addChild(item);
				items.push(item);
			}

			var timeStart:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(247));
			var timeEnd:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(248));
			var formater:DateTimeFormatter = new DateTimeFormatter("en-US");
			formater.setDateTimePattern("HH:mm dd-MM-yyyy");
			timeTf.text = formater.format(timeStart) + " đến " + formater.format(timeEnd);

			checkEnableBuyBtn();
		}

		private function checkEnableBuyBtn():void
		{
			var currNumOfBuy:int = Game.database.userdata.numBuyUseMysticBox;
			var prices:Array = Game.database.gamedata.getConfigData(250);
			var maxBuy:int = prices.length - 1;

			if(currNumOfBuy == maxBuy)
			{
				buyBtn.mouseEnabled = false;
				Utility.setGrayscale(buyBtn, true);
				priceMov.visible = false;
				activatedTf.visible = true;
			}
			else
			{
				buyBtn.mouseEnabled = true;
				Utility.setGrayscale(buyBtn, false);
				buyBtn.addEventListener(MouseEvent.CLICK, buyHdl);
				priceMov.visible = true;
				activatedTf.visible = false;
				priceTf.text = prices[currNumOfBuy + 1];
			}
		}

		private function buyHdl(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(BUY_EXTRA_USE, null, true));
		}

		public function showLog(logs:Array):void
		{
			logRowCount = 0;
			var content:String = getLogString(logs);
			rewardLog.setContent(content);
		}

		private function getLogString(list:Array):String
		{
			var content:String = "";
			var currentLv:int;
			var nextLv:int;
			var names:Array = Game.database.gamedata.getConfigData(254);
			for each (var vo:ExchangeMysticBoxLogVO in list)
			{
				nextLv = boxIDs.indexOf(vo.itemID);
				currentLv = nextLv - 1;
				content += (++logRowCount) + "/Bạn đã đổi " + vo.quantitySrc + " " + names[currentLv] + ".Nhận được " + vo.quantityDes + " " + names[nextLv] + "\n";
			}

			return content;
		}

		public function showAnim(vo:ExchangeMysticBoxLogVO):void
		{

			var content:String = getLogString([vo]);
			rewardLog.appendContent(content);

			if(vo.quantityDes > 0)
			{
				var stageWidth:int = Manager.display.getStage().stageWidth;
				var stageHeight:int = Manager.display.getStage().stageHeight;

				itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				itemSlot.reset();
				itemSlot.setConfigInfo(ItemFactory.buildItemConfig(ItemType.NORMAL_CHEST, vo.itemID), TooltipID.ITEM_COMMON);
				itemSlot.setQuantity(vo.quantityDes);
				itemSlot.x = (stageWidth - 65) / 2;
				itemSlot.y = (stageHeight - 65) / 2;

				UtilityEffect.tweenItemEffect(itemSlot, ItemType.NORMAL_CHEST, onTweenAnimComplete);
			}
		}

		private function onTweenAnimComplete():void
		{
			if (itemSlot)
			{
				itemSlot.reset();
				Manager.pool.push(itemSlot, ItemSlot);
			}
		}

		private function closeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("close", true));
		}

		public function updateItems():void
		{
			for each (var item:ExchangeItem in items)
			{
				item.updateInput();
			}
		}

		public function update():void
		{
			var numOfUse:Array = Game.database.userdata.numUseMysticBoxes;
			var maxUse:Array = Game.database.gamedata.getConfigData(244);
			var additionalUse:Array = Game.database.gamedata.getConfigData(251);
			var names:Array = Game.database.gamedata.getConfigData(254);
			var content:String = "";

			checkEnableBuyBtn();

			if(numOfUse.length == boxIDs.length && additionalUse.length == boxIDs.length)
			{
				for (var i:int = 0; i < numOfUse.length; i++)
				{
					if(buyBtn.mouseEnabled)
					{
						content += "Đã sử dụng " + numOfUse[i] + "/" + maxUse[i] + " " + names[i] + "\n";
					}
					else
					{
						content += "Đã sử dụng " + numOfUse[i] + "/" + (maxUse[i] + additionalUse[i]) + " " + names[i] + "\n";
					}
				}
			}
			else
			{
				Utility.log("Warning: numUseMysticBoxes.length != boxIDs.length || additionalUse.length != boxIDs.length");
			}

			useTf.text = content;

			updateProgressBar();
		}

		private function updateProgressBar():void
		{
			var curr:int = Game.database.userdata.mysticLuckPoint;
			var max:int = Game.database.gamedata.getConfigData(253);
			progress.setPercent(curr/max);

			luckPointTf.text = curr.toString();
		}

		private function get priceTf():TextField
		{
			return priceMov.priceTf as TextField;
		}
	}
}