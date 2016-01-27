package game.enum
{
	import core.util.Enum;

	public class ShopID extends Enum
	{
		public static const ITEM				:ShopID = new ShopID(1);
		public static const HERO				:ShopID = new ShopID(2);
		public static const SOUL				:ShopID = new ShopID(3);
		public static const SECRET_MERCHANT		:ShopID = new ShopID(4);
		public static const VIP					:ShopID = new ShopID(5);//Ngu Phai Dai De Tu
		public static const GUILD_ITEM			:ShopID = new ShopID(6);

		
		public function ShopID(ID:int, name:String = ""):void
		{
			super(ID, name);
		}
	}
}