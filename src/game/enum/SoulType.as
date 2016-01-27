package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SoulType extends Enum
	{
		public static const SOUL_RECIPE:SoulType					= new SoulType(1000, "dan khi hoan");
		public static const SOUL_STRENGTH:SoulType 					= new SoulType(1, "suc manh");
		public static const SOUL_ATTACK_POWER:SoulType 				= new SoulType(2, "ngoai cong");
		public static const SOUL_CRITICAL_CHANCE:SoulType 			= new SoulType(3, "bao kich");
		public static const SOUL_CRITICAL_DAMAGE:SoulType 			= new SoulType(4, "sat thuong bao kich");
		public static const SOUL_MAGICAL:SoulType 					= new SoulType(5, "noi cong");
		public static const SOUL_MAGICAL_CHANCE:SoulType 			= new SoulType(6, "noi cong bao kich");
		public static const SOUL_MAGICAL_CHANCE_DAMAGE:SoulType		= new SoulType(7, "sat thuong bao kich noi cong");
		public static const SOUL_ACCURACY:SoulType					= new SoulType(8, "than phap");
		public static const SOUL_PENETRATION:SoulType				= new SoulType(9, "xuyen thau");
		public static const SOUL_DO_DON:SoulType					= new SoulType(10, "do don");
		public static const SOUL_INTELLIGENCE:SoulType				= new SoulType(11, "tri tue");
		public static const SOUL_ARMOR:SoulType						= new SoulType(12, "khang ngoai cong");
		public static const SOUL_MAGICAL_RESIST:SoulType			= new SoulType(13, "khang noi cong");
		public static const SOUL_FIRE_ELEMENT_RESIST:SoulType		= new SoulType(14, "khang hoa");
		public static const SOUL_EARTH_ELEMENT_RESIST:SoulType		= new SoulType(15, "khang tho");
		public static const SOUL_METAL_ELEMENT_RESIST:SoulType		= new SoulType(16, "khang kim");
		public static const SOUL_WOOD_ELEMENT_RESIST:SoulType		= new SoulType(17, "khang moc");
		public static const SOUL_WATER_ELEMENT_RESIST:SoulType		= new SoulType(18, "khang thuy");
		public static const SOUL_HEAL_POINT:SoulType				= new SoulType(19, "sinh luc");
		public static const SOUL_FIVE_ELEMENTS_RESIST:SoulType		= new SoulType(20, "khang ngu hanh");
		
		public function SoulType(ID:int, name:String = "") 		
		{
			super(ID, name);
		}
		
	}

}