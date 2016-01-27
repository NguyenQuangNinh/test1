/**
 * Created by NinhNQ on 10/21/2014.
 */
package game.ui.home.scene
{
	import flash.events.MouseEvent;

	import game.ui.components.InteractiveAnim;

	public class NPC extends InteractiveAnim
	{
		
		public function NPC()
		{
			
		}

		override protected function onRollOut(e:MouseEvent):void
		{
			super.onRollOut(e);
			animator.play(0, 0);
		}

		override protected function onRollOver(e:MouseEvent):void
		{
			super.onRollOver(e);
			animator.play(1, 0);
		}
	}
}
