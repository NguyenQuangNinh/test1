package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseDiceRollResult extends ResponsePacket
	{
		public var errorCode:int;
		public var currBetCount:int;
		public var accWinPoint:int; // Diem tich luy lien thang hien tai
		public var currCorrectCount:int; // So lan sua sai hien tai
		public var diceValues:Array = [];

		public function ResponseDiceRollResult()
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				currBetCount = data.readInt();
				accWinPoint = data.readInt();
				currCorrectCount = data.readInt();

				while(data.bytesAvailable > 0)
				{
					diceValues.push(data.readInt());
				}
			}
		}
	}

}