package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;

	import flash.utils.ByteArray;

	import game.data.xml.event.EventType;

	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class ResponseChangeSkillResult extends ResponsePacket
	{
		public var errorCode:int;
		public var newSkillID:int;

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();

			if(errorCode == 0)
			{
				newSkillID = data.readInt();
			}
		}
	}

}