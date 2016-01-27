package game.net.lobby.response 
{
	import core.Manager;
	import core.util.ByteArrayEx;
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
	public class ResponsePorterList extends ResponsePacket
	{
		public var porters : Array = [];
		
		override public function decode(data:ByteArray):void 
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var p:PorterVO = new PorterVO();
				p.playerID = data.readInt();
				p.name = ByteArrayEx(data).readString();
				p.porterType = Enum.getEnum(PorterType, data.readInt()) as PorterType;
				p.element = data.readInt();
				porters.push(p);
			}
		}
		
	}

}