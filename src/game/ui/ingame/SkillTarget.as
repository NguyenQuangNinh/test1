package game.ui.ingame 
{
	import flash.display.Sprite;
	
	import core.display.BitmapEx;
	
	import game.data.xml.SkillXML;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class SkillTarget extends Sprite 
	{
		public var objectID:int;
		
		private var xmlData:SkillXML;
		private var castingAOE:BitmapEx;
		
		public function SkillTarget() 
		{
			castingAOE = new BitmapEx();
			castingAOE.load("resource/image/targetzone.png");
			addChild(castingAOE);
		}
		
		public function setXMLData(xmlData:SkillXML):void
		{
			this.xmlData = xmlData;
			if (xmlData != null)
			{
				castingAOE.scaleX = xmlData.radius/200;
			}
		}
		
		public function getXMLData():SkillXML { return xmlData; }
		public function getHalfHeight():Number { return castingAOE.height / 2; }
	}
}