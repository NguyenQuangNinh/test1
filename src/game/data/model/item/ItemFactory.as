package game.data.model.item
{
	import flash.utils.Dictionary;
	
	import core.util.Utility;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemXML;
	import game.data.xml.item.MergeItemXML;
	import game.enum.ItemType;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemFactory
	{
		private static const itemClassDict:Dictionary = new Dictionary();
		
		{
			itemClassDict[ItemType.EMPTY_SLOT] 			= Item;
			itemClassDict[ItemType.UNIT] 				= Item;		
			itemClassDict[ItemType.GOLD] 				= Item;
			itemClassDict[ItemType.GOLD_ITEM] 			= Item;
			itemClassDict[ItemType.BROKEN_SCROLL] 		= Item;
			itemClassDict[ItemType.HONOR] 				= Item;
			itemClassDict[ItemType.HP_POTION_ITEM] 		= Item;
			itemClassDict[ItemType.SKILL_SCROLL] 		= Item;
			itemClassDict[ItemType.SCORE_QUEST_DAILY] 	= Item;
			itemClassDict[ItemType.SKILL_SCROLL_FIRE] 	= Item;
			itemClassDict[ItemType.SKILL_SCROLL_EARTH] 	= Item;
			itemClassDict[ItemType.SKILL_SCROLL_METAL] 	= Item;
			itemClassDict[ItemType.SKILL_SCROLL_WATER] 	= Item;
			itemClassDict[ItemType.SKILL_SCROLL_WOOD] 	= Item;
			itemClassDict[ItemType.FORMATION_TYPE_SCROLL] = Item;
			itemClassDict[ItemType.LUCKY_CHEST] 		= Item;
			itemClassDict[ItemType.MASTER_INVITATION_CHEST] = Item;
			itemClassDict[ItemType.PRESENT_VIP_CHEST] 	= Item;
			itemClassDict[ItemType.BONUS_TOWER_MODE] 	= Item;
			itemClassDict[ItemType.AP] 					= Item;
			
			itemClassDict[ItemType.ITEM_SOUL] 			= SoulItem;
			itemClassDict[ItemType.ITEM_BAD_SOUL] 		= SoulItem;	
			
			itemClassDict[ItemType.AUTO_OPEN_CHEST] 	= Item;		
			itemClassDict[ItemType.ITEM_EVENT_RECIPE] 	= Item;		
			itemClassDict[ItemType.SPEAKER]			 	= Item;		
			
			itemClassDict[ItemType.MERGE_ITEM] 			= MergeItem;
			itemClassDict[ItemType.ITEM_SET] 			= Item;
			itemClassDict[ItemType.NORMAL_CHEST] 			= Item;
			itemClassDict[ItemType.DEDICATE_POINT] 			= Item;
			itemClassDict[ItemType.SOUL_CRAFT_SCORE] 			= Item;
			itemClassDict[ItemType.KEEP_LUCK] 			= Item;
			itemClassDict[ItemType.CHANGE_SKILL_RECIPE] 			= Item;

			itemClassDict[ItemType.DIVINE_WEAPON] 			= DivineWeaponItem;
			itemClassDict[ItemType.DIVINE_WEAPON_MATERIAL] 			= Item;

		}
		
		public static function createItem(type:ItemType, id:int, defaultEmptyItemType:Class = null):BaseItem
		{
			var obj:Item;
			
			if (type == ItemType.EMPTY_SLOT && id == 0)
			{
				if (defaultEmptyItemType != null)
				{
					obj = new defaultEmptyItemType();
					//obj.init(id, type);
					//return obj;
				}
				else
				{
					obj = new Item();
					
				}
				
				obj.init(id, type);
				return obj;
			}
			
			var itemClass:Class = itemClassDict[type];
			if (itemClass != null)
			{
				obj = new itemClass();
				obj.itemXML = buildItemConfig(type, id) as ItemXML;
				//obj.init(id, type);
				return obj;
			}
			return null;
		}
		
		public static function buildItemConfig(type:ItemType, id:int):IItemConfig
		{
			var itemConfig:IItemConfig;
			var item:ItemXML;
			
			switch (type)
			{
				case ItemType.UNIT: 
					itemConfig = Game.database.gamedata.getData(DataType.CHARACTER, id) as IItemConfig;
					break;
				case ItemType.ITEM_SET: 
				case ItemType.NORMAL_CHEST:
					itemConfig = Game.database.gamedata.getData(DataType.ITEMCHEST, id) as IItemConfig;
					break;
				case ItemType.LUCKY_CHEST: 
				case ItemType.PRESENT_VIP_CHEST: 
				case ItemType.AUTO_OPEN_CHEST:	
				case ItemType.MASTER_INVITATION_CHEST: 
					itemConfig = Game.database.gamedata.getData(DataType.ITEMCHEST, id) as IItemConfig;
					break;
				case ItemType.ITEM_SOUL: 
				case ItemType.ITEM_BAD_SOUL:
					itemConfig = Game.database.gamedata.getData(DataType.ITEMSOUL, id) as IItemConfig;
					break;
				
				case ItemType.SCORE_QUEST_DAILY: 
					item = new ItemXML();	
					item.type = type;
					item.iconURL = "resource/image/item/item_xudatau.png";
					item.name = "Điểm tích lũy nhiệm vụ";
					item.description = "Điểm tích lũy nhiệm vụ dã tẩu. Tích lũy càng nhiều nhận càng nhiều phần thưởng.";
					itemConfig = item;
					break;
				
				case ItemType.EXP: 
					item = new ItemXML();
					item.type = type;
					item.iconURL = "resource/image/item/icon_exp.png";
					item.name = "Kinh Nghiệm";
					item.description = "Kinh nghiệm dùng để nâng cấp tài khoản nhân vật.";
					itemConfig = item;
					break;
				
				case ItemType.GOLD: 
					item = new ItemXML();
					item.type = type;
					item.iconURL = "resource/image/item/item_bac.png";
					item.name = "Bạc";
					item.description = "Bạc dùng để nâng cấp nhân vật, nâng cấp kỹ năng, bói mệnh khí.";
					itemConfig = item;
					break;
				
				case ItemType.XU_KHOA: 
				case ItemType.XU: 
					item = new ItemXML();
					item.type = type;
					item.iconURL = "resource/image/item/item_vang.png";
					item.name = "Vàng"
					item.description = "Vàng dùng để mua vật phẩm, mua lượt đấu và hoàn thành nhanh.";
					itemConfig = item;
					break;
					
				case ItemType.AP: 
					item = new ItemXML();
					item.type = type;
					item.iconURL = "resource/image/item/item_theluc.png";
					item.name = "Thể Lực";
					item.description = "Thể lực cần khi vượt các ải chiến dịch.";					
					itemConfig = item;
					break;
				
				case ItemType.HONOR: 
					item = new ItemXML();
					item.type = type;
					item.iconURL = "resource/image/item/item_uydanh.png";
					item.name = "Uy Danh";
					item.description = "Uy Danh dùng để chiêu mộ các vị đại hiệp.";
					itemConfig = item;
					break;
				case ItemType.DEDICATE_POINT: 
					item = new ItemXML();
					item.type = type;
					item.iconURL = "resource/image/item/item_diemconghien.png";
					item.name = "Điểm cống hiến";
					item.description = "Điểm cống hiến bang dùng để nâng cấp bang và mua item trong shop bang.";
					itemConfig = item;
					break;
				case ItemType.SOUL_CRAFT_SCORE:
					item = new ItemXML();
					item.type = type;
					item.iconURL = "resource/image/item/diemmenhkhi.png";
					item.name = "Điểm tích lũy bói mệnh khí";
					item.description = "Điểm tích lũy khi bói mệnh khí.";
					itemConfig = item;
					break;
				case ItemType.MERGE_ITEM:
					item = new MergeItemXML();	
					item.type = type;
					itemConfig = item;
					break;
				case ItemType.DIVINE_WEAPON:
					itemConfig = Game.database.gamedata.getData(DataType.DIVINEWEAPON, id) as IItemConfig;
					break;

				default: 
					itemConfig = Game.database.gamedata.getData(DataType.ITEM, id) as IItemConfig;
			}
			
			return itemConfig;
		}
	}

}