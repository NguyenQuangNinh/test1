package game.net.lobby.response 
{

	import flash.utils.ByteArray;

	import game.data.vo.mystic_box.ExchangeMysticBoxLogVO;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseExchangeMysticBoxResult extends ResponsePacket
	{
		public var errorCode : int;
		public var vo:ExchangeMysticBoxLogVO = new ExchangeMysticBoxLogVO();

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				vo.quantitySrc = data.readInt();
				vo.itemID = data.readInt();
				vo.quantityDes = data.readInt();
			}
		}
		
	}

}