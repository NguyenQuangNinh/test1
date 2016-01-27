package game.net.game.request 
{
	import flash.utils.ByteArray;
	import game.net.game.GameRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class RequestCastSkill extends RequestPacket 
	{
		public var objectID:int;
		public var skillID:int;
		public var target:int;
		
		public function RequestCastSkill() 
		{
			super(GameRequestType.CAST_SKILL);
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(objectID);
			data.writeInt(skillID);
			data.writeInt(target);
			return data;
		}
	}

}