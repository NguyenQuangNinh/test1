/**
 * Created by NinhNQ on 12/25/2014.
 */
package game.ui.express.gui
{

	import core.Manager;
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.PorterType;
	import game.ui.components.ItemSlot;
	import game.ui.express.ExpressView;
	import game.utility.UtilityUI;

	public class HireDialog extends MovieClip
	{
		public var porter1:Porter;
		public var porter2:Porter;
		public var porter3:Porter;
		public var porter4:Porter;
		public var porter5:Porter;

		public var typeTf:TextField;
		public var timeTf:TextField;
		public var refreshTf:TextField;

		public var closeBtn:SimpleButton;
		public var refreshBtn:SimpleButton;
		public var transportBtn:SimpleButton;
		public var buyRedBtn:MovieClip;
		public var rewards:MovieClip;

		private var porters:Array = [];
		private var selectedPorter:Porter;
		private var currRefreshTimes:int;

		public function HireDialog()
		{
			addEventListener(Event.ADDED_TO_STAGE, initUI);
		}

		private function initUI(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initUI);
			porters.push(porter1);
			porters.push(porter2);
			porters.push(porter3);
			porters.push(porter4);
			porters.push(porter5);

			for (var i:int = 0; i < porters.length; i++)
			{
				var p:Porter = porters[i];
				var type:PorterType = Enum.getEnum(PorterType, i + 1) as PorterType;
				p.setType(type, true);
			}

			FontUtil.setFont(typeTf, Font.ARIAL, true);
			FontUtil.setFont(timeTf, Font.ARIAL, true);
			FontUtil.setFont(refreshTf, Font.ARIAL, true);
			FontUtil.setFont(priceTf, Font.ARIAL, true);

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 861;
				closeBtn.y = 32;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, close);
			}

			refreshBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);
			transportBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);
			buyRedBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);

			buyRedBtn.buttonMode = true;
			priceTf.text = Game.database.gamedata.getConfigData(215);
		}

		private function btnClickHdl(event:MouseEvent):void
		{
			switch (event.target)
			{
				case refreshBtn:
					var priceList:Array = Game.database.gamedata.getConfigData(213);
					var index:int = currRefreshTimes + 1;
					var price:int = index >= priceList.length ? priceList[priceList.length - 1] : priceList[index];

					dispatchEvent(new EventEx(ExpressView.REFRESH, price, true));
					break;
				case transportBtn:
					dispatchEvent(new EventEx(ExpressView.START, selectedPorter.type, true));
					break;
				case buyRedBtn:
					dispatchEvent(new EventEx(ExpressView.BUY_RED, null, true));
					break;
			}
		}

		public function close(event:MouseEvent = null):void
		{
			this.visible = false;
		}

		public function show(porterType:PorterType, numOfRefresh:int):void
		{
			selectPorter(porterType);
			setRefreshTimes(numOfRefresh);
			this.visible = true;
		}

		public function setRefreshTimes(value:int):void
		{
			currRefreshTimes = value;
			var maxRefresh:int = Game.database.gamedata.getConfigData(212);
			if(maxRefresh > 0)
			{
				refreshTf.text = value + "/" + maxRefresh;
			}
			else
			{
				refreshTf.text = value.toString();
			}
		}

		public function selectPorter(type:PorterType):void
		{
			if(selectedPorter)
			{
				if(selectedPorter.type != type)
				{
					selectedPorter.setHighlight(false);
					selectedPorter = this["porter" + type.ID] as Porter;
					selectedPorter.setHighlight(true);
				}
			}
			else
			{
				selectedPorter = this["porter" + type.ID] as Porter;
				selectedPorter.setHighlight(true);
			}

			typeTf.text = type.name;
			timeTf.text = Game.database.gamedata.getConfigData(216) + " phút";

			setRewards(type);
		}

		private function setRewards(type:PorterType):void
		{
			while (rewards.numChildren > 0)
			{
				var child:ItemSlot = rewards.getChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
				rewards.removeChild(child);
			}

			var rewardIDs:Array = Game.database.gamedata.getConfigData(type.configID) as Array;
			var itemSlot:ItemSlot;
			for(var i:int = 0; i < rewardIDs.length; i++)
			{
				var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardIDs[i] as int) as RewardXML;
				itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				itemSlot.setConfigInfo(ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID));
				itemSlot.setQuantity(rewardXML.quantity);
				itemSlot.x = i* 65;
				itemSlot.y = 0;
				rewards.addChild(itemSlot);
			}
		}

		private function get priceTf():TextField
		{
			return buyRedBtn.priceTf as TextField;
		}
	}
}
