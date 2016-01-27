package game.net.game
{
	import components.ObjectUtils;
	import core.util.Enum;
	import core.util.Utility;
	import game.net.lobby.LobbyRequestType;
	import game.net.PacketHeader;
	import game.net.RequestPacket;
	import game.net.Server;
	
	

	public class GameServer extends Server
	{
		public function GameServer():void
		{
			serverName = "InGame";
			responseTypeClass = GameResponseType;
		}
		
		override protected function readHeader():PacketHeader 
		{
			var packetHeader:PacketHeader = null;
			if (socket.bytesAvailable >= 4)
			{
				packetHeader = new PacketHeader();
				packetHeader.length = socket.readUnsignedShort();
				packetHeader.type = socket.readUnsignedShort();
			}
			return packetHeader;
		}
		
		override public function sendPacket(packet:RequestPacket):void
		{
			if (DebuggerUtil.getInstance().isNetTraced) Utility.log("InGame send packet >>>>>>>>>>> 	" + Enum.getString(GameRequestType, packet.getType()) + "  " + packet.getType());
			super.sendPacket(packet);
		}
	
	}
}