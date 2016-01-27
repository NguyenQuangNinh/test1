package game.net
{
	import components.ObjectUtils;
	import core.util.Enum;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import game.net.game.GameRequestType;
	import game.net.game.GameResponseType;
	import game.net.lobby.LobbyRequestType;
	import game.net.PacketHeader;
	import game.net.RequestPacket;
	
	

	public class ExGameServer extends ExServer
	{
		public function ExGameServer():void
		{
			serverName = "ExGame";
			responseTypeClass = GameResponseType;
		}
		
		override protected function readHeader(ba:ByteArray):PacketHeader 
		{
			var packetHeader:PacketHeader = null;
			
			if (ba.bytesAvailable >= 4) 
			{
				packetHeader = new PacketHeader();
				packetHeader.length = ba.readUnsignedShort();
				packetHeader.type = ba.readUnsignedShort();
			}

			return packetHeader;
		}
	
	}
}