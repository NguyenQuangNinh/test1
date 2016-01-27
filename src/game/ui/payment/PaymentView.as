package game.ui.payment
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.pixmafont.PixmaText;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import game.data.model.item.ItemFactory;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.components.ItemSlot;
	import game.ui.components.ProgressBar;
	import game.ui.hud.HUDModule;
	import game.ui.lucky_gift.gui.CellGiftContainer;
	import game.ui.ModuleID;
	import game.ui.present.PresentView;
	import game.utility.GameUtil;
	import game.utility.UtilityEffect;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PaymentView extends ViewBase
	{
		public var closeBtn:SimpleButton;
		public var napBtn:SimpleButton;
		public var receiveBtn:SimpleButton;

		private var _rewardFirst:Array;
		private var _rewardSlotArr:Array = [];
		
		public function PaymentView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = Game.WIDTH - 2 * closeBtn.width - 160;
				closeBtn.y = 2 * closeBtn.height + 30;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			napBtn.addEventListener(MouseEvent.CLICK, napBtnClickHandler);
			receiveBtn.addEventListener(MouseEvent.CLICK, btnNhanRewardFirstChargeClick);
			
			buildGiftItems();
			update();
		}

		private function napBtnClickHandler(event:MouseEvent):void
		{
			Game.database.gamedata.loadPaymentHTML();
		}
		
		private function buildGiftItems():void 
		{
			_rewardFirst = [];
			var arrInt:Array = Game.database.gamedata.getConfigData(GameConfigID.FIRST_CHARE_REWARDS) as Array;
			for each(var nRewardID:int in arrInt)
			{
				var arrReward:Array = GameUtil.getItemRewardsByID(nRewardID) as Array;
				for (var i:int = 0; i < arrReward.length; i++)
				{
					var rewardXml:RewardXML = arrReward[i] as RewardXML;
					if (rewardXml != null)
					{
						_rewardFirst.push(rewardXml);
					}
				}
			}
		}
		
		private function btnNhanRewardFirstChargeClick(e:MouseEvent):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.FIRST_CHARGE_REWARD));
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new EventEx(PaymentModule.CLOSE_PAYMENT_VIEW));
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			
			update();
		}
		
		public function update():void 
		{
			switch(Game.database.userdata.nFirstChargeState)
			{
				case 1:
					receiveBtn.mouseEnabled = false;
					MovieClipUtils.applyGrayScale(receiveBtn);
					break;
				case 2:
					receiveBtn.mouseEnabled = true;
					MovieClipUtils.removeAllFilters(receiveBtn);
					break;
			}
		}
		
		public function showEffectFirstChargeCompleted(): void {
			
			var rewardArr:Array = [];
			rewardArr.push([550, 300]);
			rewardArr.push([670, 300]);
			
			rewardArr.push([810, 250]);
			rewardArr.push([740, 300]);
			rewardArr.push([880, 300]);
			rewardArr.push([770, 350]);
			rewardArr.push([840, 350]);
			
			rewardArr.push([910, 300]);
			var itemSlot:ItemSlot;

			for (var i:int = 0; i < _rewardFirst.length; i++)
			{
				itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				itemSlot.x = rewardArr[i][0];
				itemSlot.y = rewardArr[i][1];
				itemSlot.setConfigInfo(ItemFactory.buildItemConfig(_rewardFirst[i].type, _rewardFirst[i].itemID))
				itemSlot.setQuantity(_rewardFirst[i].quantity);
				_rewardSlotArr.push(itemSlot);
			}

			receiveBtn.visible = false;

			UtilityEffect.tweenItemEffects(_rewardSlotArr, onShowEffectFirstChargeCompleted, true);
		}
		
		private function onShowEffectFirstChargeCompleted():void 
		{
			for each(var slot:ItemSlot in _rewardSlotArr) {
				slot.reset();
				Manager.pool.push(slot, ItemSlot);
			}
			
			_rewardSlotArr = [];
		}
		
	}

}