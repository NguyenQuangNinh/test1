package game.net.lobby.response
{
	import flash.utils.ByteArray;
	import game.data.vo.mail.MailInfo;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ResponseInboxMailRequest extends ResponsePacket
	{
		public var arrMailBox:Array;
		
		public function ResponseInboxMailRequest()
		{
			arrMailBox = [];
		}
		
		override public function decode(data:ByteArray):void
		{
			arrMailBox = [];
			while (data.bytesAvailable > 0)
			{
				var mail:MailInfo = new MailInfo();
				mail.decode(data);
				arrMailBox.push(mail);
			}
		}
	
	}

}