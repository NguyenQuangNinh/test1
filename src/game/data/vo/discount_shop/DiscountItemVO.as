/**
 * Created by NINH on 1/20/2015.
 */
package game.data.vo.discount_shop
{

	import game.enum.ItemType;

	public class DiscountItemVO
	{
		public var ID:int;
		public var itemID:int;
		public var itemType:ItemType;
		public var quantity:int;
		public var numItemLeft:int;
		public var maxBuyTimes:int;
		public var numBuyLeft:int;
		public var orgPrice:int;
		public var discountedPrice:int;
	}
}
