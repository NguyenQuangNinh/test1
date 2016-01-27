package game.data.vo.challenge 
{
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class HistoryInfo 
	{
		public var index:int;
		public var activeAttack:Boolean;
		public var isWin:Boolean;
		public var playerID:int;
		public var name:String;
		public var rank:int;
		public var time:String;
		public var nTimeCreate:uint;
		public var numResourceRob:int;
		//public var rankStatus:int;
		public var type:int;	//type for tuu lau chien --> 1: chiem // 2: by NPC // 3: cuop 
		
		
		public function HistoryInfo() 
		{
			
		}
		
		public function getRankStatus():int {
			var result:int;
			
			if (rank > -1) {
				result = activeAttack && isWin ? 1:
						activeAttack && !isWin ? 0:
						!activeAttack && isWin ? 0:
						!activeAttack && !isWin ? -1 : -2;	
			}			
			
			return result;			
		}
		
	}

}