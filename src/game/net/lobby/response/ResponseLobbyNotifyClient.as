package game.net.lobby.response 
{
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseLobbyNotifyClient extends ResponsePacket
	{
		public var notifyType : int;
		public var byteData:ByteArray = new ByteArray();
		
		public function ResponseLobbyNotifyClient()
		{
			
			byteData.endian = Endian.LITTLE_ENDIAN;
		}
		
		override public function decode(data:ByteArray):void 
		{
			notifyType = data.readInt();
			data.readBytes(byteData, 0, data.bytesAvailable);			
			
			/*//clone here			
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(data); 
			myBA.position = 0; 
			
			byteData = myBA.readObject();*/
		}
		
	}

}