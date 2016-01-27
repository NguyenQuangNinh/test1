package game.enum 
{
	import core.util.Enum;
	import game.data.gamemode.ModeDataPVEHeroic;
	
	import game.data.gamemode.ModeDataHeroicTower;
	import game.data.gamemode.ModeDataPvE;
	import game.data.gamemode.ModeDataPvP;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class GameMode extends Enum
	{
		//enum had synced with server 
		public static const PVP_1vs1_AI:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 1, "Hoa Sơn Luận Kiếm");	//1 AI
		public static const PVP_1vs1_FREE:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 2, "luyen tap 1-1");	//2 1vs1F 
		//world campaign
		public static const PVE_WORLD_CAMPAIGN:GameMode = new GameMode(ModeDataPvE, WorldMode.PVE, 3, "world_campaign");
		public static const PVE_GLOBAL_BOSS	:GameMode 	= new GameMode(ModeDataPvE, WorldMode.PVE, 4, "boss the gioi");	//4 raid boss
		public static const PVP_3vs3_FREE:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 5, "luyen tap 3-3");	//5 3vs3 F
		public static const PVP_3vs3_MM:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 6, "tam hung ki hiep");	//6 3vs3 MM		
		public static const PVP_1vs1_MM:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 7, "vo lam minh chu");	//7 1vs1 MM
		//shop giang ho dai hiep
		public static const PVE_SHOP_WARRIOR:GameMode 	= new GameMode(ModeDataPvE, WorldMode.PVE, 8, "giang ho dai hiep");
		public static const HEROIC_TOWER:GameMode 		= new GameMode(ModeDataHeroicTower, WorldMode.PVE, 9, "leo thap");
		public static const PVE_HEROIC:GameMode 		= new GameMode(ModeDataPVEHeroic, WorldMode.PVE, 10, "anh hung ai");
		//tutorial
		public static const PVE_TUTORIAL:GameMode 		= new GameMode(ModeDataPvE, WorldMode.TUTORIAL, 11, "pve_tutorial");
		//tuu lau chien
		public static const PVE_RESOURCE_WAR_NPC:GameMode 	= new GameMode(ModeDataPvE, WorldMode.PVE, 13, "tuu lau chien NPC");
		public static const PVP_RESOURCE_WAR_PVP:GameMode 	= new GameMode(ModeDataPvP, WorldMode.PVP, 14, "tuu lau chien Player");
		public static const PVE_EXPRESS_WAR_PVP:GameMode 	= new GameMode(ModeDataPvP, WorldMode.PVP, 15, "Van tieu cuop NPC");

		public static const PVP_TRAINING:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 12, "PVP_TRAINING");

		//Song hung
		public static const PVP_2vs2_MM:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 16, "Song hung ki hiep");	//6 3vs3 MM

		//mode free style	
		public static const PVP_FREE:GameMode 			= new GameMode(ModeDataPvP, WorldMode.PVP, 100, "luyen tap common");		//1vs1 OR 3vs3
		
		public var dataClass:Class;
		public var worldMode:WorldMode;
		
		public function GameMode(dataClass:Class, worldMode:WorldMode, ID:int, name:String = ""):void
		{
			super(ID, name);
			this.worldMode = worldMode;
			this.dataClass = dataClass;
		}
	}
}