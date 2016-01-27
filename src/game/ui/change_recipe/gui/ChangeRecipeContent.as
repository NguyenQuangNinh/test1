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
	import game.data.model.item.ItemFactory;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.Game;
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
	public class ChangeRecipeContent extends MovieClip
	{
		public var backBtn:SimpleButton;
		
		public var btnChange:SimpleButton;
		public var changeContainer:ChangeRecipeItemContainer;
		public var _itemSlotRecipe:ChangeRecipeItem;
		public var hitChange:MovieClip;
		public var quantityTf:TextField;
		public var goldTf:TextField;
		public var titleTf:TextField;
		
		private var posContainerX:int = 0;
		private var posContainerY:int = 0;
		public var itemType:ItemType;
		
		private var _itemSlot:ItemSlot;
		
		public function ChangeRecipeContent()
		{
			
			FontUtil.setFont(quantityTf, Font.ARIAL, true);
			FontUtil.setFont(goldTf, Font.ARIAL, true);
			FontUtil.setFont(titleTf, Font.ARIAL, false);
			
			backBtn.addEventListener(MouseEvent.CLICK, onBackHandler);
			
			changeContainer.visible = false;
			posContainerX = changeContainer.x;
			posContainerY = changeContainer.y;
			
			hitChange.buttonMode = true;
			hitChange.addEventListener(MouseEvent.CLICK, onHitChangeHandler);
			btnChange.addEventListener(MouseEvent.CLICK, onChangeHandler);
			
			this.addEventListener(ChangeRecipeItem.SELECTED, onSelectItemRecipe);
			quantityTf.text = "";
			quantityTf.restrict = "0-9";
			quantityTf.addEventListener(Event.CHANGE, onTextQuantityInput);
			
			this.parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (changeContainer.visible)
			{
				var rect:flash.geom.Rectangle = changeContainer.getBounds(stage);
				if (!rect.contains(e.stageX, e.stageY))
					changeContainer.visible = false;
			}
		}
		
		private function onTextQuantityInput(e:Event):void
		{
			if (quantityTf.text != "" && _itemSlotRecipe && _itemSlotRecipe._type)
			{
				var quantity:int = parseInt(quantityTf.text.toString());
				//_itemSlotRecipe.setQuantity(quantity);
				this.setTextGoldPrice(quantity);
			}
		}
		
		private function onSelectItemRecipe(e:EventEx):void
		{
			var itemRecipce:ChangeRecipeItem = e.data as ChangeRecipeItem;
			if (itemRecipce && _itemSlotRecipe && itemRecipce != _itemSlotRecipe)
			{
				_itemSlotRecipe.init(itemRecipce._id, itemRecipce._type, itemRecipce._quantity);
				_itemSlotRecipe.x = hitChange.x;
				_itemSlotRecipe.y = hitChange.y;
				quantityTf.text = "" + itemRecipce._quantity;
				changeContainer.visible = false;
				this.setTextGoldPrice(itemRecipce._quantity);
			}
		}
		
		private function onHitChangeHandler(e:Event):void
		{
			//show item container
			
			changeContainer.init(itemType);
			changeContainer.visible = true;
			changeContainer.scaleX = changeContainer.scaleY = 0.2;
			
			changeContainer.x = _itemSlotRecipe.x + _itemSlotRecipe.width;
			changeContainer.y = _itemSlotRecipe.y + _itemSlotRecipe.height;
			
			TweenLite.to(changeContainer, 0.5, {x: posContainerX, y: posContainerY, scaleX: 1, scaleY: 1, ease: Expo.easeOut, onComplete: onCompleteShowContainer});
		}
		
		private function onCompleteShowContainer():void
		{
			//changeContainer.init(itemType);
		}
		
		private function onChangeHandler(e:Event):void
		{
			if (_itemSlotRecipe && _itemSlotRecipe._id > 0 && quantityTf.text != "")
			{
				btnChange.mouseEnabled = false;
				var nQuantity:int = parseInt(quantityTf.text);
				//request server change item
				if (itemType == ItemType.FORMATION_TYPE_SCROLL)
				{
					Game.network.lobby.sendPacket(new RequestChangeRecipe(LobbyRequestType.CHANGE_FORMATION_TYPE_BOOK, _itemSlotRecipe._type.ID, _itemSlotRecipe._id,nQuantity));
				}
				else if (itemType == ItemType.SKILL_SCROLL || itemType == ItemType.SKILL_SCROLL_FIRE || itemType == ItemType.SKILL_SCROLL_EARTH || itemType == ItemType.SKILL_SCROLL_METAL || itemType == ItemType.SKILL_SCROLL_WATER || itemType == ItemType.SKILL_SCROLL_WOOD)
				{
					Game.network.lobby.sendPacket(new RequestChangeRecipe(LobbyRequestType.CHANGE_SKILL_BOOK, _itemSlotRecipe._type.ID, _itemSlotRecipe._id, nQuantity));
				}
			}
			else
				Manager.display.showMessage("Chưa chọn bí kíp cần đổi ^^");
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
					//view.changeRecipeContent.visible = false;
			}
		}
		
		public function reset():void
		{
			quantityTf.text = "";
			goldTf.text = "";
			changeContainer.visible = false;
			if (_itemSlotRecipe)
			{
				_itemSlotRecipe.reset();
			}
		}
		
		private function setTextGoldPrice(quantity:int):void
		{
			var nPricePerTime:int = 0;
			if (itemType == ItemType.FORMATION_TYPE_SCROLL)
			{
				nPricePerTime = Game.database.gamedata.getConfigData(GameConfigID.CHANGE_FORMATION_TYPE_PRICE) as int;
			}
			else if (itemType == ItemType.SKILL_SCROLL || itemType == ItemType.SKILL_SCROLL_FIRE || itemType == ItemType.SKILL_SCROLL_EARTH || itemType == ItemType.SKILL_SCROLL_METAL || itemType == ItemType.SKILL_SCROLL_WATER || itemType == ItemType.SKILL_SCROLL_WOOD)
			{
				nPricePerTime = Game.database.gamedata.getConfigData(GameConfigID.CHANGE_SKILL_PRICE) as int;
			}
			goldTf.text = "" + (quantity * nPricePerTime);
		}
		
		public function showItemChangeRecipeSuccess(itemID:int, itemType:int, quantity:int):void
		{
			var type:ItemType = Enum.getEnum(ItemType, itemType) as ItemType;
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			if (_itemSlot)
			{
				_itemSlotRecipe.destroy();
				this.addChild(_itemSlot);
				_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(type, itemID), TooltipID.ITEM_COMMON);
				_itemSlot.setQuantity(quantity);
				_itemSlot.x = hitChange.x;
				_itemSlot.y = 180;
				_itemSlot.scaleX = _itemSlot.scaleY = 0.3;
				//TweenMax.to(_itemSlot, 3, {bezierThrough: [{x: 730, y: 200}, {x: 825, y: 290}], scaleX: 1, scaleY: 1, ease: Expo.easeOut, onComplete: onCompleteTween});
				TweenMax.to(_itemSlot, 2, {x: _itemSlot.x, y: _itemSlot.y, scaleX: 1, scaleY: 1, ease: Expo.easeOut, onComplete: onCompleteTween});
			}
		}
		
		private function onCompleteTween():void
		{
			_itemSlot.x = _itemSlot.x + this.x;
			_itemSlot.y = _itemSlot.y + this.y;
			UtilityEffect.tweenItemEffect(_itemSlot, _itemSlot.getItemType(), onCompletedFunc);
		}
		
		private function onCompletedFunc():void
		{
			btnChange.mouseEnabled = true;
			if (_itemSlot)
			{
				_itemSlot.reset();
				Manager.pool.push(_itemSlot, ItemSlot);
			}
		}
	}

}