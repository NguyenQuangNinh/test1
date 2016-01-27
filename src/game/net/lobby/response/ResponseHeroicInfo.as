package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseHeroicInfo extends ResponsePacket 
	{
		public var infos:Array;
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			var length:int = data.readInt();
			var obj:Object;
			infos = [];
			
			for (var i:int = 0; i < length; i++) {
				obj = { };
				obj.campaignID = data.readInt();
				obj.freePlayingTimes = data.readInt();
				obj.premiumPlayingTimes = data.readInt();
				obj.premiumBought = data.readInt();
				infos.push(obj);
			}
		}
	}

}