package game.net.lobby.response
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ResponseGetRewardRequireLevelInfo extends ResponsePacket
	{
		public var currentLevel:int;
		public var arrRewardLevelID:Array;
		
		public function ResponseGetRewardRequireLevelInfo()
		{
			arrRewardLevelID = [];
		}
		
		override public function decode(data:ByteArray):void
		{
			if (data)
			{
				currentLevel = data.readInt();
				var nSize:int = data.readInt();
				for (var i:int = 0; i < nSize; i++)
				{
					var nLevelID:int = data.readInt();
					if (nLevelID > 0)
						arrRewardLevelID.push(nLevelID);
					else
						Utility.log("ERROR: ResponseGetRewardRequireLevelInfo nLevelID = " + nLevelID);
				}
			}
		}
	}

}