package game.data.xml
{
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ServerEventXML
	{
		public var nServerID:int = 0;
		public var nEnable:int = 0;
		public var strBegin:String = "";
		public var strEnd:String = "";
		public var strEndReceive:String = "";
		
		public function ServerEventXML()
		{
		
		}
		public function parseXML(xml:XML):void
		{
			nServerID = parseInt(xml.ServerID.toString());
			nEnable = parseInt(xml.Enable.toString());
			strBegin = xml.Begin.toString();
			strEnd = xml.End.toString();
			strEndReceive = xml.EndReceive.toString();
		}
	}

}