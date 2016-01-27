package game.data.gamemode 
{
	import core.util.Utility;
	import game.enum.TeamID;
	import game.ui.ModuleID;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class ModeData 
	{
		private var _teamID:int;
		public var result:Boolean;
		private var _backModuleID	:ModuleID;
		public var roomID:int;
		public var roomName:String = "";
		public var fixReward : Array = [];
		public var randomReward : Array = [];
		
		private var teams:Array = [];
		
		public function ModeData() 
		{
			for each(var teamID:int in TeamID.ALL)
			{
				teams[teamID] = new Team();
			}
		}
		
		public function set teamID(tId:int):void
		{
			this._teamID = tId;
		}
		
		public function get teamID():int
		{
			return this._teamID;
		}
		
		public function getTeam(teamID:int):Team
		{
			return teams[teamID];
		}
		
		public function setResult(result:Boolean):void
		{
			this.result = result;
		}
		
		public function init():void
		{
			
		}
		
		public function get backModuleID():ModuleID {
			return _backModuleID;
		}
		
		public function set backModuleID(module:ModuleID):void { 
			_backModuleID = module;
			if (!module)
				Utility.log("here value is null");
		}
	}

}