package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SoundID extends Enum
	{
		
		public static const BG_MUSIC_OUT_GAME:SoundID = new SoundID(1, "bg_music_out_game");
		public static const BG_MUSIC_IN_GAME:SoundID = new SoundID(2, "bg_music_in_game");
		
		public static const EFFECT_SOUND_1:SoundID = new SoundID(3, "effect_sound_1");
		public static const EFFECT_SOUND_2:SoundID = new SoundID(4, "effect_sound_2");
		public static const EFFECT_SOUND_3:SoundID = new SoundID(5, "effect_sound_3");

		private static var outgameMusicList:Array = [6,7,8,9,10,11,12,13];

		public static function randomOutgameMusicID():int {
			var index:int = Math.floor(Math.random()*outgameMusicList.length);
			return outgameMusicList[index] as int;
		}

		public function SoundID(ID:int, name:String = "") 
		{
			super(ID, name);			
		}
		
	}

}