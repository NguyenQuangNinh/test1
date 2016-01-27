package game.ui.player_profile
{
	import core.display.ModuleBase;
	
	public class PlayerProfileModule extends ModuleBase
	{
		public function PlayerProfileModule()
		{
			super();
		}
		
		override protected function createView():void
		{
			baseView = new PlayerProfileView();
			super.createView();
		}
	}
}