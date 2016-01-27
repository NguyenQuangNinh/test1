package game.data.model 
{
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ServerAddress 
	{
		public var ip:String = "";
		public var port:int = 0;
		
		public function ServerAddress(ip:String = "", port:int = 0) 
		{
			reset(ip, port);
		}
		
		public function reset(ip:String, port:int):void
		{
			this.ip = ip;
			this.port = port;
		}
		
		public function parse(string:String):void
		{
			if (string != null && string.length > 0)
			{
				var terms:Array = string.split(":");
				if(terms.length == 2) reset(terms[0], terms[1]);
			}
		}
		
		public function toString():String { return ip + ":" + port; }
	}
}