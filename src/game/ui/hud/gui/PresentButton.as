package game.ui.hud.gui 
{
	import core.display.animation.Animator;
	import flash.display.MovieClip;
	
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentButton extends HUDButton
	{
		public var notify:MovieClip;
		private var anim:Animator;
		
		public function PresentButton() 
		{
			notify.visible = false;
			ID = HUDButtonID.PRESENT;
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
	
		override public function setNotify(val:Boolean, jsonData:Object):void 
		{
			super.setNotify(val, jsonData);
			notify.visible = val;
		}
	}

}