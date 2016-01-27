package game.enum
{
	import core.util.Enum;
	
	public class Element extends Enum
	{
		public static const NEUTRAL	:Element = new Element(0, 0, 0, 0, 0, [null, null], "Vô Hệ", "Vô hệ");
		public static const FIRE	:Element = new Element(1, 2, 5, 3, 4, ["resource/image/ui/create_char/caibang_nu.png","resource/image/ui/create_char/caibang_nam.png"], "Cái Bang", "Hỏa");
		public static const EARTH	:Element = new Element(2, 3, 1, 4, 5, ["resource/image/ui/create_char/vodang_nu.png","resource/image/ui/create_char/vodang_nam.png"], "Võ Đang", "Thổ");
		public static const METAL	:Element = new Element(3, 4, 2, 5, 1, [null, "resource/image/ui/create_char/thieulam.png"], "Thiếu Lâm", "Kim");
		public static const WATER	:Element = new Element(4, 5, 3, 1, 2, ["resource/image/ui/create_char/ngami.png", null], "Nga Mi", "Thủy");
		public static const WOOD	:Element = new Element(5, 1, 4, 2, 3, ["resource/image/ui/create_char/ngudoc_nu.png","resource/image/ui/create_char/ngudoc_nam.png"], "Ngũ Độc", "Mộc");
		
		public var create:int;
		public var created:int;
		public var destroy:int;
		public var resist:int;
		public var avatarURLs:Array;
		public var elementName:String;
		
		public function Element(ID:int, create:int, created:int, destroy:int, resist:int, avatarURLs:Array, name:String="", elementName:String = "")
		{
			super(ID, name);
			this.create 	= create;
			this.created 	= created;
			this.destroy 	= destroy;
			this.resist 	= resist;
			this.avatarURLs = avatarURLs;
			this.elementName = elementName;
		}
	}
}