package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseGlobalBossMissionInfo extends ResponsePacket 
	{
		public var status		:int;
		public var buffPercent	:int;
		public var autoRevive	:Boolean;
		public var autoPlay		:Boolean;
		public var currentGoldBuff	:int;
		public var maxGoldBuff		:int;
		public var currentXuBuff	:int;
		public var maxXuBuff		:int;
		
		override public function decode(data:ByteArray):void {
			status = data.readInt();
			buffPercent = data.readInt();
			autoRevive = data.readBoolean();
			autoPlay = data.readBoolean();
			currentGoldBuff = data.readInt();
			maxGoldBuff = data.readInt();
			currentXuBuff = data.readInt();
			maxXuBuff = data.readInt();
		}
	}

}