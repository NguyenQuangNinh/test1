package game.ui.ingame.pve
{
	import core.display.ModuleBase;
	import core.Manager;
	import game.enum.GameMode;
	import game.Game;
	
	public class IngamePVEModule extends ModuleBase
	{
		public var view:IngamePVEView;
		override protected function createView():void
		{
			baseView = new IngamePVEView();
			view = baseView as IngamePVEView;
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			if (Game.flow.getCurrentGameMode() == GameMode.PVE_GLOBAL_BOSS) view.showTop();
			else view.disableTopBtns();
		}

		public function showHintEndGame(content:String = ""):void
		{
			if(baseView)
				view.showHintEndGame(content);
		}
	}
}