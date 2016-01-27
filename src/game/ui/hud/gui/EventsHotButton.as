package game.ui.hud.gui
{

	import core.display.animation.Animator;

	import game.Game;
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class EventsHotButton extends HUDButton
	{
		private var anim:Animator;

		public function EventsHotButton()
		{
			ID = HUDButtonID.EVENTS_HOT;
			anim = new Animator();
			anim.setCacheEnabled(true);
			anim.scaleX = anim.scaleY = 0.8;
			anim.load("resource/anim/ui/fx_button.banim");
			anim.mouseEnabled = false;
			anim.mouseChildren = false;
			anim.x = 25;
			anim.y = 30;
			anim.play();
			this.addChild(anim);
		}

		override public function checkVisible():void
		{
			this.visible = Game.database.gamedata.eventsData.availableEvents.length > 0;
		}
	}

}