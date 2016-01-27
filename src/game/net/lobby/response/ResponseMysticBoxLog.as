package game.net.lobby.response 
{
	import core.Manager;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.Game;
	import game.data.vo.mystic_box.ExchangeMysticBoxLogVO;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseMysticBoxLog extends ResponsePacket
	{
		public var logs:Array = [];

		override public function decode(data:ByteArray):void 
		{
			while(data.bytesAvailable)
			{
				var item:ExchangeMysticBoxLogVO = new ExchangeMysticBoxLogVO();
				item.quantitySrc = data.readInt();
				item.itemID = data.readInt();
				item.quantityDes = data.readInt();
				logs.push(item);
			}
		}
		
	}

}