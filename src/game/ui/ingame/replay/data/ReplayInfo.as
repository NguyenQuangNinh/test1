package game.ui.ingame.replay.data {
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ReplayInfo 
	{
		public var responseType:uint;
		public var delay:uint; // milisecond
		public var packet:ResponsePacket;
		
		public function ReplayInfo(delay:uint = 0, responseType:uint = 0, packet:ResponsePacket = null) 
		{
			this.responseType = responseType;
			this.packet = packet;
			this.delay = delay;
		}
		
	}

}