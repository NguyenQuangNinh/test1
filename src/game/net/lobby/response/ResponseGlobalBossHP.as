package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseGlobalBossHP extends ResponsePacket 
	{
		public var currentHP		:int;
		public var maxHP			:int;
		
		override public function decode(data:ByteArray):void {
			currentHP = data.readInt();
			maxHP = data.readInt();
		}
	}

}