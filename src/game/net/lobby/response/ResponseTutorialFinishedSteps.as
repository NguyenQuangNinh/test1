package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseTutorialFinishedSteps extends ResponsePacket 
	{
		public var finishedScenes	:Array = [];
		
		override public function decode(data:ByteArray):void {
			var length:int = data.readInt();
			for (var i:int = 0; i < length; i++) {
				finishedScenes.push(data.readInt());
			}
		}
	}

}