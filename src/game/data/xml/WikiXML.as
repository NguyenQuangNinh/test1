package game.data.xml
{
	import game.data.model.WikiSubTab;

	public class WikiXML extends XMLData
	{
		public var name:String;
		public var subTabs:Array = [];
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			name = xml.Name.toString();

			var sTab:WikiSubTab;
			for each (var record:XML in xml.Subtabs.STab)
			{
				sTab = new WikiSubTab();
				sTab.parse(record);
				subTabs.push(sTab);
			}
		}
	}
}