package game.enum 
{
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class DragDropEvent 
	{			
		public static const MAX_TIME_FOR_CLICK:int = 500;
		
		public static const FROM_INVENTORY_UNIT:int = 0;
		public static const FROM_FORMATION:int = 1;
		public static const FROM_LEVEL_UP:int = 2;
		public static const FROM_SOUL_INVENTORY:int = 3;		
		public static const FROM_NODE_OF_CHARACTER:int = 4;
		public static const FROM_SKILL_UPGRADE:int = 5;
		public static const FROM_QUEST_TRANSPORT:int = 6;
		static public const FROM_HEROIC_FORMATION:int = 7;
		static public const FROM_INVENTORY_ITEM:int = 8;
		public static const FROM_MERGE_SOUL:int = 9;
		
		public static const TYPE_CHANGE_FORMATION			:int = 100;
		public static const CHARACTER_LEVEL_UP				:int = 101;
		public static const REMOVE_FROM_ENHANCEMENT_LIST	:int = 102;
		public static const REMOVE_CHARACTER_LEVEL_UP		:int = 103;
		public static const TYPE_CHANGE_FORMATION_CHALLENGE	:int = 104;
		public static const HEROIC_CHANGE_FORMATION			:int = 105;
	}

}