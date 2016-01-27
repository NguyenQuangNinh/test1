package game.ui.message 
{
	import core.display.animation.Animator;
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.Game;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class MiniLoadingView extends MovieClip 
	{
		private var anim	:Animator;
		
		public function MiniLoadingView() {
			anim = new Animator();
			anim.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			anim.load("resource/anim/ui/loadingmini.banim");
			anim.x = Game.WIDTH / 2;
			anim.y = Game.HEIGHT / 2;
			addChild(anim);
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			anim.removeEventListener(Animator.LOADED, onAnimLoadedHdl);
			anim.play(0);
		}
		
	}

}