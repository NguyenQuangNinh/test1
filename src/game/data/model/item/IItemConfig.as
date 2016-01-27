package game.data.model.item 
{
	import game.enum.ItemType;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public interface IItemConfig 
	{
		function getIconURL() : String;
		function getName() : String;
		function getDescription() : String;
		function getType(): ItemType;
		function getID(): int;
		//function getAnimURL(): String;
		
		//function getQuantity():int;
	}
	
}