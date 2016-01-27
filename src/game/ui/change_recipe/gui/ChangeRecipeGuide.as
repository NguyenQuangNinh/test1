package game.ui.change_recipe.gui
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.enum.ItemType;
	import game.ui.change_recipe.ChangeRecipeView;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChangeRecipeGuide extends MovieClip
	{
		public var btnChangeFormationType:SimpleButton;
		public var btnChangeSkill:SimpleButton;
		public var btnChangeInvitation:SimpleButton;
		public var posX:int = 0;
		public var posY:int = 0;
		
		public function ChangeRecipeGuide()
		{
			btnChangeFormationType.addEventListener(MouseEvent.CLICK, onClickChangeFormationType);
			btnChangeSkill.addEventListener(MouseEvent.CLICK, onClickChangeSkill);
			btnChangeInvitation.addEventListener(MouseEvent.CLICK, onClickChangeInvitation);
			posX = this.x;
			posY = this.y;
		}

		private function onClickChangeInvitation(event:MouseEvent):void
		{
			var view:ChangeRecipeView = this.parent as ChangeRecipeView;
			if (view)
			{
				view.changeRecipeContent.visible = false;
				view.closeBtn.visible = false;
				view.changeInvitationContent.itemType = ItemType.MASTER_INVITATION_CHEST;
				view.changeInvitationContent.titleTf.text = "Đổi thiệp Cao Nhân";
				TweenLite.to(this, 0.35, {x: this.x, y: -(this.height + 20), ease: Expo.easeOut, onComplete: showChangeInvitation});
			}
		}
		
		private function onClickChangeSkill(e:Event):void
		{
			var view:ChangeRecipeView = this.parent as ChangeRecipeView;
			if (view)
			{
				view.changeInvitationContent.visible = false;
				view.closeBtn.visible = false;
				view.changeRecipeContent.itemType = ItemType.SKILL_SCROLL;
				view.changeRecipeContent.titleTf.text = "Đổi bí kíp Võ Công";
				TweenLite.to(this, 0.35, {x: this.x, y: -(this.height + 20), ease: Expo.easeOut, onComplete: onCompleteHide});
			}
		}
		
		private function onClickChangeFormationType(e:Event):void
		{
			var view:ChangeRecipeView = this.parent as ChangeRecipeView;
			if (view)
			{
				view.changeInvitationContent.visible = false;
				view.closeBtn.visible = false;
				view.changeRecipeContent.itemType = ItemType.FORMATION_TYPE_SCROLL;
				view.changeRecipeContent.titleTf.text = "Đổi bí kíp Trận Hình";
				TweenLite.to(this, 0.35, {x: this.x, y: -(this.height + 20), ease: Expo.easeOut, onComplete: onCompleteHide});
			}
		}
		
		private function onCompleteHide():void
		{
			var view:ChangeRecipeView = this.parent as ChangeRecipeView;
			if (view)
			{
				view.changeRecipeContent.reset();
				view.changeRecipeContent.visible = true;
				view.changeRecipeContent.changeContainer.visible = false;
			}
		}

		private function showChangeInvitation():void
		{
			var view:ChangeRecipeView = this.parent as ChangeRecipeView;
			if (view)
			{
				view.changeInvitationContent.update();
				view.changeInvitationContent.visible = true;
			}
		}
	}

}