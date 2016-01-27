package game.net.lobby.request 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.enum.LogType;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestLogTutorial extends RequestPacket 
	{
		public var stepID		:int;
		public var stepName		:String;
		public var playingTime	:int;
		public var result		:int;
		public var description	:String;
		
		public function RequestLogTutorial( stepID:int, stepName:String,
											playingTime:int, result:int,
											description:String) {
			super(LobbyRequestType.LOG_TUTORIAL);
			this.stepID = stepID;
			this.stepName = stepName;
			this.playingTime = playingTime;
			this.result = result;
			this.description = description;
		}
		
		override public function encode():ByteArray {
			var byteArr:ByteArrayEx = super.encode() as ByteArrayEx;
			byteArr.writeInt(LogType.LOG_TUTORIAL.ID);
			byteArr.writeString("Tutorial", 32);
			byteArr.writeInt(stepID);
			byteArr.writeString(stepName, 32);
			byteArr.writeInt(playingTime);
			byteArr.writeInt(result);
			byteArr.writeString(description, 32);
			
			return byteArr;
		}
		
	}

}