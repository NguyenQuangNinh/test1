package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseDicePlayerInfo extends ResponsePacket
	{
		public var errorCode:int;
		public var accWinPoint:int; // Diem tich luy lien thang hien tai
		public var currBetCount:int; // So lan choi hien tai
		public var currCorrectCount:int; // So lan sua sai hien tai
		public var timeLeft:int; // So giay con dien ra su kien
		public var showCorrectPanel:Boolean; // Lan truoc choi bi thua
		public var diceValues:Array = [0,0,0];

		public function ResponseDicePlayerInfo()
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				accWinPoint = data.readInt();
				currBetCount = data.readInt();
				currCorrectCount = data.readInt();
				showCorrectPanel = data.readBoolean();
				timeLeft = data.readInt();
				diceValues[0] = data.readInt();

				if(diceValues[0] != 0)
				{ // Lan truoc dang choi nhung thoat ra nua chung
					diceValues[1] = data.readInt();
					diceValues[2] = data.readInt();
				}
			}
		}
	}

}