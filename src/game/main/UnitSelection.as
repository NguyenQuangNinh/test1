package game.main
{
	import core.event.EventEx;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.Game;
	
	public class UnitSelection extends Sprite
	{
		public static const SELECT:String = "select";
		
		private var units:Array = [];
		private var background:Shape;
		
		public function UnitSelection()
		{
			background = new Shape();
			addChild(background);
			var table:Dictionary = Game.database.gamedata.getTable(DataType.CHARACTER);
			for each(var unitData:CharacterXML in table)
			{
				var unitAvatar:UnitAvatar = new UnitAvatar();
				unitAvatar.addEventListener(MouseEvent.CLICK, unitAvatar_onClicked);
				unitAvatar.setData(unitData);
				unitAvatar.x = units.length*145;
				addChild(unitAvatar);
				units.push(unitAvatar);
			}
			unitAvatar = new UnitAvatar();
			unitAvatar.addEventListener(MouseEvent.CLICK, unitAvatar_onClicked);
			unitAvatar.setData(null);
			unitAvatar.x = units.length*145;
			addChild(unitAvatar);
			units.push(unitAvatar);
			
			background.graphics.beginFill(0);
			background.graphics.drawRect(0, 0, units.length*145 + 5, 150);
			background.x = -5;
			background.y = -5;
		}
		
		protected function unitAvatar_onClicked(event:MouseEvent):void
		{
			var unitAvatar:UnitAvatar = UnitAvatar(event.target);
			if(unitAvatar.getData() != null) dispatchEvent(new EventEx(SELECT, unitAvatar.getData().ID));
			else dispatchEvent(new EventEx(SELECT, 0));
		}
	}
}