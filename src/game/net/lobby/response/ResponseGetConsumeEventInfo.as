package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	public class ResponseGetConsumeEventInfo extends ResponsePacket
	{
		public var eventID:int = 0;
		public var remainDay:int = 0;
		public var totalDay:int = 0;
		public var arrReward:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			eventID = data.readInt();
			if (eventID > 0)
			{
				remainDay = data.readInt();
				totalDay = data.readInt();
				for (var i:int = 0; i < totalDay; i++ )
				{
					var obj:Object = { };
					obj.status = data.readInt();
					obj.totalXuConsume = data.readInt();
					obj.totalGoldConsume = data.readInt();
					obj.totalXuPayback = data.readInt();
					obj.totalGoldPayback = data.readInt();
					
					arrReward.push(obj);
				}
				
			}
			
		}
	}
}