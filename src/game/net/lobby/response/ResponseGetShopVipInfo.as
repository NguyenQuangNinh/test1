package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class ResponseGetShopVipInfo extends ResponsePacket 
	{
		
		public var nVipID:int;
		public var nSize:int;
		public var arrItemShop:Array = [];

		
		override public function decode(data:ByteArray):void 
		{
			nVipID = data.readInt();
			nSize = data.readInt();
			for (var i:int = 0; i < nSize; i++ )
			{
				var obj:Object = { };
				obj.itemShopID = data.readInt();
				obj.quantity = data.readInt();
				arrItemShop.push(obj);
			}
		}
	}

}