package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseGlobalBossTopDmg extends ResponsePacket 
	{
		public var players		:Array;
		public var currentRank:int;
		public var currentDmg:int;
		override public function decode(data:ByteArray):void 
		{
			currentRank = data.readInt();
			currentDmg = data.readInt();
			var size:int = data.readInt();
			var obj:Object;
			players = [];
			
			for (var i:int = 0; i < size; i++) 
			{
				obj = { };
				obj.playerID 	= data.readInt();
				obj.currentDmg	= data.readInt();
				obj.name		= ByteArrayEx(data).readString();
				
				players.push(obj);
			}
		}
	}

}