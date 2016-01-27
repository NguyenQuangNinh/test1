package game.data.vo.reward 
{
	import game.data.model.item.IItemConfig;
	import game.enum.ItemType;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class RewardInfo 
	{
		public var itemConfig 	:IItemConfig;
		public var quantity 	:int;
		public var itemID		:int;
		public var itemType	:ItemType;
	}

}