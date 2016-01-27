/**
 * Created by NinhNQ on 10/24/2014.
 */
package game.ui.home.scene
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ThreePhaseNPC extends NPC
	{
		public function ThreePhaseNPC()
		{
		}

		override protected function onRollOut(e:MouseEvent):void
		{
			super.onRollOut(e);
			animator.removeEventListener(Event.COMPLETE, playFrameComplete)
			animator.play(0, 0);
		}

		override protected function onRollOver(e:MouseEvent):void
		{
			super.onRollOver(e);
			animator.play(1, 1);
			animator.addEventListener(Event.COMPLETE, playFrameComplete)
		}

		private function playFrameComplete(event:Event):void
		{
			animator.removeEventListener(Event.COMPLETE, playFrameComplete);
			animator.play(2, 0);
		}
	}
}
