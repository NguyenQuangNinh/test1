package game.net.lobby
{
	import core.util.Enum;
	import core.util.Utility;
	import flash.utils.Dictionary;
	import game.net.RequestPacket;
	
	import game.enum.PlayerAttributeID;
	import game.enum.ServerResponseType;
	import game.net.IntRequestPacket;
	import game.net.PacketHeader;
	import game.net.Server;
	
	

	public class LobbyServer extends Server
	{
		public function LobbyServer():void
		{
			serverName = "Lobby";
			responseTypeClass = LobbyResponseType;
		}
		
		override protected function readHeader():PacketHeader 
		{
			var packetHeader:PacketHeader = null;
			if (socket.bytesAvailable >= 14)
			{
				packetHeader = new PacketHeader();
				packetHeader.length = socket.readUnsignedInt();
				//Utility.log("read header length " + packetHeader.length);
				var crc:int = socket.readInt();
				//Utility.log("read header crc " + crc);
				var sequence:int = socket.readUnsignedInt();
				//Utility.log("read header sequence " + sequence);
				packetHeader.type = socket.readUnsignedShort();
				//Utility.log("read header type " + packetHeader.type);
			}
			return packetHeader;
		}
		
		public function getPlayerAttribute(attributeID:PlayerAttributeID):void
		{
			if(attributeID != null) sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, attributeID.ID));
		}
		
		override public function sendPacket(packet:RequestPacket):void
		{
			if (DebuggerUtil.getInstance().isNetTraced) Utility.log("Lobby send packet >>>>>>>>>>> 	" + Enum.getString(LobbyRequestType, packet.getType()) + "  " + packet.getType());
			super.sendPacket(packet);
		}
		
		override protected function readPacket():void
		{
			super.readPacket();
		}
	}
}