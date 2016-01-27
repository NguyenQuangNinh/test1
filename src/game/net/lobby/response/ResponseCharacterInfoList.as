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
	public class ResponseCharacterInfoList extends ResponsePacket 
	{
		public var characters:Array;
		
		override public function decode(data:ByteArray):void 
		{
			characters = Manager.pool.pop(Array) as Array; // sorting in-formation characters first
			characters.splice(0);
			var notInFormation:Array = Manager.pool.pop(Array) as Array;
			notInFormation.splice(0);
			var size:int = data.readInt();
			for (var i:int = 0; i < size; ++i)
			{
				var character:Character = Manager.pool.pop(Character) as Character;
				character.decode(data);
				if (character.isInMainFormation) {
					characters.push(character);
				} else {
					notInFormation.push(character);
				}
			}
			for each(character in notInFormation)
			{
				characters.push(character);
			}
			Manager.pool.push(notInFormation, Array);
		}
	}
}