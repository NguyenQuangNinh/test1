package game.ui.chat 
{
	import core.util.Enum;
	import flash.geom.Point;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ChatMode extends Enum 
	{
		public static const NORMAL:ChatMode = new ChatMode(1, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.LOBBY, ModuleID.LOADING, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_TOWER, ModuleID.HEROIC_LOBBY, ModuleID.TUULAUCHIEN, ModuleID.EXPRESS], new Point(5, 475), "normal");
		public static const INGAME:ChatMode = new ChatMode(2, [ModuleID.INGAME_PVE, ModuleID.INGAME_PVP], new Point(910, 140), "ingame");
		
		public var point:Point;
		public function getModuleIDs():Array {return moduleIDs;}
		private var moduleIDs:Array = [];
		
		public function ChatMode(ID:int, modules:Array, pos:Point, name:String) {
			super(ID, name);
			moduleIDs = modules;
			point = pos;
		}
		
	}

}