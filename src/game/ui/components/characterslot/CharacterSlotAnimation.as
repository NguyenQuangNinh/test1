package game.ui.components.characterslot
{
	import core.display.animation.Animator;

	public class CharacterSlotAnimation extends CharacterSlotSimple
	{
		private var animator:Animator = new Animator();
		
		public function CharacterSlotAnimation()
		{
			characterContainer.addChild(animator);
		}
		
		override protected function update():void
		{
			super.update();
			if(data != null)
			{
				animator.load(data.xmlData.animURLs[data.sex]);
				animator.play();
			}
			else
			{
				animator.reset();
			}
		}
	}
}