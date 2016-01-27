package game.net.lobby.response 
{

	import flash.globalization.DateTimeFormatter;
	import flash.utils.ByteArray;

	import game.Game;

	import game.data.xml.DataType;

	import game.data.xml.RewardXML;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseDiceLog extends ResponsePacket
	{
		public var errorCode:int;
		public var logString:String = "";

		public function ResponseDiceLog()
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				var len:int = data.readInt();

				var time:int = 0;
				var rewardID:int = 0;
				var rewardXML:RewardXML;
				var date:Date;

				var formater:DateTimeFormatter = new DateTimeFormatter("en-US");
				formater.setDateTimePattern("dd-MM-yyyy HH:mm");

				for (var i:int = 0; i < len; i++)
				{
					time = data.readInt();
					rewardID = data.readInt();
					rewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardID) as RewardXML;
					date = new Date(time);
					logString += formater.format(date) + " đã nhận được " + rewardXML.getItemInfo().getName() + " x" + rewardXML.quantity + "\n";
				}
			}
		}
	}

}