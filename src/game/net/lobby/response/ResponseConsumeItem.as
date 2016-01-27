package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.enum.ErrorCode;
	import game.net.ResponsePacket;
	
	public class ResponseConsumeItem extends ResponsePacket
	{
		public var errorCode:int;
		public var quantity:int; // Su dung nhieu item: so luong user muon mo
		public var useSuccessQuantity:int; // Su dung nhieu item: so luong thuc te co the mo duoc.
		public var indexes:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			errorCode = data.readInt();
			quantity = data.readInt();
			useSuccessQuantity = data.readInt();

			if(errorCode == ErrorCode.SUCCESS || useSuccessQuantity > 0)
			{
				var size:int = data.readInt();
				if(size > 0) indexes.push(data.readInt());
			}
		}
	}
}