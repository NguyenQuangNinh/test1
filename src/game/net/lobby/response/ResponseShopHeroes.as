package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseShopHeroes extends ResponsePacket 
	{
		public var shopItemIDs	:Array = [];
		public var shopCurrItemIDs	:Array = [];
		public var statuses		:Array = [];
		public var expiredTime /*Array seconds*/	:Array = [];
		public var missionIDs	:Array = [];
		
		override public function decode(data:ByteArray):void {
			var shopItemID	:int = -1;
			var shopCurrItemID	:int = -1;
			var status		:int = -1;
			var itemExpiredTime	:int = -1;
			var missionID	:int = -1;
			while (data.bytesAvailable) {
				shopItemID = data.readInt();
				shopCurrItemID = data.readInt();
				status = data.readByte();
				itemExpiredTime = data.readInt();
				missionID = data.readInt();
				
				shopItemIDs.push(shopItemID);
				shopCurrItemIDs.push(shopCurrItemID);
				statuses.push(status);
				expiredTime.push(itemExpiredTime);
				missionIDs.push(missionID);
			}
		}
		
	}

}