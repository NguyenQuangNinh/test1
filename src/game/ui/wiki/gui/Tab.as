/**
 * Created by NinhNQ on 9/22/2014.
 */
package game.ui.wiki.gui
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import game.data.model.WikiSubTab;

	import game.data.model.event.EventData;
	import game.data.xml.WikiXML;
	import game.enum.Font;

	public class Tab extends MovieClip
	{
		public static const HEIGHT:int = 59;

		public function Tab()
		{
			this.buttonMode = true;
			this.mouseEnabled = true;
			this.mouseChildren = false;
			setActive(false);

			FontUtil.setFont(this.nameTf, Font.ARIAL, true);
		}

		public var content:MovieClip;
		private var subTabs:Array = [];

		public function setData(data:WikiXML):void
		{
			text = data.name;
			var subTab:SubTab;

			for (var i:int = 0; i < data.subTabs.length; i++)
			{
				var subData:WikiSubTab = data.subTabs[i];

				subTab = new SubTab();
				subTab.text = subData.name;
				subTab.data = subData;
				subTabs.push(subTab);
			}
		}

		public function getSubtabs():Array { return subTabs;}

		public function set text(value:String):void { content.nameTf.text = value.toUpperCase(); }

		private function get nameTf():TextField { return content.nameTf as TextField; }

		public function setActive(value:Boolean = true):void
		{
			var label:String = (value) ? "active" : "passive";
			gotoAndStop(label);
		}
	}
}
