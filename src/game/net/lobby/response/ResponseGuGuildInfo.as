package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuGuildInfo extends ResponsePacket
	{
		public var nRank	:int;
		public var nGuildID	:int;
		public var strName:String;
		public var strAnnounce:String;
		public var nNumMember	:int;
		public var nLevel	:int;
		public var nTotalDedicationPoint	:int;
		public var nPresidenID	:int;
		public var strPresidenName	:String;

		override public function decode(data:ByteArray):void 
		{
			nRank = data.readInt();
			nGuildID = data.readInt();
			strName = ByteArrayEx(data).readString();
			strAnnounce = ByteArrayEx(data).readString();
			nNumMember = data.readInt();
			nLevel = data.readInt();
			nTotalDedicationPoint = data.readInt();
			nPresidenID = data.readInt();
			strPresidenName = ByteArrayEx(data).readString();
		}
		
	}

}