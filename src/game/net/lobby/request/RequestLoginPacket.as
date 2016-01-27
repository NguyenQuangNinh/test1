package game.net.lobby.request
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestLoginPacket extends RequestPacket
	{
		public var userName:String;
		public var roleName:String;
		public var classID:int;
		public var sex:int;
		public var strPID:String;
		public var strTime:String;
		public var strSessionKey:String;
		public var strChannel:String;
		public var nServerID:int;
		
		public function RequestLoginPacket(_userName:String, _roleName:String, _classID:int, _sex:int, _strPID:String, _strTime:String, _strSessionKey:String, _nServerID:int, _strChannel:String)
		{
			super(LobbyRequestType.LOGIN);
			
			userName 	= _userName;
			roleName 	= _roleName;
			classID 	= _classID;
			sex 		= _sex;
			strPID 		= _strPID;
			strTime 	= _strTime;
			strSessionKey = _strSessionKey;
			strChannel 	= _strChannel;
			nServerID 	= _nServerID;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeString(userName, 32);
			
			data.writeString(roleName, 32);
			
			data.writeByte(classID);
			
			data.writeByte(sex);
			
			data.writeString(strPID, 8);
			data.writeString(strTime, 16);
			data.writeString(strSessionKey, 128);
			data.writeString(strChannel, 5);
			
			data.writeInt(nServerID);
			
			return data;
		}
	}

}