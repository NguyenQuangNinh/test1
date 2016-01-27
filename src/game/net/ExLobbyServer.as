package game.net
{
	import core.util.Enum;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.RequestPacket;
	
	import game.enum.PlayerAttributeID;
	import game.enum.ServerResponseType;
	import game.net.IntRequestPacket;
	import game.net.PacketHeader;
	import game.net.Server;
	
	

	public class ExLobbyServer extends ExServer
	{
		public function ExLobbyServer():void
		{
			serverName = "ExLobby";
			responseTypeClass = LobbyResponseType;
		}
		
		override protected function readHeader(ba:ByteArray):PacketHeader 
		{
			var crc:int;
			var sequence:int;
			super.readHeader(ba);
			var packetHeader:PacketHeader = null;
	
			packetHeader = new PacketHeader();
			packetHeader.length = ba.readUnsignedInt();
			crc = ba.readInt();
			sequence = ba.readUnsignedInt();
			packetHeader.type = ba.readUnsignedShort();
		
			return packetHeader;
		}
		
	}
}