package game.ui.character_enhancement
{
	import flash.display.MovieClip;
	
	public class TabContent extends MovieClip
	{
		public function TabContent()
		{
			super();
		}
		
		public function activate():void
		{
			onActivate();
			visible = true;
		}
		
		public function deactivate():void
		{
			onDeactivate();
			visible = false;
		}
		
		protected function onActivate():void
		{
			
		}
		
		protected function onDeactivate():void
		{
			
		}
	}
}