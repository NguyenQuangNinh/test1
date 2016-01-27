package game.enum 
{
	import core.util.Enum;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterRarity extends Enum 
	{
		public static const WHITE	:CharacterRarity = new CharacterRarity(1, "white", "resource/anim/font/font_item_name_trang.banim");
		public static const GREEN	:CharacterRarity = new CharacterRarity(2, "green", "resource/anim/font/font_item_name.banim");
		public static const BLUE	:CharacterRarity = new CharacterRarity(3, "blue", "resource/anim/font/font_item_name_cyan.banim");
		public static const RED		:CharacterRarity = new CharacterRarity(4, "red", "resource/anim/font/font_item_name_do.banim");
		public static const PURPLE	:CharacterRarity = new CharacterRarity(5, "purple", "resource/anim/font/font_item_name_tim.banim");
		public static const YELLOW	:CharacterRarity = new CharacterRarity(6, "yellow", "resource/anim/font/font_item_name_yellow.banim");
		
		public var rarityName	:String;
		public var fontURL		:String;
		
		public function CharacterRarity(ID:int, name:String = "", fontURL:String = "") {
			super(ID, name);
			this.rarityName	= name;
			this.fontURL 	= fontURL;
		}
		
	}

}