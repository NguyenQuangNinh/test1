package game.net.lobby.response
{
	import core.util.ByteArrayUtil;
	import flash.utils.ByteArray;
	import game.data.model.Character;
	import game.data.vo.lobby.InviteFriendInfo;
	import game.net.ResponsePacket;

	public class ResponseGetListPlayerFree extends ResponsePacket
	{
		public var players:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			while (data && data.bytesAvailable > 0) {				
				var player:InviteFriendInfo = new InviteFriendInfo();
				player.name = ByteArrayUtil.readString(data);
				player.level = data.readInt();
				var numCharacters:int = data.readInt();
				for (var i:int = 0; i < numCharacters; ++i)
				{					
					player.characters.push(data.readInt());
				}
				players.push(player);
			}
		}
	}
}