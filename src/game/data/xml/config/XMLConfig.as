package game.data.xml.config
{
	public class XMLConfig
	{
		public static const CHALLENGE_CENTER:int = 9;
		
		public static function getConfigClass(ID:int):Class
		{
			var configClass:Class = null;
			switch(ID)
			{
				case CHALLENGE_CENTER:
					configClass = ChallengeCenterConfig;
					break;
			}
			return configClass;
		}
		
		public function parse(xml:XML):void
		{
			
		}
	}
}