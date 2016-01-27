package game.main
{
	import core.display.BitmapEx;
	import flash.display.Shape;
	import flash.display.Sprite;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.Game;
	
	
	
	public class UnitAvatar extends Sprite
	{
		private var border:Shape;
		private var icon:BitmapEx;
		private var element:BitmapEx;
		private var data:CharacterXML;
		
		public function UnitAvatar()
		{
			border = new Shape();
			//border.graphics.lineStyle(1, 0);
			border.graphics.beginFill(0xffffff);
			border.graphics.drawRect(0, 0, 140, 140);
			addChild(border);
			
			icon = new BitmapEx();
			addChild(icon);
			
			element = new BitmapEx();
			addChild(element);
		}
		
		public function setData(unitData:CharacterXML):void
		{
			this.data = unitData;
			if(unitData != null)
			{
				icon.load(unitData.iconURL);
				var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, unitData.element) as ElementData;
				if(elementData != null)
				{
					element.load(elementData.formationSlotImgURL);
				}
			}
			else icon.load("resource/image/remove.jpg");
		}
		
		public function getData():CharacterXML { return data; }
	}
}