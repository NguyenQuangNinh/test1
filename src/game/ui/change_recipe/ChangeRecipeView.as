package game.ui.change_recipe
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.Game;
	import game.enum.ItemType;
	import game.ui.change_recipe.gui.ChangeInvitationContent;
	import game.ui.change_recipe.gui.ChangeRecipeContent;
	import game.ui.change_recipe.gui.ChangeRecipeGuide;
	import game.utility.UtilityUI;
	
	
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChangeRecipeView extends ViewBase
	{
		public var closeBtn:SimpleButton;

		public var changeRecipeContent:ChangeRecipeContent;
		public var changeInvitationContent:ChangeInvitationContent;
		public var changeRecipeGuide:ChangeRecipeGuide;
		
		public function ChangeRecipeView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = Game.WIDTH - 2 * closeBtn.width - 275;
				closeBtn.y = 2 * closeBtn.height + 40;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
		
			changeRecipeContent.visible = false;
			changeInvitationContent.visible = false;
		}
		
		private function closeHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(ChangeRecipeModule.CLOSE_CHANGE_RECIPE_VIEW));
		}
		
		public function reset():void
		{
			changeRecipeContent.reset();
			changeInvitationContent.reset();
		}

		public function update():void
		{
			changeInvitationContent.update();
		}

		public function showItemChangeRecipeSuccess(itemID:int, itemType:int, quantity:int):void
		{
			changeRecipeContent.showItemChangeRecipeSuccess(itemID, itemType, quantity);
		}

		public function showExchangeInvitationSuccess(itemList:Array):void
		{
			changeInvitationContent.showExchangeInvitationSuccess(itemList);
		}

		public function resetButtonChange():void
		{
			changeRecipeContent.btnChange.mouseEnabled = true;
			changeInvitationContent.change1Btn.mouseEnabled = true;
			changeInvitationContent.change10Btn.mouseEnabled = true;
		}
	}
}