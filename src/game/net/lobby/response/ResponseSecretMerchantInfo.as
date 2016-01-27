package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseSecretMerchantInfo extends ResponsePacket 
	{
		public var shopIDs		:Array = [];
		public var quantities	:Array = [];
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			var length:int = data.readInt();
			for (var i:int = 0; i < length; i++) {
				shopIDs.push(data.readInt());
				quantities.push(data.readInt());
			}
		}
	}

}