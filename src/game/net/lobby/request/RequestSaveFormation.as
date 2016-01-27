package game.net.lobby.request
{
	import flash.utils.ByteArray;
	
	import game.data.model.Character;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	
	public class RequestSaveFormation extends RequestPacket
	{
		public var formationType:int;
		public var characterIDs:Array = [];
		
		public function RequestSaveFormation(type:int, data:Array)
		{
			super(LobbyRequestType.SAVE_FORMATION);
			formationType = type;
			//characterIDs = data;
			for (var i:int = 0; i < data.length; ++i)
			{
				if(data[i] is Character) characterIDs[i] = Character(data[i]).ID;
				else if(data[i] is int) characterIDs[i] = int(data[i]);
				else characterIDs[i] = -1;
			}
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			data.writeInt(formationType);		
			for(var i:int = 0; i < characterIDs.length; ++i)
			{
				data.writeInt(characterIDs[i]);
			}
			return data;
		}
	}
}