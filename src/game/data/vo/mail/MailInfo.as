package game.data.vo.mail
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MailInfo
	{
		public var _nMailIndex:int;
		public var _nMailID:int;
		public var _nMailType:int;
		public var _strTitle:String;
		public var _strSendTime:String;
		public var _strExpireTime:String;
		public var _strMsg:String;
		public var _nState:int;
		public var _arrAttachment:Array;
		
		public function MailInfo()
		{
			_arrAttachment = [];
		}
		
		public function decode(data:ByteArray):void
		{
			if (data.bytesAvailable > 0)
			{
				_arrAttachment = [];
				
				_nMailIndex = data.readInt();
				_nMailID = data.readInt();
				_nMailType = data.readInt();
				_strTitle 		= ByteArrayEx(data).readString();
				_strMsg 		= ByteArrayEx(data).readString();
				_nState 		= data.readInt();
				_strSendTime 	= ByteArrayEx(data).readString();
				_strExpireTime 	= ByteArrayEx(data).readString();
				
				var nAttachmentSize:int = data.readInt();
				for (var j:int = 0; j < nAttachmentSize; j++)
				{
					var obj:Object = { };
					obj.id = data.readInt();
					obj.type = data.readInt();
					obj.quantity = data.readInt();
					_arrAttachment.push(obj);
				}
			}
		}
	}
}