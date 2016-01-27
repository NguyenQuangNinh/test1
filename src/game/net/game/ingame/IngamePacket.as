package game.net.game.ingame 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class IngamePacket 
	{
		public static const CREATE_OBJECT:int = 0;
		public static const UPDATE_OBJECT:int = 1;
		public static const DESTROY_OBJECT:int = 3;
		public static const UPDATE_HP:int = 4;
		public static const OBJECT_STATUS:int = 5;
		public static const CREATE_BULLET:int = 6;
		public static const CAST_SKILL:int = 7;
		public static const RELEASE_SKILL:int = 8;
		public static const ADD_STATUS:int = 9;
		public static const ADD_EFFECT:int = 10;
		public static const PREPARE_NEXT_WAVE:int = 11;
		public static const REMOVE_STATUS:int = 12;
		public static const UPDATE_MP:int = 13;
		public static const CHANGE_CHARACTER_MODEL:int = 14;
		public static const SHOW_HIDE_CHARACTER:int = 15;
		public static const CHARACTER_ATTACK_SPEED:int = 16;
		public static const NEXT_WAVE_READY:int = 17;
		public static const CAST_SKILL_ERROR:int = 18;
		
		public var type:int;
		public var objectID:int;
		
		public function decode(data:ByteArray):void
		{
			
		}
	}

}