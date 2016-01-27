package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	

	/**
	 * ...
	 * @author ...
	 */
	public class ResponseRequestATMPayment extends ResponsePacket 
	{
		public var nAddXu:int;
		public var nAddXuBonus:int;
		
		
		override public function decode(data:ByteArray):void 
		{
			nAddXu = data.readInt();
			nAddXuBonus = data.readInt();
			
		}
		
	}

}