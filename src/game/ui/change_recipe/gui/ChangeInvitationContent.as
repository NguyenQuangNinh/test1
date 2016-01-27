package game.ui.change_recipe.gui
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	import game.data.model.item.ItemFactory;
	import game.data.vo.change_recipe.ExchangeInvitationVO;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestChangeRecipe;
	import game.ui.change_recipe.ChangeRecipeView;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityEffect;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChangeInvitationContent extends MovieClip
	{
		public var backBtn:SimpleButton;
		
		public var change1Btn:SimpleButton;
		public var change10Btn:SimpleButton;
		public var _itemSlotRecipe:ChangeRecipeItem;
		public var itemOutput1:ChangeRecipeItem;
		public var itemOutput2:ChangeRecipeItem;
		public var quantityTf:TextField;
		public var unitQuantityTf:TextField;
		public var goldTf:TextField;
		public var titleTf:TextField;
		public var chance1Tf:TextField;
		public var chance2Tf:TextField;

		public var itemType:ItemType;
		

		public function ChangeInvitationContent()
		{

			FontUtil.setFont(quantityTf, Font.ARIAL, true);
			FontUtil.setFont(goldTf, Font.ARIAL, true);
			FontUtil.setFont(titleTf, Font.ARIAL, false);
			FontUtil.setFont(unitQuantityTf, Font.ARIAL, true);
			FontUtil.setFont(chance1Tf, Font.ARIAL, true);
			FontUtil.setFont(chance2Tf, Font.ARIAL, true);

			backBtn.addEventListener(MouseEvent.CLICK, onBackHandler);

			change1Btn.addEventListener(MouseEvent.CLICK, onChangeHandler);
			change10Btn.addEventListener(MouseEvent.CLICK, onChangeHandler);


			quantityTf.text = "";
			unitQuantityTf.text = "x" + Game.database.gamedata.getConfigData(237).toString();
			goldTf.text = Game.database.gamedata.getConfigData(240).toString() + " vàng/lần";

			initItems();
		}

		private function initItems():void
		{
			_itemSlotRecipe.init(128, ItemType.MASTER_INVITATION_CHEST, -1);

			chance1Tf.text = Game.database.gamedata.getConfigData(238)[0] + "%";
			chance2Tf.text = Game.database.gamedata.getConfigData(238)[1] + "%";

			var outID1:int = Game.database.gamedata.getConfigData(239)[0];
			var outID2:int = Game.database.gamedata.getConfigData(239)[1];
			itemOutput1.init(outID1, ItemType.MASTER_INVITATION_CHEST, 1);
			itemOutput2.init(outID2, ItemType.MASTER_INVITATION_CHEST, 1);

			update();
		}

		public function update():void
		{
			var inputQuan:int = Game.database.inventory.getItemQuantity(ItemType.MASTER_INVITATION_CHEST, 128);
			quantityTf.text = inputQuan.toString();
		}

		private function onChangeHandler(e:Event):void
		{
			change1Btn.mouseEnabled = false;
			change10Btn.mouseEnabled = false;

			setTimeout(function():void{
				change1Btn.mouseEnabled = true;
				change10Btn.mouseEnabled = true;
			}, 500);

			switch (e.target)
			{
				case change1Btn:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.EXCHANGE_MASTER_INVITATION, 1));
					break;
				case change10Btn:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.EXCHANGE_MASTER_INVITATION, 10));
					break;
			}
		}
		
		private function onBackHandler(e:Event):void
		{
			var view:ChangeRecipeView = this.parent as ChangeRecipeView;
			if (view)
			{
				view.changeRecipeContent.visible = false;
				view.changeInvitationContent.visible = false;

				TweenLite.to(view.changeRecipeGuide, 0.5, {x: view.changeRecipeGuide.posX, y: view.changeRecipeGuide.posY, ease: Expo.easeOut, onComplete: onCompleteShow});
			}
		}
		
		private function onCompleteShow():void
		{
			var view:ChangeRecipeView = this.parent as ChangeRecipeView;
			if (view)
			{
				view.closeBtn.visible = true;
			}
		}
		
		public function reset():void
		{

		}

		private var arrRewardEffect:Array;

		public function showExchangeInvitationSuccess(itemList:Array):void
		{
			var itemSlot:ItemSlot;
			var stageWidth:int = Manager.display.getStage().stageWidth;
			var stageHeight:int = Manager.display.getStage().stageHeight;
			arrRewardEffect = [];
			for (var i:int = 0; i < itemList.length; i++)
			{
				var data:ExchangeInvitationVO = itemList[i];
				itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				itemSlot.reset();
				itemSlot.setConfigInfo(ItemFactory.buildItemConfig(ItemType.MASTER_INVITATION_CHEST, data.itemID), TooltipID.ITEM_COMMON);
				itemSlot.setQuantity(data.quantity);
				itemSlot.x = (stageWidth - length * 65) / 2 + i * 65;
				itemSlot.y = (stageHeight - 65) / 2;
				arrRewardEffect.push(itemSlot);
			}

			UtilityEffect.tweenItemEffects(arrRewardEffect, onTweenAnimComplete, true);
		}

		private function onTweenAnimComplete():void
		{
			for each(var slot:ItemSlot in arrRewardEffect)
			{
				slot.reset();
				Manager.pool.push(slot, ItemSlot);
			}

			arrRewardEffect = [];
		}
	}

}