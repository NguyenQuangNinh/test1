package game.ui.heroic_tower
{
	import core.display.ModuleBase;

	public class HeroicTowerModule extends ModuleBase
	{
		override protected function createView():void
		{
			baseView = new HeroicTowerView();
		}

		//TUTORIAL
		public function showHintButton():void
		{
			if(baseView)
				HeroicTowerView(baseView).showHintButton();
		}
	}
}