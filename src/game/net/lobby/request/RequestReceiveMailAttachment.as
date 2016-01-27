package game.net.lobby.request
{
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class RequestReceiveMailAttachment extends RequestPacket
	{
		public var _nMailType:int;
		public var _nMailIndex:int;
			
		public function RequestReceiveMailAttachment(type:int, mailindex:int, mailtype:int)
		{
			super(type);
			this._nMailIndex = mailindex;
			this._nMailType = mailtype;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			data.writeInt(_nMailIndex);
			data.writeInt(_nMailType);
			return data;
		}
	}

}