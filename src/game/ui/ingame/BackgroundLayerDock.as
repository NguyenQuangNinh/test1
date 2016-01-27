package game.ui.ingame
{
	import core.util.Enum;
	
	public class BackgroundLayerDock extends Enum
	{
		public static const TOP		:BackgroundLayerDock = new BackgroundLayerDock(1, "top");
		public static const BOTTOM	:BackgroundLayerDock = new BackgroundLayerDock(2, "bottom");
		public static const NONE	:BackgroundLayerDock = new BackgroundLayerDock(3, "none");
		
		public function BackgroundLayerDock(ID:int, name:String="")
		{
			super(ID, name);
		}
	}
}