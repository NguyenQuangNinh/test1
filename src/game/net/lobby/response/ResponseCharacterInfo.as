package game.net.lobby.response 
{
	import core.Manager;
	
	import flash.utils.ByteArray;
	
	import game.data.model.Character;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseCharacterInfo extends ResponsePacket 
	{
		public var character:Character;
		
		override public function decode(data:ByteArray):void 
		{
			character = Manager.pool.pop(Character) as Character;
			character.decode(data);
		}
	}
}