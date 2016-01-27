package game.data.vo.lobby 
{
	import game.enum.GameMode;
	import game.enum.LobbyStatus;
	import game.ui.ModuleID;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LobbyInfo extends Object
	{
		public var name:String;
		public var id:int;
		public var mode:GameMode;
		public var status:int;
		public var privateLobby:Boolean; // if private == true (chi duoc vao phong khi duoc moi)
		public var count:int;
		
		public var strNameHostRoom:String;
		public var nLevelHostRoom:int;
		// ---------------------------------------------------
		
		//for pve
		public var missionID:int;		
		//for pve ai
		public var challengeID:int;		
		//for heroic tower
		public var towerID:int;		
		//for common
		public var backModule:ModuleID;
		
		//for heroic mode
		public var campaignID:int;
		public var difficultyLevel:int;
		
		//for tuu lau chien
		public var bOccupied:Boolean;
		
		public function LobbyInfo() 
		{
			reset();
		}
		
		public function reset(): void {
			name = "";
			id = -1;
			mode = null;
			privateLobby = false;	//temporary
			count = 0;
			status = LobbyStatus.WAITING_PLAYER;
			missionID = -1;
			challengeID = -1;
			towerID = -1;
			backModule = null;
			campaignID = -1;
			difficultyLevel = -1;
			bOccupied = false;
		}
		
		public function clone():LobbyInfo {
			var result:LobbyInfo = new LobbyInfo();
			result.name = this.name;
			result.id = this.id;
			result.mode = this.mode;
			result.privateLobby = this.privateLobby;
			result.count = this.count;
			result.status = this.status;
			result.missionID = this.missionID;
			result.challengeID = this.challengeID;
			result.towerID = this.towerID;
			result.backModule = this.backModule;
			result.campaignID = this.campaignID;
			result.difficultyLevel = this.difficultyLevel;
			result.bOccupied = this.bOccupied;
			
			return result;
		}
	}

}