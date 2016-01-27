package game.enum 
{
	import core.util.Enum;

	import game.data.xml.DataType;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemType extends Enum
	{
		public static const EMPTY_SLOT 			:ItemType = new ItemType(0, null, "");
		public static const GOLD 				:ItemType = new ItemType(1, DataType.ITEM, "gold");
		public static const UNIT 				:ItemType = new ItemType(2, DataType.CHARACTER, "unit");	//unit character
		public static const EXP 				:ItemType = new ItemType(3, DataType.ITEM, "exp");
		public static const NORMAL_CHEST 		:ItemType = new ItemType(4, DataType.ITEMCHEST, "Vào túi đồ để mở. Khi mở ra sẽ nhận được tất cả các vật phẩm bên dưới.");
		public static const LUCKY_CHEST 		:ItemType = new ItemType(5, DataType.ITEMCHEST, "Vào túi đồ để mở. Khi mở ra nhận được ngẫu nhiên 1 trong các vật phẩm bên dưới.");
		public static const CHOICE_CHEST 		:ItemType = new ItemType(6, DataType.ITEMCHEST, "Vào túi đồ để mở. Khi mở ra sẽ được tùy chọn 1 trong các vật phẩm bên dưới.");
		public static const ITEM_SET 			:ItemType = new ItemType(7, DataType.ITEMCHEST, "Có thể nhận được tất cả các vật phẩm bên dưới.");
		public static const XU 					:ItemType = new ItemType(8, DataType.ITEM, "xu");
		public static const BROKEN_SCROLL 		:ItemType = new ItemType(9, DataType.ITEM, "Sách Trận Hình");
		public static const SKILL_SCROLL 		:ItemType = new ItemType(10, DataType.ITEM, "Võ Kinh");
		public static const FORMATION_TYPE 		:ItemType = new ItemType(11, DataType.ITEM, "formation type");
		public static const HP_POTION_ITEM 		:ItemType = new ItemType(12, DataType.ITEM, "hp potion item");
		public static const HP_POTION_INFO 		:ItemType = new ItemType(13, DataType.ITEM, "hp potion info");
		public static const GOLD_ITEM 			:ItemType = new ItemType(14, DataType.ITEM, "gold item");
		public static const ITEM_SOUL 			:ItemType = new ItemType(15, DataType.ITEMSOUL, "item soul");
		public static const ITEM_BAD_SOUL 		:ItemType = new ItemType(16, DataType.ITEMSOUL, "item bad soul");
		public static const XU_KHOA		 		:ItemType = new ItemType(21, DataType.ITEM, "xu khóa");
		public static const NONE		 		:ItemType = new ItemType(22, null, "none");
		public static const SCORE_QUEST_DAILY	:ItemType = new ItemType(23, DataType.ITEM, "score quest daily");
		public static const SKILL_SCROLL_FIRE 	:ItemType = new ItemType(24, DataType.ITEM, "fire skill scroll");
		public static const SKILL_SCROLL_EARTH 	:ItemType = new ItemType(25, DataType.ITEM, "earth skill scroll");
		public static const SKILL_SCROLL_METAL 	:ItemType = new ItemType(26, DataType.ITEM, "metal skill scroll");
		public static const SKILL_SCROLL_WATER 	:ItemType = new ItemType(27, DataType.ITEM, "water skill scroll");
		public static const SKILL_SCROLL_WOOD 	:ItemType = new ItemType(28, DataType.ITEM, "wood skill scroll");
		public static const ITEM_SHOP_HERO		:ItemType = new ItemType(29, DataType.ITEM, "item shop hero");
		public static const HONOR				:ItemType = new ItemType(33, DataType.ITEM, "honor");
		public static const FORMATION_TYPE_SCROLL :ItemType = new ItemType(35, DataType.ITEM, "sách trận hình");//Item dung de thang cap tran hinh
		public static const BONUS_TOWER_MODE	:ItemType = new ItemType(36, DataType.ITEM, "bonus tower mode");// SU DUNG ITEM gap doi phan thuong tower mode
		public static const SOUL_CRAFT_SCORE	:ItemType = new ItemType(37, DataType.ITEM, "soul craft score");// diem tich luy khi boi menh
		public static const AP					:ItemType = new ItemType(38, DataType.ITEM, "AP");// Item the luc
		public static const MASTER_INVITATION_CHEST	:ItemType = new ItemType(39, DataType.ITEMCHEST, "Vào túi đồ để mở. Khi mở ra chiêu mộ được ngẫu nhiên 1 trong các cao nhân bên dưới.");//Ruong cao nhan
		public static const PRESENT_VIP_CHEST	:ItemType = new ItemType(40, DataType.ITEMCHEST, "Vào túi đồ để mở. Khi mở ra nhận được ngẫu nhiên 1 trong các vật phẩm bên dưới.");//Ruong qua vip
		public static const AUTO_OPEN_CHEST		:ItemType = new ItemType(41, DataType.ITEMCHEST, "Khi nhận sẽ được ngẫu nhiên 1 trong các vật phẩm bên dưới.");//Ruong qua tu dong mo khi nhan vao thung do
		public static const ITEM_EVENT_RECIPE:ItemType = new ItemType(42, DataType.ITEM, "item event recipe");//item event
		public static const SPEAKER				:ItemType = new ItemType(46, DataType.ITEM, "loa");
		public static const DEDICATE_POINT		:ItemType = new ItemType(47, DataType.ITEM, "Điểm cống hiến");
		public static const KEEP_LUCK		:ItemType = new ItemType(48, DataType.ITEM, "Giữ chúc phúc khi qua ngày. Dùng trong Thăng sao nhân vật.");
		public static const CHANGE_SKILL_RECIPE		:ItemType = new ItemType(49, DataType.ITEM, "Tẩy Tủy Kinh. Dùng để đổi kỹ năng nhân vật");
		public static const MERGE_ITEM			:ItemType = new ItemType(100, DataType.ITEM, "merge item reward");//abstract item (merge include groupReward and rankReward weekly for challenge)
		public static const DIVINE_WEAPON		:ItemType = new ItemType(50, DataType.DIVINEWEAPON, "Trang bị thần binh");
		public static const DIVINE_WEAPON_MATERIAL		:ItemType = new ItemType(51, DataType.ITEM, "Nguyên liệu nâng cấp trang bị thần binh");

		public function ItemType(ID:int, dataType:DataType, name:String = ""):void
		{
			super(ID, name);
			this.dataType = dataType;
		}

		public var dataType:DataType;
	}
}