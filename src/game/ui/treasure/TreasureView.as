package game.ui.treasure
{

	import core.Manager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;

	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.components.ItemSlot;

	import game.ui.treasure.gui.CellTreasureContainer;
	import game.ui.treasure.gui.RewardLog;
	import game.utility.UtilityEffect;
	import game.utility.UtilityUI;


	/**
	 * ...
	 * @author ninhnq
	 */
	public class TreasureView extends ViewBase
	{
		public var rewardLog:RewardLog;

		public var closeBtn:SimpleButton;
		public var oneBtn:SimpleButton;
		public var tenBtn:SimpleButton;
		public var fiftyBtn:SimpleButton;
		public var desciptionTf:TextField;
		public var timeTf:TextField;
		public var totalTf:TextField;
		public var freeTf:TextField;

		private var cellContainer:CellTreasureContainer;
		private var rewardIndexArr:Array;
		private var logRowCount:int = 0;

		public function TreasureView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			if (!stage) addEventListener(Event.ADDED_TO_STAGE, onStageInit);
			else onStageInit();
		}
		
		private function onStageInit(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageInit);

			if (closeBtn != null)
			{
				closeBtn.x = 1053;
				closeBtn.y = 102;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			oneBtn.addEventListener(MouseEvent.CLICK, spinHdl);
			tenBtn.addEventListener(MouseEvent.CLICK, spinHdl);
			fiftyBtn.addEventListener(MouseEvent.CLICK, spinHdl);

			cellContainer = new CellTreasureContainer(this);
			var arrRewardID:Array = Game.database.gamedata.getConfigData(GameConfigID.TREASURE_REWARDS_ID) as Array;
			cellContainer.init(arrRewardID);
			
			this.addChildAt(cellContainer, 1);
			
			FontUtil.setFont(desciptionTf, Font.ARIAL, false);
			FontUtil.setFont(freeTf, Font.TAHOMA, false);
			FontUtil.setFont(totalTf, Font.TAHOMA, false);
			FontUtil.setFont(timeTf, Font.TAHOMA, false);
		}
		
		public function init():void
		{
			var currDig:int = Game.database.userdata.currDigTreasure + 1;
			var prices:Array = Game.database.gamedata.getConfigData(GameConfigID.TREASURE_PRICES) as Array;
			var price:int = (currDig >= prices.length) ? prices[prices.length - 1] : prices[currDig];
			var free:int = (currDig >= prices.length) ? 0 : prices.length - 2 - Game.database.userdata.currDigTreasure;
			var left:int = Game.database.gamedata.getConfigData(GameConfigID.TREASURE_MAX_DIG) - Game.database.userdata.currDigTreasure;
			var timeStart:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(GameConfigID.TREASURE_TIME_START));
			var timeEnd:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(GameConfigID.TREASURE_TIME_END));
			var formater:DateTimeFormatter = new DateTimeFormatter("en-US");
			formater.setDateTimePattern("HH:mm dd-MM-yyyy");

			if(!cellContainer.isRunning()) cellContainer.reset();

			oneBtn.mouseEnabled = true;
			tenBtn.mouseEnabled = true;
			fiftyBtn.mouseEnabled = true;
			closeBtn.mouseEnabled = true;

			desciptionTf.text = (price > 0) ? "Chi phí 1 lần đào: " + price.toString() + " Vàng" : "Lần đào miễn phí";
			totalTf.text = left + "/" + Game.database.gamedata.getConfigData(GameConfigID.TREASURE_MAX_DIG);
			freeTf.text = free.toString();
			timeTf.text = formater.format(timeStart) + " đến " + formater.format(timeEnd);
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new EventEx(TreasureModule.CLOSE_TREASURE));
		}
		
		private function spinHdl(e:MouseEvent):void
		{

			oneBtn.mouseEnabled = false;
			tenBtn.mouseEnabled = false;
			fiftyBtn.mouseEnabled = false;
			closeBtn.mouseEnabled = false;

			var times:int = 1;

			switch (e.target)
			{
				case oneBtn:
					times = 1;
					break;
				case tenBtn:
					times = 10;
					break;
				case fiftyBtn:
					times = 50;
					break;
			}

			this.dispatchEvent(new EventEx(TreasureModule.REQUEST_REWARD_TREASURE, times));
		}

		public function failHandler():void
		{
			oneBtn.mouseEnabled = true;
			tenBtn.mouseEnabled = true;
			fiftyBtn.mouseEnabled = true;
			closeBtn.mouseEnabled = true;
		}

		private var content:String;

		public function updateTreasureView(rewardIndexArr:Array):void
		{
			this.rewardIndexArr = rewardIndexArr;
			var indexRewardID:int = rewardIndexArr[0];

			oneBtn.mouseEnabled = false;
			tenBtn.mouseEnabled = false;
			fiftyBtn.mouseEnabled = false;
			closeBtn.mouseEnabled = false;
			cellContainer.reset();
			cellContainer.startAnim(this.onAnimCompleteHdl);
			//update indexRewardID;
			cellContainer.rewardIndex = indexRewardID;
		}
		
		public function onAnimCompleteHdl():void
		{
			content = getLogString(rewardIndexArr);
			rewardLog.appendContent(content);

			showRewards(rewardIndexArr);

			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
		}

		private var arrRewardEffect:Array;

		private function showRewards(rewardIndexArr:Array):void
		{
			var stageWidth:int = Manager.display.getStage().stageWidth;
			var stageHeight:int = Manager.display.getStage().stageHeight;
			var rs:Array = [];

			for each (var index:int in rewardIndexArr)
			{
				if(rs.indexOf(index) == -1) rs.push(index);
			}

			var length:int = rs.length;
			var arrRewardID:Array = Game.database.gamedata.getConfigData(GameConfigID.TREASURE_REWARDS_ID) as Array;

			arrRewardEffect = [];

			for (var i:int = 0; i < length; i++)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, arrRewardID[rs[i]]) as RewardXML;

				if (rewardXml != null)
				{
					var rewardSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
					rewardSlot.x = (stageWidth - length * 65) / 2 + i * 65;
					rewardSlot.y = (stageHeight - 65) / 2;
					rewardSlot.setConfigInfo(rewardXml.getItemInfo());
					rewardSlot.setQuantity(rewardXml.quantity);
					arrRewardEffect.push(rewardSlot);
				}
			}

			UtilityEffect.tweenItemEffects(arrRewardEffect, function():void
			{
				for each(var slot:ItemSlot in arrRewardEffect)
				{
					slot.reset();
					Manager.pool.push(slot, ItemSlot);
				}

				arrRewardEffect = [];
			}, true);
		}

		public function setLog(rewardIndex:Array):void
		{
			logRowCount = 0;
			var content:String = getLogString(rewardIndex);
			rewardLog.setContent(content);
		}

		private function getLogString(rewardIndex:Array):String
		{
			var arrRewardID:Array = Game.database.gamedata.getConfigData(GameConfigID.TREASURE_REWARDS_ID) as Array;
			var content:String = "";

			for each (var index:int in rewardIndex)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, arrRewardID[index]) as RewardXML;

				if (rewardXml != null)
				{
					content += (++logRowCount) + "/ " + rewardXml.getItemInfo().getName() + " x" + rewardXml.quantity + "\n";
				}
			}

			return content;
		}

		public function isRunning():Boolean
		{
			return cellContainer.isRunning();
		}
	}

}