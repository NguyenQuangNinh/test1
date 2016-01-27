package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class PaymentType extends Enum
	{		
		public static const NONE:PaymentType		= new PaymentType(0, 0, "none");
		public static const GOLD:PaymentType 		= new PaymentType(1, 1, "silver", "Bạc");
		public static const XU_LOCK:PaymentType 	= new PaymentType(2, 21, "xu_lock", "Vàng Khóa");
		public static const XU_NORMAL:PaymentType	= new PaymentType(3, 8, "gold", "Vàng");
		public static const HONOR:PaymentType	 	= new PaymentType(4, 33, "honor", "Uy Danh");
		public static const SOUL_SCORE:PaymentType 	= new PaymentType(5, 37, "soul_score");
		public static const DEDICATE_POINT:PaymentType 	= new PaymentType(6, 47, "dedicatepoint", "Điểm cống hiến");
		
		public var displayName	:String = "";
		public var itemType		:int = 0;
		
		public function PaymentType(ID:int, itemType:int, name:String = "", displayName:String = "" ) {
			super(ID, name);
			this.displayName = displayName;
			this.itemType = itemType;
		}
	}

}