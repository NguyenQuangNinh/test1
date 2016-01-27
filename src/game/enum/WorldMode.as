package game.enum
{
	import core.util.Enum;
	import game.ui.ingame.pvp.WorldTutorial;
	
	import game.ui.ingame.pvp.WorldPvE;
	import game.ui.ingame.pvp.WorldPvP;
	
	public class WorldMode extends Enum
	{
		public static const PVE:WorldMode = new WorldMode(WorldPvE, 0, "world_mode_pve");
		public static const PVP:WorldMode = new WorldMode(WorldPvP, 1, "world_mode_pvp");
		public static const TUTORIAL:WorldMode = new WorldMode(WorldTutorial, 2, "world_mode_tutorial");
		
		public var worldClass:Class;
		
		public function WorldMode(worldClass:Class, ID:int, name:String="")
		{
			super(ID, name);
			this.worldClass = worldClass;
		}
	}
}