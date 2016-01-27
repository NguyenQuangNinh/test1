package game.net.lobby.response 
{
	import core.util.Enum;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.Game;
	import game.data.vo.item.ItemInfo;
	import game.enum.GameMode;
	import game.enum.ItemType;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseEndGameRewardResult extends ResponsePacket
	{
		public var mode:GameMode;
		public var result:Boolean;
		public var numStars : int;
		public var fixReward : Array = [];
		public var randomReward : Array = [];
		
		//for pvp mode
		public var eloScore:int;
		public var honorScore:int;
		//for pvp AI
		public var oldRank:int;
		public var newRank:int;
		
		public function ResponseEndGameRewardResult() 
		{
			
		}
		
		override public function decode(data : ByteArray) : void
		{
			fixReward = [];
			randomReward = [];
			
			var modeID:int = data.readInt();
			mode = Enum.getEnum(GameMode, modeID) as GameMode;
			result = data.readBoolean();
			Utility.log("EndGameReward, mode=" + modeID + " result=" + result);
			switch(mode) {
				case GameMode.PVE_WORLD_CAMPAIGN:
				case GameMode.PVE_SHOP_WARRIOR:
					numStars = data.readInt();
				case GameMode.PVE_RESOURCE_WAR_NPC:
					parseFixReward(data);
					parseRandomReward(data);									
					break;
				case GameMode.PVE_GLOBAL_BOSS:
					parseFixReward(data);
					Game.database.userdata.globalBossData.timeUp = data.readBoolean();
					break;
				case GameMode.HEROIC_TOWER:
				case GameMode.PVP_1vs1_AI:
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_3vs3_FREE:
				case GameMode.PVP_RESOURCE_WAR_PVP:					
					parseFixReward(data);
					parseRandomReward(data);
					break;
				case GameMode.PVP_1vs1_MM:
				case GameMode.PVP_3vs3_MM:
				case GameMode.PVP_2vs2_MM:
					eloScore = data.readInt();
					honorScore =  data.readInt();	
					parseFixReward(data);
					parseRandomReward(data);
					break;
				case GameMode.PVE_EXPRESS_WAR_PVP:
//					parseFixReward(data);
					break;
			}
		}	
		
		private function parseFixReward(data:ByteArray):void {
			var itemData : ItemInfo;
			var numFixReward : int = data.readInt();
			for (var i:int = 0; i < numFixReward; i++)
			{
				
				itemData = new ItemInfo();
				itemData.type = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				itemData.id = data.readInt();
				itemData.quantity = data.readInt();
				
				fixReward.push(itemData);
			}
		}
		
		private function parseRandomReward(data:ByteArray):void {
			var itemData : ItemInfo;
			var numRandomReward : int = data.readInt();
			for (var j:int = 0; j < numRandomReward; j++) 
			{
				itemData = new ItemInfo();
				itemData.type = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				itemData.id = data.readInt();
				itemData.quantity = data.readInt();
				
				randomReward.push(itemData);
			}
		}
	}	
}