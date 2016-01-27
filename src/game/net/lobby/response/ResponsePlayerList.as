package game.net.lobby.response
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.data.Player;
	import game.net.ResponsePacket;

	public class ResponsePlayerList extends ResponsePacket
	{
		public var players:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			var size:int = data.readInt();
			for(var i:int = 0; i < size; ++i)
			{
				var ID:int = data.readInt();
				/*var nameLength:int = data.readInt();
				var name:String = data.readUTFBytes(length);*/
				var name:String = ByteArrayEx(data).readString();
				players.push(new Player(ID, name));
			}
		}
	}
}