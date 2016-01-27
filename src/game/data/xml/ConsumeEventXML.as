package game.data.xml
{
	
	/**
	 * ...
	 * @author chuongth2
	 */
	
	public class ConsumeEventXML extends XMLData
	{
		public var nPaybackPercent:int = 0;
		public var arrServerEvent:Array = [];
		
		public function ConsumeEventXML()
		{
		
		}
		
		override public function parseXML(xml:XML):void
		{
			//super.parseXML(xml);
			ID = parseInt(xml.EventID.toString());
			nPaybackPercent = parseInt(xml.PaybackPercent.toString());
			
			var serverXMLList:XMLList = xml.Servers.Server;
			if (serverXMLList)
			{
				for each (var serverXML:XML in serverXMLList)
				{
					var serverEventXML:ServerEventXML = new ServerEventXML();
					serverEventXML.parseXML(serverXML);
					arrServerEvent.push(serverEventXML);
				}
			}
		}
	
	}

}