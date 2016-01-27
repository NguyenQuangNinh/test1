package game.net.lobby.response 
{
	import core.Manager;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.Game;
	import game.data.vo.change_recipe.ExchangeInvitationVO;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseExchangeInvitation extends ResponsePacket
	{
		public var errorCode : int;
		public var items:Array = [];
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				while(data.bytesAvailable)
				{
					var info:ExchangeInvitationVO = new ExchangeInvitationVO();
					info.itemID = data.readInt();
					info.quantity = data.readInt();
					items.push(info);
				}
			}
		}
		
	}

}