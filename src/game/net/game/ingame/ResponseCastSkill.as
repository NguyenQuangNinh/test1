package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseCastSkill extends IngamePacket
	{
		public var objectIDs:Array = [];
		public var skillXMLID:int;
		
		override public function decode(data:ByteArray):void
		{
			objectIDs.push(this.objectID);
			skillXMLID = data.readInt();
			var length:int = data.readInt();
			for(var i:int = 0; i < length; ++i)
			{
				objectIDs.push(data.readInt());
			}
		}
	}
}