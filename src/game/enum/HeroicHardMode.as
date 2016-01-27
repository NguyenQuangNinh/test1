package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicHardMode extends Enum
	{
		public static const EASY	:HeroicHardMode = new HeroicHardMode(0, "Dễ");
		public static const NORMAL	:HeroicHardMode = new HeroicHardMode(1, "Thường");
		public static const HARD	:HeroicHardMode = new HeroicHardMode(2, "Khó");
		
		public function HeroicHardMode(ID:int, name:String):void {
			super(ID, name)
		}
	}

}