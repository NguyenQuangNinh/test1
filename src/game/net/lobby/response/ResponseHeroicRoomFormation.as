package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseHeroicRoomFormation extends ResponsePacket 
	{
		private static const MAX_FORMATION_SLOTS:int = 6;
		public var formationIndex:Array;
		public var formationTypeID:int;
		public var formationTypeLevel:int;
		public var autoStart:Boolean;

		override public function decode(data:ByteArray):void {
			super.decode(data);
			var index:int;
			formationIndex = [];
			for (var i:int = 0; i < MAX_FORMATION_SLOTS; i++) {
				index = data.readInt();
				formationIndex.push(index);
			}
			
			formationTypeID = data.readInt();
			formationTypeLevel = data.readInt();
			autoStart = data.readBoolean();
		}
	}

}