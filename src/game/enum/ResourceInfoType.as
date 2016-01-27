package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResourceInfoType extends Enum
	{
		public static const BACH_LAU:ResourceInfoType = new ResourceInfoType(1, "Bạch Lâu");
		public static const THANH_LAU:ResourceInfoType = new ResourceInfoType(2, "Thanh Lâu");
		public static const HONG_LAU:ResourceInfoType = new ResourceInfoType(3, "Hồng Lâu");
		public static const KIM_LAU:ResourceInfoType = new ResourceInfoType(4, "Kim Lâu");		
		
		public function ResourceInfoType(id:int, name:String = "") 
		{
			super(id, name);
		}
			
	}

}