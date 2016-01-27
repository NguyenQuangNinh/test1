package game.data.xml 
{
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class MessageXML extends XMLData 
	{
		public var content	:String;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			content = xml.Content.toString();
		}
	}

}