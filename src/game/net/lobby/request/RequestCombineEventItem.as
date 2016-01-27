package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author ...
	 */
	public class RequestCombineEventItem extends RequestPacket
	{
		public var eventID	: int;
		public var quantity: int;
		
		public function RequestCombineEventItem(type:int, eventID:int, quantity:int)
		{
			super(type);
			this.eventID = eventID;
			this.quantity = quantity;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(eventID);
			data.writeInt(quantity);
			return data;
		}
		
	}

}