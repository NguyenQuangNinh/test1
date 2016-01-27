package game.ui.character_enhancement 
{
	import core.display.ModuleBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterEnhancementModule extends ModuleBase 
	{
		public var view:CharacterEnhancementView;
		public function CharacterEnhancementModule()
		{
			
		}
		
		override protected function createView():void {
			baseView = new CharacterEnhancementView();
			view = baseView as CharacterEnhancementView;
		}
		
		override protected function preTransitionOut():void 
		{
			view.characterUpgrade.clean();
			super.preTransitionOut();
		}
	}

}