package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LeaderBoardTypeEnum extends Enum
	{
		/*TOP_LADDER_NONE      = 0,
		TOP_LADDER_PVP1_AI     = 1,
		TOP_LADDER_LEVEL       = 2,
		TOP_LADDER_ELO_PVP1_MM = 3,
		TOP_GUILD_LEVEL        = 4,
		TOP_LADDER_ELO_PVP3_MM = 5,
		TOP_LADDER_TOWER       = 6,
		TOP_LADDER_BATTLE_POINT  = 7,*/
		
		/*Cấp độ		--> 0
			Lực chiến	--> 1	
			Hoa sơn luận kiếm : Lấy trong bảng xếp hạng tính năng ra.	--> 2
			Tam hung kỳ hiệp : Lấy trong bảng xếp hạng tính năng ra. Tuần cuối.		--> 3
			Võ lâm minh chủ: Lấy trong bảng xếp hạng tính năng ra. Tuần cuối.		--> 4
			Tháp cao thủ: Lấy trong bảng xếp hạng tính năng ra.						--> 5 */			
		
		/*//enum had synced with server 
		public static const PVP_1vs1_AI:GameMode 		= new GameMode(ModeDataPvP, WorldMode.PVP, 1, "hoa son luan kiem");	//1 AI 
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
		//mode free style	
		public static const PVP_FREE:GameMode 			= new GameMode(ModeDataPvP, WorldMode.PVP, 100, "luyen tap common");		//1vs1 OR 3vs3	*/
			
		public static const TOP_NONE	:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(-1, 0, "none");
		public static const TOP_LEVEL	:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(0, 2, "cap do");
		public static const TOP_DAMAGE	:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(1, 7, "luc chien");
		public static const TOP_1vs1_AI	:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(2, 1, "hoa son luan kiem");
		public static const TOP_3VS3_MM	:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(3, 5, "tam hung ki hiep");
		public static const TOP_1VS1_MM	:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(4, 3, "vo lam minh chu");
		public static const HEROIC_TOWER:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(5, 6, "thap cao thu");
		public static const GUILD		:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(6, 4, "bang hoi");
		public static const DICE		:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(7, 8, "Xi ngau");
		public static const TOP_2VS2_MM		:LeaderBoardTypeEnum = new LeaderBoardTypeEnum(8, 9, "2v2");

		public var type:int;
		
		public function LeaderBoardTypeEnum(ID:int, topType:int, name:String = ""){
			super(ID, name);
			type = topType;
		}
	}
}