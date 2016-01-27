package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestChangeHeroicRoomFormation extends RequestPacket 
	{
		private var formationIndex:Array = [];
		
		public function RequestChangeHeroicRoomFormation(arr:Array) {
			super(LobbyRequestType.HEROIC_CHANGE_ROOM_FORMATION);
			formationIndex = arr;
		}
		
		override public function encode():ByteArray {
			var byteArray:ByteArray = super.encode();
			for each (var index:int in formationIndex) {
				byteArray.writeInt(index);
			}
			
			return byteArray;
		}
	}

}