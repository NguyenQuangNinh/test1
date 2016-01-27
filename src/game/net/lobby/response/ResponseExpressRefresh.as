package game.net.lobby.response 
{
	import core.Manager;
	import core.util.Enum;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.Game;
	import game.data.vo.express.PorterVO;
	import game.enum.PorterType;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseExpressRefresh extends ResponsePacket
	{
		public var porterType:PorterType;
		public var errorCode:int;
		public var numOfRefresh:int;

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				porterType = Enum.getEnum(PorterType, data.readInt()) as PorterType;
				numOfRefresh = data.readInt();
			}
		}
		
	}

}