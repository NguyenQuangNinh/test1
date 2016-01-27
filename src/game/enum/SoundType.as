package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SoundType extends Enum
	{
		
		public static const BG_MUSIC:SoundType = new SoundType(1, "bg_music");
		public static const EFFECT_SOUND:SoundType = new SoundType(2, "effect_sound");
		
		public function SoundType(ID:int, name:String = "") 
		{
			super(ID, name);
		}
		
	}

}