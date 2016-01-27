package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseHeroicFinishMissions extends ResponsePacket 
	{
		public var finishMissions:Array;
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			finishMissions = [];
			var length:int = data.readInt();
			for (var i:int = 0; i < length; i++) {
				var missionID:int = data.readInt();
				finishMissions.push(missionID);
			}
		}
	}

}