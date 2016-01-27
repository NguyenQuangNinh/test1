package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseGlobalBossListPlayers extends ResponsePacket 
	{
		public var players:Array = [];
		
		override public function decode(data:ByteArray):void {
			var size:int = data.readInt();
			var obj:Object;
			for (var i:int = 0; i < size; i++) {
				obj = { };
				obj.ID = data.readInt();
				obj.xmlID = data.readInt();
				obj.sex = int(data.readBoolean());
				obj.name = ByteArrayEx(data).readString();
				
				players.push(obj);
			}
		}
	}

}