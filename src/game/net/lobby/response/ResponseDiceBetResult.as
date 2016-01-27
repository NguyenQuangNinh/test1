package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseDiceBetResult extends ResponsePacket
	{
		public var errorCode:int;
		public var isWin:Boolean;
		public var showCorrectPanel:Boolean;
		public var accWinPoint:int; // Diem tich luy lien thang hien tai
		public var currBetCount:int; // So lan choi hien tai
		public var currCorrectCount:int; // So lan sua sai hien tai
		public var diceValues:Array = [];

		public function ResponseDiceBetResult()
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				isWin = data.readBoolean();
				showCorrectPanel = data.readBoolean();
				accWinPoint = data.readInt();
				currBetCount = data.readInt();
				currCorrectCount = data.readInt();

				while(data.bytesAvailable > 0)
				{
					diceValues.push(data.readInt());
				}
			}
		}
	}

}