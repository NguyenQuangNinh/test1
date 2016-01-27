package game.ui.player_profile
{
	import core.display.BitmapEx;
	
	import flash.display.MovieClip;
	
	import game.Game;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	
	public class CharacterThumbnail extends MovieClip
	{
		public var thumbnailContainer:MovieClip;
		public var highlight:MovieClip;
		
		private var thumbnail:BitmapEx;
		private var data:CharacterSimple;
		
		public function CharacterThumbnail()
		{
			thumbnail = new BitmapEx();
			thumbnailContainer.addChild(thumbnail);
			setSelected(false);
		}
		
		public function getData():CharacterSimple { return data; }
		public function setData(data:CharacterSimple):void
		{
			this.data = data;
			if(data != null)
			{
				var xmlData:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, data.xmlID) as CharacterXML;
				if(xmlData != null)
				{
					thumbnail.load(xmlData.smallAvatarURLs[data.sex]);
				}
			}
			else
			{
				thumbnail.reset();
			}
		}
		
		public function setSelected(value:Boolean):void
		{
			highlight.visible = value;
		}
	}
}