package game.ui.challenge_center
{
	import core.display.ModuleBase;
	
	public class ChallengeCenterModule extends ModuleBase
	{
		public function ChallengeCenterModule()
		{
			super();
		}
		
		override protected function createView():void
		{
			baseView = new ChallengeCenterView();
		}

		//TUTORIAL

		public function showHintButton(content:String = ""):void
		{
			if(baseView)
				ChallengeCenterView(baseView).showHintButton(content);
		}
	}
}