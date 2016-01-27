package game.net.lobby.request
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	
	
	
	/**
	 * ...
	 * @author anhpnh2
	 */
	public class RequestPaymentMobilePacket extends RequestPacket
	{
		public var networkID:int;
		public var strSerial:String;
		public var strCode:String;
		
		public function RequestPaymentMobilePacket(type:int, networkID:int, strSerial:String, strCode:String)
		{
			super(type);
			this.networkID = networkID;
			this.strSerial = strSerial;
			this.strCode = strCode;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(networkID);
			data.writeString(strSerial, 20);
			data.writeString(strCode, 20);
			return data;
		}
	}

}